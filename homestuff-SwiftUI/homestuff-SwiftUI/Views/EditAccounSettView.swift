//
//  EditAccounSettView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 23/01/25.
//

import SwiftUI

struct EditAccounSettView: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    ZStack {
                        HStack {
                            Text("Edit Profile")
                                .font(.system(size: 25, weight: .bold, design: .rounded))
                                .foregroundColor(.black)
                        }
                        .padding(.top, 80)
                        .padding(.bottom)
                        .frame(maxWidth: .infinity)
                        .background( RoundedRectangle(cornerRadius: 28)
                            .fill(
                            LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)))
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
                        Text("Basic Information")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    VStack{
                        InfoSettingsView(Info: "Nama", Value: "Nama User")
                        Divider()
                            .frame(minHeight: 1)
                            .background(.black)
                        InfoSettingsView(Info: "Email", Value: "AppleDevSG@gmail.com")
                        Divider()
                            .frame(minHeight: 1)
                            .background(.black)
                        InfoSettingsView(Info: "Phone Number", Value: "+62 123 4567 8890")
                        Divider()
                            .frame(minHeight: 1)
                            .background(.black)
                        
                    }
                    .padding(.horizontal)
                    HStack{
                        Text("Account Information")
                            .font(.system(size: 20))
                            .bold()
                        Spacer()
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    VStack{
                        InfoSettingsView(Info: "Nama", Value: "Username")
                        Divider()
                            .frame(minHeight: 1)
                            .background(.black)
                        PasswordView(Info: "Password", Value: "AppleDevSG")
                        Divider()
                            .frame(minHeight: 1)
                            .background(.black)
                    }
                    .padding(.horizontal)
                    Spacer()
                }
                .edgesIgnoringSafeArea(.top)
                
            }
           
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct EditAccounSettView_Previews: PreviewProvider {
    static var previews: some View {
        EditAccounSettView()
    }
}

struct InfoSettingsView: View {
    var Info : String
    var Value : String
    
    var body: some View {
        ZStack{
            VStack{
                HStack(alignment: .top){
                    Text(Info)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .bold()
                    Spacer()
                    
                    Text(Value)
                        .font(.body)
                }
                .padding(.vertical)
            }
        }
    }
}
struct PasswordView: View {

    @State private var isSecure: Bool = true

    var Info: String
    var Value: String

    

    var body: some View {
        ZStack {
            VStack {
                HStack(alignment: .top) {
                    Text(Info)
                        .font(.subheadline)
                        .foregroundColor(.black)
                        .bold()
                    Spacer()

                    
                    if isSecure {
                        Text("●●●●●●●")
                            .font(.body)
                    } else {
                        Text(Value)
                            .font(.body)
                    }
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(.black)
                    }
                }
                .padding(.vertical)
            }
        }
    }
}
