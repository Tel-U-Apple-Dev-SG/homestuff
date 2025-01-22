//
//  SearchView.swift
//  homestuff-SwiftUI
//
//  Created by Kevin Muhammad Althaf on 21/01/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        ZStack {
            
            VStack {
                headerView()
                
                HStack{
                    Text("Daftar barang")
                        .font(.headline)
                        .padding(.leading)
                    HStack{
                        TextField("Cari barang"  , text: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Value@*/.constant("")/*@END_MENU_TOKEN@*/)
                            .padding(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.black)
                            )
                            
                    }
                    .padding(.all)
                   
                }

                ScrollView {
                    itemListView()
                }
               
            }
            .edgesIgnoringSafeArea(.top)
        }
        
        
      
    }
    
    struct SearchView_Previews: PreviewProvider {
        static var previews: some View {
            SearchView()
        }
        
    }
    func headerView() -> some View {
       ZStack {
           RoundedRectangle(cornerRadius: 28)
               .fill(
                LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing)
                   )
               .frame(height: 140)
               
           
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
                   Text("Alya Salma Khoerunnisaa!")
                       .font(.headline)
                       .bold()
                       .foregroundColor(.white)
               }
               Spacer()
           }
           .padding(.top, 60)
           .padding(.bottom)
       }
   }
   
   
   func itemListView() -> some View {
       VStack {
           ForEach(0..<7) { index in
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
               .background(Color(.systemGray6))
               .cornerRadius(10)
               .shadow(radius: 2)
               .padding(.horizontal)
           }
       }
   }
    
}
