//
//  EditAccounSettView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 23/01/25.
//

import SwiftUI

struct EditAccounSettView: View {
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    HStack{
                        Text("Account Settings")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        
                    }
                    .padding(.top, 80)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                    .background( RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)))
                    
                    HStack{
                        Text("Basic Information")
                            .font(.system(size: 20))
                            .bold()
                           
                    }
                    VStack{
                        InfoSettingsView(Info: "Nama", Value: "Nama User")
                        InfoSettingsView(Info: "Email", Value: "AppleDevSG@gmail.com")
                        InfoSettingsView(Info: "Phone Number", Value: "+62 123 4567 8890")
                        
                        
                    }
                    HStack{
                        Text("Account Information")
                            .font(.system(size: 20))
                            .bold()
                            .padding(.top)
                    }
                    VStack{
                        InfoSettingsView(Info: "Nama", Value: "Username")
                        PasswordView(Info: "Password", Value: "AppleDevSG")
                      
                        
                        
                    }
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
                .padding()
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(.clear)
                    .overlay(Rectangle()
                        .foregroundColor(.gray))
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
                .padding()
                Rectangle()
                    .frame(height: 1.5)
                    .foregroundColor(.clear)
                    .overlay(Rectangle()
                        .foregroundColor(.gray))
            }
        }
    }
}
