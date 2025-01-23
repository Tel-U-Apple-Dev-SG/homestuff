//
//  RegisterView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 20/01/25.
//

import SwiftUI

struct RegisterView: View {
    enum Focus {
        case secure, text
    }
    
    @State var nameValue = ""
    @State var emailValue = ""
    @State var passwordValue = ""
    @State var confirmPasswordValue = ""
    @State var showPassword = false
    @FocusState private var inFocus: Focus?
    
    var body: some View {
        NavigationView {
            ZStack {
                Image("background")
                    .resizable()
                    .ignoresSafeArea(.all)
                    .opacity(0)
                VStack {
                    Spacer()
                    VStack(spacing: 24) {
                        Image("homestuffIcon")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Selamat Datang!")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    Spacer()
                    VStack(spacing: 16) {
                        HStack {
                            Text("Daftar")
                                .fontWeight(.medium)
                            Spacer()
                        }
                        HStack {
                            Image(systemName: "person.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            TextField("Nama", text: $nameValue)
                                .padding(.vertical, 12)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .background(.white)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1))
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            TextField("Email", text: $emailValue)
                                .padding(.vertical, 12)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                        }
                        .background(.white)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1))
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            if showPassword {
                                TextField("Kata sandi", text: $passwordValue)
                                    .padding(.vertical, 12)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($inFocus, equals: .text)
                            } else {
                                SecureField("Kata sandi", text: $passwordValue)
                                    .padding(.vertical, 12)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($inFocus, equals: .secure)
                            }
                            Button(action: {
                                showPassword.toggle()
                                inFocus = showPassword ? .text : .secure
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 12)
                        }
                        .background(.white)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1))
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            if showPassword {
                                TextField("Konfirmasi kata sandi", text: $confirmPasswordValue)
                                    .padding(.vertical, 12)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($inFocus, equals: .text)
                            } else {
                                SecureField("Konfirmasi kata sandi", text: $confirmPasswordValue)
                                    .padding(.vertical, 12)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($inFocus, equals: .secure)
                            }
                            Button(action: {
                                showPassword.toggle()
                                inFocus = showPassword ? .text : .secure
                            }) {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                            .padding(.trailing, 12)
                        }
                        .background(.white)
                        .overlay(RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray, lineWidth: 1))
                    }
                    Spacer()
                    Button(action: {
                        print(nameValue)
                        print(emailValue)
                        print(passwordValue)
                        print(confirmPasswordValue)
                    }) {
                        Text("Daftar")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                    }
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    Spacer()
                    HStack(spacing: 4) {
                        Text("Sudah memiliki akun?")
                            .font(.footnote)
                        NavigationLink(destination: LoginView()) {
                            Text("Masuk")
                                .font(.footnote)
                                .fontWeight(.medium)
//                                .foregroundColor(.white)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
