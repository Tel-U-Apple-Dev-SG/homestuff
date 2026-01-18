//
//  ImageRecognitionService.swift
//  homestuff-SwiftUI
//
//  Created by Assistant on 25/01/25.
//

import Foundation
import Vision
import CoreML
import UIKit

// MARK: - Recognition Result Model
struct RecognitionResult {
    let identifier: String
    let confidence: Float
    let localizedName: String?
}

// MARK: - Image Recognition Service
class ImageRecognitionService: ObservableObject {
    @Published var isProcessing = false
    @Published var recognitionResults: [RecognitionResult] = []
    @Published var errorMessage: String?
    
    private var visionModel: VNCoreMLModel?
    
    init() {
        setupVisionModel()
    }
    
    // MARK: - Setup Vision Model
    private func setupVisionModel() {
        do {
            if #available(iOS 17.0, *) {
                let model = try Model105iteration(configuration: MLModelConfiguration()).model
                visionModel = try VNCoreMLModel(for: model)
            } else {
                visionModel = nil
            }
        } catch {
            print("Failed to load Core ML model: \(error)")
            errorMessage = "Failed to initialize image recognition model"
        }
    }
    
    // MARK: - Main Recognition Function
    func recognizeImage(_ image: UIImage) async {
        await MainActor.run {
            isProcessing = true
            errorMessage = nil
            recognitionResults = []
        }
        
        guard let cgImage = image.cgImage else {
            await MainActor.run {
                errorMessage = "Invalid image format"
                isProcessing = false
            }
            return
        }
        
        // Use Vision framework for image classification
        await performImageClassification(cgImage: cgImage)
    }
    
    // MARK: - Image Classification using Vision
    private func performImageClassification(cgImage: CGImage) async {
        // Check if we're running on simulator
        #if targetEnvironment(simulator)
        await handleSimulatorFallback()
        return
        #endif
        
        let request: VNImageBasedRequest
        if let visionModel = visionModel {
            request = VNCoreMLRequest(model: visionModel) { [weak self] request, error in
                guard let self = self else { return }
                
                if let error = error {
                    Task { @MainActor in
                        if error.localizedDescription.contains("espresso") {
                            self.errorMessage = "Vision Framework tidak tersedia di simulator. Gunakan device fisik untuk hasil terbaik."
                        } else {
                            self.errorMessage = "Recognition failed: \(error.localizedDescription)"
                        }
                        self.isProcessing = false
                    }
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation] else {
                    Task { @MainActor in
                        self.errorMessage = "No recognition results found"
                        self.isProcessing = false
                    }
                    return
                }
                
                let results = observations.prefix(5).map { observation in
                    RecognitionResult(
                        identifier: observation.identifier,
                        confidence: observation.confidence,
                        localizedName: self.getLocalizedName(for: observation.identifier)
                    )
                }.filter { $0.confidence > 0.1 }
                
                Task { @MainActor in
                    self.recognitionResults = Array(results)
                    self.isProcessing = false
                }
            }
        } else {
            request = VNClassifyImageRequest { [weak self] request, error in
                guard let self = self else { return }
                
                if let error = error {
                    Task { @MainActor in
                        // Handle specific Vision Framework errors
                        if error.localizedDescription.contains("espresso") {
                            self.errorMessage = "Vision Framework tidak tersedia di simulator. Gunakan device fisik untuk hasil terbaik."
                        } else {
                            self.errorMessage = "Recognition failed: \(error.localizedDescription)"
                        }
                        self.isProcessing = false
                    }
                    return
                }
                
                guard let observations = request.results as? [VNClassificationObservation] else {
                    Task { @MainActor in
                        self.errorMessage = "No recognition results found"
                        self.isProcessing = false
                    }
                    return
                }
                
                // Process results
                let results = observations.prefix(5).map { observation in
                    RecognitionResult(
                        identifier: observation.identifier,
                        confidence: observation.confidence,
                        localizedName: self.getLocalizedName(for: observation.identifier)
                    )
                }.filter { $0.confidence > 0.1 } // Filter low confidence results
                
                Task { @MainActor in
                    self.recognitionResults = Array(results)
                    self.isProcessing = false
                }
            }
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            await MainActor.run {
                if error.localizedDescription.contains("espresso") {
                    errorMessage = "Vision Framework tidak tersedia di simulator. Gunakan device fisik untuk hasil terbaik."
                } else {
                    errorMessage = "Failed to process image: \(error.localizedDescription)"
                }
                isProcessing = false
            }
        }
    }
    
    // MARK: - Simulator Fallback
    private func handleSimulatorFallback() async {
        // Simulate processing delay
        try? await Task.sleep(nanoseconds: 1_000_000_000) // 1 second
        
        // Provide mock results for simulator testing
        let mockResults = [
            RecognitionResult(identifier: "apple", confidence: 0.85, localizedName: "Apel"),
            RecognitionResult(identifier: "banana", confidence: 0.78, localizedName: "Pisang"),
            RecognitionResult(identifier: "orange", confidence: 0.72, localizedName: "Jeruk"),
            RecognitionResult(identifier: "bread", confidence: 0.65, localizedName: "Roti"),
            RecognitionResult(identifier: "milk", confidence: 0.58, localizedName: "Susu")
        ]
        
        await MainActor.run {
            recognitionResults = mockResults
            errorMessage = "Demo mode (Simulator) - Gunakan device fisik untuk recognition asli"
            isProcessing = false
        }
    }
    
    // MARK: - Alternative Recognition Method
    private func performAlternativeRecognition(cgImage: CGImage) async {
        // Try using VNRecognizeTextRequest as alternative
        let request = VNRecognizeTextRequest { [weak self] request, error in
            guard let self = self else { return }
            
            if let error = error {
                Task { @MainActor in
                    self.errorMessage = "Alternative recognition failed: \(error.localizedDescription)"
                    self.isProcessing = false
                }
                return
            }
            
            // This is just a fallback - in real implementation you'd use a different approach
            Task { @MainActor in
                self.errorMessage = "Recognition tidak tersedia di simulator"
                self.isProcessing = false
            }
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        do {
            try handler.perform([request])
        } catch {
            await MainActor.run {
                errorMessage = "Failed to process image: \(error.localizedDescription)"
                isProcessing = false
            }
        }
    }
    
    // MARK: - Get Suggested Item Name
    func getSuggestedItemName() -> String? {
        guard let topResult = recognitionResults.first else { return nil }
        
        // Map common object classifications to household items
        let itemMapping: [String: String] = [
            "apple": "Apel",
            "banana": "Pisang",
            "orange": "Jeruk",
            "bread": "Roti",
            "milk": "Susu",
            "cheese": "Keju",
            "egg": "Telur",
            "chicken": "Ayam",
            "fish": "Ikan",
            "rice": "Nasi",
            "pasta": "Pasta",
            "tomato": "Tomat",
            "potato": "Kentang",
            "onion": "Bawang",
            "carrot": "Wortel",
            "broccoli": "Brokoli",
            "lettuce": "Selada",
            "cucumber": "Mentimun",
            "mushroom": "Jamur",
            "lemon": "Lemon",
            "lime": "Jeruk Nipis",
            "strawberry": "Strawberry",
            "grape": "Anggur",
            "watermelon": "Semangka",
            "pineapple": "Nanas",
            "mango": "Mangga",
            "avocado": "Alpukat",
            "coconut": "Kelapa",
            "papaya": "Pepaya",
            "dragon fruit": "Buah Naga",
            "durian": "Durian",
            "rambutan": "Rambutan",
            "lychee": "Leci",
            "jackfruit": "Nangka",
            "salmon": "Salmon",
            "tuna": "Tuna",
            "shrimp": "Udang",
            "crab": "Kepiting",
            "lobster": "Lobster",
            "beef": "Daging Sapi",
            "pork": "Daging Babi",
            "lamb": "Daging Kambing",
            "turkey": "Daging Kalkun",
            "duck": "Daging Bebek",
            "yogurt": "Yogurt",
            "butter": "Mentega",
            "cream": "Krim",
            "ice cream": "Es Krim",
            "chocolate": "Cokelat",
            "candy": "Permen",
            "cookie": "Kue",
            "cake": "Kue",
            "pie": "Pie",
            "donut": "Donat",
            "pizza": "Pizza",
            "burger": "Burger",
            "sandwich": "Sandwich",
            "salad": "Salad",
            "soup": "Sup",
            "noodle": "Mie",
            "ramen": "Ramen",
            "sushi": "Sushi",
            "taco": "Taco",
            "burrito": "Burrito",
            "wine": "Wine",
            "beer": "Bir",
            "juice": "Jus",
            "coffee": "Kopi",
            "tea": "Teh",
            "water": "Air",
            "soda": "Soda",
            "energy drink": "Minuman Energi",
            "cereal": "Sereal",
            "oatmeal": "Oatmeal",
            "granola": "Granola",
            "nuts": "Kacang",
            "almond": "Almond",
            "walnut": "Kenari",
            "peanut": "Kacang Tanah",
            "cashew": "Kacang Mete",
            "pistachio": "Pistachio",
            "hazelnut": "Hazelnut",
            "macadamia": "Macadamia",
            "pecan": "Pecan",
            "sunflower seed": "Biji Bunga Matahari",
            "pumpkin seed": "Biji Labu",
            "sesame seed": "Biji Wijen",
            "flax seed": "Biji Flax",
            "chia seed": "Biji Chia",
            "quinoa": "Quinoa",
            "barley": "Jelai",
            "wheat": "Gandum",
            "corn": "Jagung",
            "soybean": "Kedelai",
            "lentil": "Lentil",
            "bean": "Kacang",
            "chickpea": "Kacang Arab",
            "black bean": "Kacang Hitam",
            "kidney bean": "Kacang Merah",
            "green bean": "Kacang Hijau",
            "peas": "Kacang Polong",
            "edamame": "Edamame",
            "tofu": "Tahu",
            "tempeh": "Tempe",
            "miso": "Miso",
            "soy sauce": "Kecap",
            "vinegar": "Cuka",
            "oil": "Minyak",
            "olive oil": "Minyak Zaitun",
            "coconut oil": "Minyak Kelapa",
            "sesame oil": "Minyak Wijen",
            "salt": "Garam",
            "pepper": "Merica",
            "sugar": "Gula",
            "honey": "Madu",
            "maple syrup": "Sirup Maple",
            "vanilla": "Vanilla",
            "cinnamon": "Kayu Manis",
            "nutmeg": "Pala",
            "cloves": "Cengkeh",
            "cardamom": "Kapulaga",
            "cumin": "Jintan",
            "coriander": "Ketumbar",
            "paprika": "Paprika",
            "chili": "Cabai",
            "basil": "Kemangi",
            "oregano": "Oregano",
            "thyme": "Thyme",
            "rosemary": "Rosemary",
            "parsley": "Peterseli",
            "cilantro": "Ketumbar",
            "mint": "Mint",
            "sage": "Sage",
            "bay leaf": "Daun Salam",
            "garlic": "Bawang Putih",
            "ginger": "Jahe",
            "galangal": "Lengkuas",
            "turmeric": "Kunyit",
            "lemongrass": "Serai",
            "kaffir lime": "Jeruk Purut",
            "curry leaf": "Daun Kari",
            "star anise": "Bunga Lawang",
            "fennel": "Adas",
            "dill": "Dill",
            "tarragon": "Tarragon",
            "marjoram": "Marjoram",
            "chives": "Kucai",
            "scallion": "Daun Bawang",
            "leek": "Daun Bawang Perai",
            "shallot": "Bawang Merah"
        ]
        
        // Try to find a mapping for the recognized object
        let identifier = topResult.identifier.lowercased()
        
        // Direct mapping
        if let mappedName = itemMapping[identifier] {
            return mappedName
        }
        
        // Partial matching for compound names
        for (key, value) in itemMapping {
            if identifier.contains(key) {
                return value
            }
        }
        
        // Return the original identifier if no mapping found
        return topResult.identifier.capitalized
    }
    
    // MARK: - Get Localized Name
    private func getLocalizedName(for identifier: String) -> String? {
        // This could be expanded to provide localized names
        // For now, return nil to use the mapping above
        return nil
    }
    
    // MARK: - Clear Results
    func clearResults() {
        recognitionResults = []
        errorMessage = nil
    }
}
