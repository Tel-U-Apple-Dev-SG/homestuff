//
//  ProfileView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct ProfileView: View {
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
                Text("profile")
                    .font(.system(size: 27, weight: .medium ))
            }
            Spacer()
            
            HStack {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .clipShape(Circle())
                    .padding(.leading)
                
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
            HStack{
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.clear)
                    .overlay(Rectangle()
                        .stroke(style: StrokeStyle(lineWidth: 1, dash: [6]))
                        .foregroundColor(.orange))
            }
            Spacer()
            VStack{
                
            }
            
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
