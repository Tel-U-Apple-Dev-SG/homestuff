//
//  OnBoardingView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 22/01/25.
//

import SwiftUI

struct OnBoardingView: View {
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    HStack {
                        Image("onboardVector")
                            .resizable()
                            .frame(width: 330, height: 440)
                        .ignoresSafeArea(.all)
                        Spacer()
                    }
                    Spacer()
                }
                VStack {
                    Spacer()
                    Image("homestuffIcon")
                        .resizable()
                        .frame(width: 180, height: 180)
                    Spacer()
                    Text("Now, We're here!")
                        .font(.title2)
                        .fontWeight(.medium)
                        .padding(.vertical)
                    Text("Stay on top of expiration dates with our smart reminder app. Get timely notifications for food, medicine, and more—so you never miss an important expiry date and can keep everything fresh and organized")
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .frame(width: 280)
                    Spacer()
                    NavigationLink(destination: LoginView()) {
                        Text("Ready to go")
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
                    }
                    .cornerRadius(8)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct OnBoardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnBoardingView()
    }
}
