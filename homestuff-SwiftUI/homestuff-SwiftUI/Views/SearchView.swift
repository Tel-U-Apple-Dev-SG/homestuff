//
//  SearchView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var stuffController = StuffController()
    @ObservedObject var authService = AuthService()
    @State private var searchText = ""
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    var filteredItems: [Stuff] {
        if searchText.isEmpty {
            return stuffController.stuff
        } else {
            return stuffController.stuff.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                headerView()
                
                HStack {
                    Text("Daftar barang")
                        .font(.title2)
                        .padding(.leading)
                    Spacer()
                }
                
                HStack {
                    TextField("Cari barang", text: $searchText)
                        .padding(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black)
                        )
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                
                if stuffController.isLoading {
                    Spacer()
                    ProgressView("Memuat data...")
                        .progressViewStyle(CircularProgressViewStyle())
                    Spacer()
                } else if filteredItems.isEmpty {
                    Spacer()
                    VStack {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 50))
                            .foregroundColor(.gray)
                        Text(searchText.isEmpty ? "Belum ada barang" : "Tidak ada barang yang ditemukan")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            ForEach(filteredItems) { stuff in
                                ItemCard(stuff: stuff, stuffController: stuffController, authService: authService)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            loadItems()
        }
        .refreshable {
            await refreshItems()
        }
        .alert("Info", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func loadItems() {
        Task {
            if let token = authService.authToken {
                await stuffController.fetchItemsFromAPI(authToken: token)
                
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
    
    private func refreshItems() async {
        if let token = authService.authToken {
            await stuffController.fetchItemsFromAPI(authToken: token)
            
            await MainActor.run {
                if let error = stuffController.errorMessage {
                    alertMessage = error
                    showingAlert = true
                }
            }
        }
    }
}

struct ItemCard: View {
    let stuff: Stuff
    @ObservedObject var stuffController: StuffController
    @ObservedObject var authService: AuthService
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            // Item image
            if let photoUrl = stuff.photoUrl, !photoUrl.isEmpty {
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
                .frame(width: 72, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                Image(systemName: "photo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 72, height: 72)
                    .foregroundColor(.gray)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(stuff.name)
                        .font(.headline)
                    Spacer()
                    
                    // Expiry status
                    if Calendar.current.dateComponents([.day], from: Date(), to: stuff.expireDate).day ?? 0 <= 7 {
                        Text("Akan Expired")
                            .font(.subheadline)
                            .foregroundColor(.orange)
                    } else if stuff.expireDate < Date() {
                        Text("Expired")
                            .font(.subheadline)
                            .foregroundColor(.red)
                    } else {
                        Text("Aman")
                            .font(.subheadline)
                            .foregroundColor(.green)
                    }
                }
                
                Divider().padding(.vertical, 4)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("Detail barang:")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    
                    HStack {
                        Text("Dibuat: \(stuff.createDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                        Divider()
                        Text("Expired: \(stuff.expireDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.all)
            .frame(maxWidth: .infinity)
            .background(RoundedRectangle(cornerRadius: 8)
                .fill(Color(red: 0.98, green: 0.94, blue: 0.94)))
            .overlay(RoundedRectangle(cornerRadius: 8)
                .stroke(Color.gray, lineWidth: 1))
        }
        .padding(.vertical, 8)
        .contextMenu {
            Button("Edit") {
                showingEditSheet = true
            }
            Button("Hapus", role: .destructive) {
                showingDeleteAlert = true
            }
        }
        .alert("Hapus Barang", isPresented: $showingDeleteAlert) {
            Button("Batal", role: .cancel) { }
            Button("Hapus", role: .destructive) {
                Task {
                    if let token = authService.authToken {
                        await stuffController.deleteItemViaAPI(itemId: stuff.id, authToken: token)
                    } else {
                        // Fallback to local storage
                        if let index = stuffController.stuff.firstIndex(where: { $0.id == stuff.id }) {
                            stuffController.stuff.remove(at: index)
                            stuffController.saveData()
                        }
                    }
                }
            }
        } message: {
            Text("Apakah Anda yakin ingin menghapus barang '\(stuff.name)'?")
        }
        .sheet(isPresented: $showingEditSheet) {
            EditItemView(stuff: stuff, stuffController: stuffController, authService: authService)
        }
    }
}

struct EditItemView: View {
    let stuff: Stuff
    @ObservedObject var stuffController: StuffController
    @ObservedObject var authService: AuthService
    @Environment(\.dismiss) private var dismiss
    
    @State private var nameValue: String
    @State private var dateValue: Date
    @State private var isSubmitting = false
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    init(stuff: Stuff, stuffController: StuffController, authService: AuthService) {
        self.stuff = stuff
        self.stuffController = stuffController
        self.authService = authService
        self._nameValue = State(initialValue: stuff.name)
        self._dateValue = State(initialValue: stuff.expireDate)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informasi Barang")) {
                    TextField("Nama barang", text: $nameValue)
                    DatePicker("Tanggal Kadaluarsa", selection: $dateValue, displayedComponents: [.date])
                }
                
                Section {
                    Button(action: {
                        Task {
                            await updateItem()
                        }
                    }) {
                        if isSubmitting {
                            HStack {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                Text("Menyimpan...")
                            }
                        } else {
                            Text("Simpan Perubahan")
                        }
                    }
                    .disabled(nameValue.isEmpty || isSubmitting)
                }
            }
            .navigationTitle("Edit Barang")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Batal") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Info", isPresented: $showingAlert) {
            Button("OK") {
                if alertMessage.contains("berhasil") {
                    dismiss()
                }
            }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func updateItem() async {
        await MainActor.run {
            isSubmitting = true
        }
        
        if let token = authService.authToken {
            let success = await stuffController.updateItemViaAPI(
                itemId: stuff.id,
                name: nameValue,
                expireDate: dateValue,
                authToken: token
            )
            
            await MainActor.run {
                isSubmitting = false
                if success {
                    alertMessage = "Barang berhasil diperbarui"
                } else {
                    alertMessage = stuffController.errorMessage ?? "Gagal memperbarui barang"
                }
                showingAlert = true
            }
        } else {
            // Fallback to local storage
            if let index = stuffController.stuff.firstIndex(where: { $0.id == stuff.id }) {
                stuffController.stuff[index] = Stuff(
                    id: stuff.id,
                    name: nameValue,
                    createDate: stuff.createDate,
                    expireDate: dateValue,
                    photoUrl: stuff.photoUrl,
                    userId: stuff.userId
                )
                stuffController.saveData()
                
                await MainActor.run {
                    isSubmitting = false
                    alertMessage = "Barang berhasil diperbarui (offline mode)"
                    showingAlert = true
                }
            }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}

func headerView() -> some View {
    ZStack {
        RoundedRectangle(cornerRadius: 28)
            .fill(
                LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)
            )
            .frame(height: 140)
        
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
                .padding(.leading)
            
            VStack(alignment: .leading) {
                Text("Daftar barangmu!")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.black)
            }
            Spacer()
        }
        .padding(.top, 60)
    }
}
