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
                .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
//                Spacer()
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
                .padding()
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
        }
    }
}

struct AddItemView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemView()
    }
}
