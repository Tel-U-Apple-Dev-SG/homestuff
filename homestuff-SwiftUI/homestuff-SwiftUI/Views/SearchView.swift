//
//  SearchView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.orange, Color.yellow]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: 120)
                    .shadow(radius: 5)
                
                HStack {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.leading)
                    
                    VStack(alignment: .leading) {
                        Text("Welcome back,")
                            .font(.caption)
                            .foregroundColor(.white)
                        Text("Alya Salma Khoerunnisaa!")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            HStack {
                Text("Daftar barang")
                    .font(.headline)
                Spacer()
                Image(systemName: "xmark.circle.fill")
            }
            .padding(.horizontal)
            ScrollView{
                VStack {
                    ForEach(0..<7) { index in
                        HStack {
                            Image("snack_image")
                                .resizable()
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            
                            Text("\(index * 100 + 21) Days left")
                                .font(.headline)
                                .padding(.leading)
                            
                            Spacer()
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                    }
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
