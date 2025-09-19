//
//  HomeView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct HomeView: View {
    @ObservedObject var stuffController = StuffController()
    @ObservedObject var authService = AuthService()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            VStack {
                // Header with user info
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.leading)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selamat datang,")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(authService.userData?.name ?? "User")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.black)
                    }
                    Spacer()
                }
                .padding(.top, 60)
                .padding(.bottom)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)
                        )
                )
                
                // Statistics
                HStack {
                    VStack {
                        Text("Jumlah Barang")
                            .font(.headline)
                        Text("\(stuffController.stuff.count)")
                            .font(.system(size: 27, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Kadaluarsa Terdekat")
                            .font(.headline)
                        if let nearestExpiring = stuffController.expiringItems.first {
                            Text(nearestExpiring.expireDate.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 25, weight: .bold))
                        } else {
                            Text("Tidak ada")
                                .font(.system(size: 25, weight: .bold))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.vertical)
                
                // Expiring Items Section
                VStack(alignment: .center) {
                    HStack {
                        Text("Daftar Menuju Kadaluwarsa")
                            .font(.headline)
                            .padding(.bottom, 6)
                        Spacer()
                        if stuffController.isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle())
                                .scaleEffect(0.8)
                        }
                    }
                    .padding(.horizontal)
                    
                    if stuffController.expiringItems.isEmpty && !stuffController.isLoading {
                        VStack {
                            Image(systemName: "checkmark.circle")
                                .font(.system(size: 50))
                                .foregroundColor(.green)
                            Text("Tidak ada barang yang akan kadaluarsa")
                                .font(.headline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .padding()
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(stuffController.expiringItems.prefix(5)) { item in
                                    ExpiringItemCard(item: item)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                Spacer()
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            loadData()
        }
        .refreshable {
            await refreshData()
        }
        .alert("Info", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadData() {
        Task {
            if let token = authService.authToken {
                // Load both items and expiring items
                await withTaskGroup(of: Void.self) { group in
                    group.addTask {
                        await stuffController.fetchItemsFromAPI(authToken: token)
                    }
                    group.addTask {
                        await stuffController.fetchExpiringItemsFromAPI(authToken: token)
                    }
                }
                
                await MainActor.run {
                    if let error = stuffController.errorMessage {
                        alertMessage = error
                        showingAlert = true
                    }
                }
            } else {
                // Fallback to local storage
                stuffController.fetchData()
            }
        }
    }
    
    private func refreshData() async {
        if let token = authService.authToken {
            await withTaskGroup(of: Void.self) { group in
                group.addTask {
                    await stuffController.fetchItemsFromAPI(authToken: token)
                }
                group.addTask {
                    await stuffController.fetchExpiringItemsFromAPI(authToken: token)
                }
            }
            
            await MainActor.run {
                if let error = stuffController.errorMessage {
                    alertMessage = error
                    showingAlert = true
                }
            }
        }
    }
}

struct ExpiringItemCard: View {
    let item: Stuff
    
    var daysUntilExpiry: Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: Date(), to: item.expireDate)
        return components.day ?? 0
    }
    
    var expiryStatus: (text: String, color: Color) {
        if daysUntilExpiry < 0 {
            return ("Expired", .red)
        } else if daysUntilExpiry <= 3 {
            return ("\(daysUntilExpiry) Hari tersisa", .red)
        } else if daysUntilExpiry <= 7 {
            return ("\(daysUntilExpiry) Hari tersisa", .orange)
        } else {
            return ("\(daysUntilExpiry) Hari tersisa", .green)
        }
    }
    
    var body: some View {
        HStack {
            // Item image
            if let photoUrl = item.photoUrl, !photoUrl.isEmpty {
                AsyncImage(url: URL(string: photoUrl)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Image(systemName: "photo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 80, height: 80)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .multilineTextAlignment(.trailing)
                
                Text(expiryStatus.text)
                    .font(.title2)
                    .foregroundColor(expiryStatus.color)
                    .fontWeight(.semibold)
                
                Text("Expired: \(item.expireDate.formatted(date: .abbreviated, time: .omitted))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.leading)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
