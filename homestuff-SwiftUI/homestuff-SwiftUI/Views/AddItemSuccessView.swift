//
//  AddItemSuccessView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 24/01/25.
//

import SwiftUI

struct AddItemSuccessView: View {
    var body: some View {
        NavigationView {
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
                   Spacer()
                        Image("Group 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding(.bottom)
                        Text("data telah sukses di tambahkan!")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    Spacer()
                    NavigationLink(destination: ContentView()) {
                        Text("Kembali ke halaman utama")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
                            .cornerRadius(10)
                            .padding(.all)
                        
                    }
                  
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        .navigationBarBackButtonHidden(true)
      .navigationBarHidden(true)
    }
}

struct AddItemSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        AddItemSuccessView()
    }
}
