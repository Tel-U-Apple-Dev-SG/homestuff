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
            Text("Home View")
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            Text("Search View")
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }.toolbarBackground(Color.blue, for: .tabBar)
            AddItemView()
                .tabItem {
                    Image(systemName: "plus")
                }
            Text("History View")
                .tabItem {
                    Label("history", systemImage: "clock")
                }
            Text("Profile View")
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
