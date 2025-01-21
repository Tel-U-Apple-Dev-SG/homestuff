//
//  HomeView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct HomeView: View {
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
                        Text("(Username)!")
                            .font(.headline)
                            .bold()
                            .foregroundColor(.white)
                    }
                    Spacer()
                }
            }
            .padding(5)
            
            
            HStack {
                VStack {
                    Text("Jumlah Barang")
                        .font(.headline)
                    Text("10")
                        .font(.largeTitle)
                        .bold()
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Text("Kadaluwarsa Terdekat")
                        .font(.headline)
                    HStack(alignment: .top) {
                        Text("10 Jan 2025")
                            .font(.system(size: 27, weight: .bold))
                       
                    }
                
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
            
            
            VStack(alignment: .center) {
                Text("Daftar Menuju Kadaluwarsa")
                    .font(.headline)
                    .padding(1)
                
                    VStack {
                        ForEach(0..<4) { index in
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
            //.padding(.vertical)
            
            Button("Check Selengkapnya") {
                print("check button pressed")
            }
            .font(.headline)
            .foregroundColor(.black)
            .padding(.bottom, 10)
            
            Spacer()
            
            
          

           
            
          
        }
        .background(Color(.systemGray6))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
