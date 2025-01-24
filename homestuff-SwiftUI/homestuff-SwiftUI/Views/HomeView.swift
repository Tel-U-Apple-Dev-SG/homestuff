//
//  HomeView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ZStack {
            VStack{
                HStack{
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(.leading)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selamat datang,")
                            .font(.headline)
                            .foregroundColor(.black)
                        Text("(Username)!")
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
                            ))
                      
                HStack {
                    VStack{
                        Text("Jumlah Barang")
                            .font(.headline)
                        Text("0")
                            .font(.system(size: 27, weight: .bold))
                            
                    }
                    .frame(maxWidth: .infinity)
                    VStack{
                        Text("Kadaluarsa Terdekat")
                            .font(.headline)
                        Text("10 Jan 2025")
                            .font(.system(size: 25, weight: .bold))
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                .padding(.vertical)
               
                
                
                VStack(alignment: .center) {
                    Text("Daftar Menuju Kadaluwarsa")
                        .font(.headline)
                        .padding(.bottom, 6)
                    
                    VStack {
                        ForEach(0..<4) { index in
                            HStack {
                                Image(systemName: "photo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80, height: 80)
                                Spacer()
                                Text("\(index * 100 + 21) Hari tersisa")
                                    .font(.title2)
                                    .padding(.leading)
                                Spacer()
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            
                            .cornerRadius(10)
                            .shadow(radius: 2)
                            .padding(.horizontal)
                        }
                    }
                }
                Spacer()
                
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
