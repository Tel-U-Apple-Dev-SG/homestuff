//
//  LoginView.swift
//  homestuff-SwiftUI
//
//  Created by Muhammad Daffa Izzati on 20/01/25.
//

import SwiftUI

struct LoginView: View {
    enum Focus {
        case secure, text
    }
    
    @StateObject private var authService = AuthService()
    @State var toggleNavigation = false
    @State var emailValue = ""
    @State var passwordValue = ""
    @State var rememberToggle = false
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
                        Text("Masuk")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            TextField("Email", text: $emailValue, prompt: Text("Email").foregroundColor(.gray))
                                .padding(.vertical, 12)
                                .foregroundColor(.black)
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
                                TextField("Kata sandi", text: $passwordValue, prompt: Text("Kata sandi").foregroundColor(.gray))
                                    .padding(.vertical, 12)
                                    .foregroundColor(.black)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($inFocus, equals: .text)
                            } else {
                                SecureField("Kata sandi", text: $passwordValue, prompt: Text("Kata sandi").foregroundColor(.gray))
                                    .padding(.vertical, 12)
                                    .foregroundColor(.black)
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
                            Toggle(isOn: $rememberToggle) {
                                Text("Ingat saya")
                                    .font(.footnote)
                            }
                            .toggleStyle(rememberMeToggleStyle())
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("Lupa kata sandi?")
                                    .font(.footnote)
                                    .fontWeight(.medium)
//                                    .foregroundColor(.white)
                            }
                        }
                    }
                    Spacer()
                    Button(action: {
                        if emailValue.isEmpty || passwordValue.isEmpty {
                            authService.errorMessage = "Email dan password harus diisi"
                            return
                        }
                        Task {
                            await authService.login(email: emailValue, password: passwordValue)
                        }
                    }) {
                        HStack {
                            if authService.isLoading {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                    .scaleEffect(0.8)
                            }
                            Text("Masuk")
                                .fontWeight(.medium)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                    }
                    .foregroundColor(.white)
                    .background(LinearGradient(colors: [Color(red: 255/255, green: 178/255, blue: 0/255, opacity: 0.56), Color(red: 255/255, green: 57/255, blue: 19/255, opacity:0.47)], startPoint: .leading, endPoint: .trailing))
                    .clipShape(Capsule())
                    .disabled(authService.isLoading)
                    Spacer()
                    VStack(spacing: 24) {
                        HStack(spacing: 4) {
                            Text("Tidak memiliki akun?")
                                .font(.footnote)
                            NavigationLink(destination: RegisterView()) {
                                Text("Daftar")
                                    .font(.footnote)
                                    .fontWeight(.medium)
//                                    .foregroundColor(.white)
                            }
                        }
                        Divider()
                            .padding(.horizontal)
                        Text("Atau masuk dengan")
                            .font(.footnote)
                        HStack {
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image("googleIcon")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image("appleIcon")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Image("facebookIcon")
                                    .resizable()
                                    .frame(width: 36, height: 36)
                            }
                            Spacer()
                        }
                    }
                    Spacer()
                }
                .padding()
                NavigationLink(destination: ContentView(), isActive: $authService.isAuthenticated, label: { EmptyView() })
                    .disabled(true)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
        .alert("Error", isPresented: .constant(authService.errorMessage != nil)) {
            Button("OK") {
                authService.errorMessage = nil
            }
        } message: {
            Text(authService.errorMessage ?? "")
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            
    }
}

struct rememberMeToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: {
            configuration.isOn.toggle()
        }) {
            HStack(spacing: 4) {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(.black)
                configuration.label
                    .foregroundColor(.black)
            }
        }
    }
}
