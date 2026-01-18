//
//  AddItemView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 21/01/25.
//

import SwiftUI
import PhotosUI

struct AddItemView: View {
    @ObservedObject var stuffController = StuffController()
    @ObservedObject var authService = AuthService()
    @ObservedObject var imageRecognitionService = ImageRecognitionService()
    @State var nameValue = ""
    @State private var dateValue = Date()
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var isSubmitting = false
    @State private var showingRecognitionResults = false
    
    var body: some View {
        ZStack {
            VStack {
                headerView
                photoPickerSection
                formSection
                submitButton
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            stuffController.fetchData()
        }
        .onChange(of: selectedPhoto) { newItem in
            Task {
                if let newItem = newItem,
                   let data = try? await newItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await MainActor.run {
                        selectedImage = image
                        // Clear previous recognition results
                        imageRecognitionService.clearResults()
                    }
                    await imageRecognitionService.recognizeImage(image)
                }
            }
        }
        .alert("Info", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    // MARK: - Header View
    private var headerView: some View {
        HStack {
            Spacer()
            Text("Tambahkan Barang")
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.top, 36)
                .padding(.bottom, 24)
            Spacer()
        }
        .padding(.top, 48)
        .background(headerGradient)
        .cornerRadius(28)
    }
    
    // MARK: - Header Gradient
    private var headerGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56),
                Color(red: 255/255, green: 57/255, blue: 19/255, opacity: 0.47)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    // MARK: - Photo Picker Section
    private var photoPickerSection: some View {
        VStack(spacing: 12) {
            photoPicker
            if let selectedImage = selectedImage {
                mlRecognitionSection(selectedImage: selectedImage)
            }
        }
        .padding(.all)
    }
    
    // MARK: - Photo Picker
    private var photoPicker: some View {
        PhotosPicker(selection: $selectedPhoto, matching: .images) {
            HStack(spacing: 16) {
                Spacer()
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                } else {
                    photoPlaceholder
                }
                Spacer()
            }
        }
        .background(Color(red: 0.937, green: 0.937, blue: 0.942))
        .cornerRadius(12)
    }
    
    // MARK: - Photo Placeholder
    private var photoPlaceholder: some View {
        VStack {
            Text("Tambah gambar barang untuk kemudahan dalam melihat barang!")
                .fontWeight(.medium)
                .multilineTextAlignment(.leading)
                .foregroundColor(.gray)
            Image(systemName: "photo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
                .opacity(0.5)
                .frame(width: 100, height: 100)
                .padding(.vertical, 24)
        }
    }
    
    // MARK: - ML Recognition Section
    private func mlRecognitionSection(selectedImage: UIImage) -> some View {
        VStack(spacing: 8) {
            recognitionHeader
            if !imageRecognitionService.recognitionResults.isEmpty {
                recognitionResults
            }
            if let errorMessage = imageRecognitionService.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
        .background(Color(red: 0.95, green: 0.95, blue: 0.95))
        .cornerRadius(8)
    }
    
    // MARK: - Recognition Header
    private var recognitionHeader: some View {
        VStack(spacing: 4) {
            HStack {
                Text("AI Recognition")
                    .font(.headline)
                    .foregroundColor(.primary)
                Spacer()
                if imageRecognitionService.isProcessing {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Button("Recognize") {
                        Task {
                            await imageRecognitionService.recognizeImage(selectedImage!)
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.blue)
                }
            }
            
            #if targetEnvironment(simulator)
            Text("Demo Mode - Gunakan device fisik untuk hasil terbaik")
                .font(.caption2)
                .foregroundColor(.orange)
                .multilineTextAlignment(.center)
            #endif
        }
    }
    
    // MARK: - Recognition Results
    private var recognitionResults: some View {
        VStack(alignment: .leading, spacing: 4) {
            ForEach(imageRecognitionService.recognitionResults.prefix(3), id: \.identifier) { result in
                HStack {
                    Text(result.identifier.capitalized)
                        .font(.caption)
                        .foregroundColor(.primary)
                    Spacer()
                    Text("\(Int(result.confidence * 100))%")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(6)
            }
            
            if let suggestedName = imageRecognitionService.getSuggestedItemName() {
                Button("Use: \(suggestedName)") {
                    nameValue = suggestedName
                }
                .font(.caption)
                .foregroundColor(.blue)
                .padding(.top, 4)
            }
        }
    }
    
    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 16) {
            nameField
            datePicker
        }
        .padding(.horizontal)
    }
    
    // MARK: - Name Field
    private var nameField: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Nama Barang")
                Spacer()
            }
            TextField("Masukkan nama barang", text: $nameValue)
                .padding(.all)
                .overlay(RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray, lineWidth: 1))
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
    }
    
    // MARK: - Date Picker
    private var datePicker: some View {
        DatePicker(
            selection: $dateValue,
            displayedComponents: [.date],
            label: { Text("Tanggal Kadaluarsa Barang") }
        )
    }
    
    // MARK: - Submit Button
    private var submitButton: some View {
        VStack {
            Spacer()
            Button(action: {
                Task {
                    await addItem()
                }
            }) {
                submitButtonContent
            }
            .disabled(nameValue.isEmpty || isSubmitting)
            .foregroundColor(.white)
            .background(submitButtonBackground)
            .cornerRadius(8)
            .padding()
        }
    }
    
    // MARK: - Submit Button Content
    private var submitButtonContent: some View {
        Group {
            if isSubmitting {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .scaleEffect(0.8)
            } else {
                Text("Tambah")
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
            }
        }
    }
    
    // MARK: - Submit Button Background
    private var submitButtonBackground: some View {
        Group {
            if nameValue.isEmpty || isSubmitting {
                Color.gray
            } else {
                submitGradient
            }
        }
    }
    
    // MARK: - Submit Gradient
    private var submitGradient: LinearGradient {
        LinearGradient(
            colors: [
                Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56),
                Color(red: 255/255, green: 57/255, blue: 19/255, opacity: 0.47)
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
    }
    
    private func addItem() async {
        guard !nameValue.isEmpty else {
            await MainActor.run {
                alertMessage = "Nama barang tidak boleh kosong"
                showingAlert = true
            }
            return
        }
        
        await MainActor.run {
            isSubmitting = true
        }
        
        // Try API first, fallback to local storage
        if let token = authService.authToken {
            let newItem = await stuffController.createItemViaAPI(
                name: nameValue,
                expireDate: dateValue,
                photo: selectedImage,
                authToken: token
            )
            
            await MainActor.run {
                isSubmitting = false
                
                if let item = newItem {
                    alertMessage = "Barang berhasil ditambahkan"
                    showingAlert = true
                    // Clear form
                    nameValue = ""
                    dateValue = Date()
                    selectedImage = nil
                    selectedPhoto = nil
                    imageRecognitionService.clearResults()
                } else {
                    alertMessage = stuffController.errorMessage ?? "Gagal menambahkan barang"
                    showingAlert = true
                }
            }
        } else {
            // Fallback to local storage
            await MainActor.run {
                stuffController.createStuff(name: nameValue, expire: dateValue)
                alertMessage = "Barang berhasil ditambahkan (offline mode)"
                showingAlert = true
                // Clear form
                nameValue = ""
                dateValue = Date()
                selectedImage = nil
                selectedPhoto = nil
                imageRecognitionService.clearResults()
                isSubmitting = false
            }
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
