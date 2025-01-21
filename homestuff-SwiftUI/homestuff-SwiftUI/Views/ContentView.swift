//
//  ContentView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 20/01/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SearchView()
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
            AddItemView()
                .tabItem {
                    Label("Add Item", systemImage: "plus")
                }
            Text("History View")
                .tabItem {
                    Label("History", systemImage: "clock")
                }
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .onAppear() {
            UITabBar.appearance().backgroundColor = .white
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
