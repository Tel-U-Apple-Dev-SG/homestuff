//
//  SearchView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct SearchView: View {
    @ObservedObject var stuffController = StuffController()
    var body: some View {
        ZStack {
            VStack {
                headerView()
                
                HStack{
                    Text("Daftar barang")
                        .font(.title2)
                        .padding(.leading)
                    HStack{
                        TextField("Cari barang", text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.black)
                            )
                        
                    }
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                }
                ScrollView {
                    VStack {
                        ForEach(stuffController.stuff) { stuff in
                            HStack(alignment: .center, spacing: 16) {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 72)
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                VStack(alignment: .leading, spacing: 4) {
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    HStack {
                                        Text(stuff.name)
                                            .font(.headline)
                                        Spacer()
                                        Text("Aman")
                                            .font(.subheadline)
                                            .foregroundColor(.green)
                                        
                                    }
                                    Divider().padding(.vertical, 4)
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text("Detail barang:")
                                            .font(.subheadline)
                                            .foregroundColor(.black)
                                        Text("Masukkan dan kadaluarsa barang")
                                            .font(.subheadline)
                                            .foregroundColor(.gray)
                                        HStack {
                                            Text(stuff.createDate.formatted(date: .long, time: .omitted))
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                            Divider()
                                            Text(stuff.expireDate.formatted(date: .long, time: .omitted))
                                                .font(.footnote)
                                                .foregroundColor(.gray)
                                        }
                                    }
                                }
                                .padding(.all)
                                .frame(maxWidth: .infinity)
                                .background(RoundedRectangle(cornerRadius: 8)
                                    .fill( Color(red: 0.98, green: 0.94, blue: 0.94)))
                                .overlay(RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray, lineWidth: 1))
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(.horizontal)
            }
            .edgesIgnoringSafeArea(.top)
        }
        .onAppear {
            stuffController.fetchData()
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
