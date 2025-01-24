//
//  RegistSuccessView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 24/01/25.
//

import SwiftUI

struct RegistSuccessView: View {
    var body: some View {
        NavigationView{
            ZStack{
                Image("Vector")
                    .resizable()
                    .frame(width: 330, height: 440)
                    .offset(x : 30, y : -160)
                VStack{
                    HStack{
                        Image("Group 2")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                            .padding(.bottom)
                        
                    }
                    
                    
                    VStack(alignment: .center){
                        Text("Aku berhasil didaftarkan!")
                            .bold()
                            .font(.system(size: 27))
                            .padding(.bottom)
                        
                        Text("Mohon untuk masuk ke aplikasi dengan akun yang sudah anda daftarkan!")
                            .font(.body)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                           
                    }
                    
                    NavigationLink(destination: LoginView()) {
                        Text("Masuk")
                            .fontWeight(.bold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .padding()
                            .padding(.horizontal, 20)
                    }
                    Spacer()
                }
                .padding(.vertical, 110)
            }
        }
    }
}

struct RegistSuccessView_Previews: PreviewProvider {
    static var previews: some View {
        RegistSuccessView()
    }
}
