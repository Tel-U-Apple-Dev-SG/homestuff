//
//  ContentView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 20/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Beranda", systemImage: "house")
                    }
                SearchView()
                    .tabItem {
                        Label("Pencarian", systemImage: "magnifyingglass")
                    }
                AddItemView()
                    .tabItem {
                        Label("Tambah", systemImage: "plus")
                    }
               HistoryPage()
                    .tabItem {
                        Label("Histori", systemImage: "clock")
                    }
                ProfileView()
                    .tabItem {
                        Label("Profil", systemImage: "person")
                    }
            }
            .onAppear() {
                UITabBar.appearance().backgroundColor = .white
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
