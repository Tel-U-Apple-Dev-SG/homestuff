//
//  EditProfileView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 23/01/25.
//

import SwiftUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    ZStack {
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
                        HStack {
                            Button(action: {
                                dismiss()
                            }) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 20, weight: .bold))
                                    .foregroundColor(.black)
                                    .padding(.leading, 24)
                            }
                            Spacer()
                        }
                        .padding(.top, 80)
                        .padding(.bottom)
                    }
                    
                    HStack{
                        Text("Gambar Profil")
                            .font(.system(size: 15))
                            .bold()
                    }
                    .padding(.top, 8)
                    HStack{
                        ZStack{
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .frame(width: 110, height: 110)
                                .clipShape(Circle())
                            
                            Circle()
                                .fill(Color.orange)
                                .frame(width: 35, height: 35)
                                .overlay(
                                    Image(systemName: "camera.fill")
                                        .foregroundColor(.white))
                                .offset(x: 36, y: 40)
                        }
                    }
                    VStack{
                        ContainerEdit(UserName: "Nama pengguna", PlaceHolder: "Masukkan username baru")
                        ContainerEdit(UserName: "Email", PlaceHolder: "MAsukkan email baru")
                        ContainerEdit(UserName: "Nomor telepon", PlaceHolder: "MAsukkan nomor baru")
                        ContainerEdit(UserName: "Password baru?", PlaceHolder: "Masukkan Password baru")
                        
                    }
                    Spacer()
                    Button(action: {}){
                        HStack{
                            Text("Perbarui")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background( RoundedRectangle(cornerRadius: 12)
                            .fill(
                                LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)))
                        .padding(.all)
                    }
                    
                    .padding(.bottom)
                }
                .edgesIgnoringSafeArea(.top)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}
        
        
        struct EditProfileView_Previews: PreviewProvider {
            static var previews: some View {
                EditProfileView()
            }
        }

struct ContainerEdit: View {
    var UserName : String
    var PlaceHolder : String
    
    var body: some View {
        ZStack{
            VStack() {
                HStack {
                    Text(UserName)
                    Spacer()
                }
                TextField(PlaceHolder, text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                    .padding(.all)
                    .background(RoundedRectangle(cornerRadius: 25)
                        .fill( Color(red: 0.96, green: 0.96, blue: 0.96)))
                    .overlay(RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray, lineWidth: 1))
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
            }
            .padding(.trailing)
            .padding(.leading)
        }
    }
}

