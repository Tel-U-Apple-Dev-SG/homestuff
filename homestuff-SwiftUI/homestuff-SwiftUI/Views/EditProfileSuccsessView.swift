//
//  EditProfileSuccsessView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 24/01/25.
//

import SwiftUI

struct EditProfileSuccsessView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Spacer()
                        Text("Perbarui Profil")
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
                        Text("data telah sukses di perbarui!")
                            .foregroundColor(.gray)
                            .padding(.top, 20)
                    Spacer()
                    NavigationLink(destination: ProfileView()) {
                        Text("Kembali ke halaman profil")
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


struct EditProfileSuccsessView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileSuccsessView()
    }
}
