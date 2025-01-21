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
                    .opacity(0.7)
                VStack {
                    Spacer()
                    VStack(spacing: 24) {
                        Image(systemName: "person.crop.circle")
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text("Hi, Welcome!")
                            .font(.title)
                            .fontWeight(.medium)
                    }
                    Spacer()
                    VStack(spacing: 16) {
                        Text("Sign In")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity, alignment: .leading)
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
                        .cornerRadius(8)
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                                .padding(.leading, 12)
                            if showPassword {
                                TextField("Password", text: $passwordValue)
                                    .padding(.vertical, 12)
                                    .autocapitalization(.none)
                                    .disableAutocorrection(true)
                                    .focused($inFocus, equals: .text)
                            } else {
                                SecureField("Password", text: $passwordValue)
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
                        .cornerRadius(8)
                        HStack {
                            Toggle(isOn: $rememberToggle) {
                                Text("Remember me")
                                    .font(.footnote)
                            }
                            .toggleStyle(rememberMeToggleStyle())
                            Spacer()
                            Button(action: {
                                
                            }) {
                                Text("Forgot password?")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    Spacer()
                    Button(action: {
                        print(emailValue)
                        print(passwordValue)
                    }) {
                        Text("Sign In")
                            .fontWeight(.medium)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(.borderedProminent)
                    .clipShape(Capsule())
                    Spacer()
                    VStack(spacing: 24) {
                        HStack(spacing: 4) {
                            Text("Don't have an accont?")
                                .font(.footnote)
                            NavigationLink(destination: RegisterView()) {
                                Text("Register")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                            }
                        }
                        Text("or sign in with")
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
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(true)
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
