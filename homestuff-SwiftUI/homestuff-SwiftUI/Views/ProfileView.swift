//
//  ProfileView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack{
                        Text("Profile")
                            .font(.system(size: 25, weight: .bold, design: .rounded))
                            .foregroundColor(.black)
                        
                        
                    }
                    .padding(.top, 80)
                    .padding(.bottom)
                    .frame(maxWidth: .infinity)
                    .background( RoundedRectangle(cornerRadius: 28)
                        .fill(
                            LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)
                        )
                    )
                    
                    HStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .frame(width: 55, height: 55)
                            .clipShape(Circle())
                            .padding(.all)
                        
                        
                        VStack(alignment: .leading) {
                            Text("(Username)")
                                .font(.headline)
                                .bold()
                                .foregroundColor(.black)
                            Text("AppleDevSG@gmail.com")
                                .font(.caption)
                                .foregroundColor(.black)
                            Text("+62 123 4567 7890")
                                .font(.caption)
                                .foregroundColor(.black)
                        }
                        Spacer()
                    }
                    Spacer()
                    
                    
                    
                    Rectangle()
                        .frame(height: 1.5)
                        .foregroundColor(.clear)
                        .overlay(Rectangle()
                            .foregroundColor(.gray))
                        .padding(.all)
                    
                    
                    VStack(spacing: 16){
                        NavigationLink(destination: EditProfileView()) {
                            MenuItem(icon: "pencil", text: "Edit Pofile")
                        }
                        NavigationLink(destination: EditAccounSettView()) {
                            MenuItem(icon: "gearshape.fill", text: "Account Settings")
                        }
                        Spacer()
                            .padding()
                        
                    }
                    .padding()
                    Button(action: {}){
                        HStack{
                            
                            Image(systemName: "rectangle.portrait.and.arrow.forward")
                                .foregroundColor(.white)
                                .scaledToFit()
                                .bold()
                            
                            Text("Log Out")
                                .foregroundColor(.white)
                                .font(.headline)
                            
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background( RoundedRectangle(cornerRadius: 10))
                        .foregroundColor(.red)
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
struct MenuItem: View {
    var icon: String
    var text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
                .foregroundColor(.orange)
            
            Text(text)
                .font(.headline)
                .foregroundColor(.black)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 12, height: 12)
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(radius: 2)
    }
}
