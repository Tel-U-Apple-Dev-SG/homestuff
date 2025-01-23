//
//  AddItemView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 21/01/25.
//

import SwiftUI

struct AddItemView: View {
    
    @State var nameValue = ""
    @State private var dateValue = Date()
    
    var body: some View {
        ZStack {
            VStack {
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
               
                .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)
                )
                .cornerRadius(28)
                Button(action: {
                    
                }) {
                    HStack (spacing: 16) {
                        Spacer()
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
                        Spacer()
                    }
                }
                .background(Color(red: 0.937, green: 0.937, blue: 0.942))
                .cornerRadius(12)
                .padding(.all)
                VStack(spacing: 16) {
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
                    DatePicker(selection: $dateValue, displayedComponents: [.date], label: { Text("Tanggal Kadaluarsa Barang") })
                    
                }
                .padding(.horizontal)
                Spacer()
                Button(action: {
                    print(nameValue)
                    print(dateValue)
                }) {
                    Text("Tambah")
                        .fontWeight(.medium)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                }
                .foregroundColor(.white)
                .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
                .cornerRadius(8)
                .padding()
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
