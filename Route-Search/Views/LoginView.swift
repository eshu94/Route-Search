//
//  LoginView.swift
//  Route-Search
//
//  Created by ESHITA on 18/05/21.
//

import SwiftUI

struct LoginView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State var loginDidFail: Bool = false
    @State var loginDidSucceed: Bool = false
    @State private var emailString  : String = ""
    @State private var isEmailValid : Bool   = true
    private var defaultEmail:String
    private var defaultPassword: String
    @State var loginButtonState: Bool = true
    @State private var isPassword:Bool = true
    
    init() {
        guard let email = UserDefaults.standard.string(forKey: "defaultUserEmail"), let password = UserDefaults.standard.string(forKey: "defaultUserPassword") else {
            fatalError("User not found")
        }
        
        self.defaultEmail = email
        self.defaultPassword = password
    }
  
    
      var body: some View {
        NavigationView {
        VStack() {
            Text("Welcome to Quin Designs!!!")
                .font(.custom("Times New Roman",size:20))
                .fontWeight(.bold)
                .foregroundColor(Color.white)
                .padding(.top, 60)
                .padding(.bottom, 30)
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("Enter your email", text: $email, onEditingChanged: { (isChanged) in
                        if !isChanged {
                            if self.textFieldValidatorEmail(self.email) {
                                self.isEmailValid = true
                                self.loginButtonState = false
                            } else {
                                self.isEmailValid = false
                                self.email = ""
                                self.loginButtonState = true
                            }
                        }
                    }).foregroundColor(Color.black)
                    .autocapitalization(.none)
                    
                    if !self.isEmailValid {
                                Text("Email is Not Valid")
                                    .font(.callout)
                                    .foregroundColor(Color.red)
                        
                            }

                    
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    SecureField("Enter password", text: $password).foregroundColor(Color.black)
                        .autocapitalization(.none)
                    
                }.padding()
                .background(Color.white)
                .cornerRadius(10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {
                if self.email.isEmpty || self.password.isEmpty {
                    self.loginButtonState = true
                }
                else if self.email != self.defaultEmail || self.password != self.defaultPassword {
                    self.loginDidFail = true
                    self.loginDidSucceed = false
                    UserDefaults.standard.set(self.loginDidSucceed, forKey: "loginActive")
                } else {
                    self.loginDidFail = false
                    self.loginDidSucceed = true
                    UserDefaults.standard.set(self.loginDidSucceed, forKey: "loginActive")
                }
            }) {
              Text("Sign In")
                .font(.headline)
                .foregroundColor(.white)
                .frame(width: 300, height: 50)
                .background(Color.init(red: 0.3333, green: 0.5098, blue: 0.1216))
                .cornerRadius(15.0)
            }.padding(.top)
            .disabled(loginButtonState)
            .background(
                NavigationLink(destination: RouteListView().navigationBarHidden(true)
                               , isActive: $loginDidSucceed) {})
            if loginDidFail {
                Text("Information not correct. Try again!!!")
                    .font(.body).foregroundColor(Color.white)
                    .padding([.top, .bottom], 30)
                
            }
            Spacer()
        }.background(
            LinearGradient(gradient: Gradient(colors: [Color(red: 41/255, green: 128/255, blue: 185/255),Color(red: 44/255, green: 62/255, blue: 80/255)]), startPoint: .top, endPoint: .bottom)
              .edgesIgnoringSafeArea(.all))
        .navigationBarHidden(true)
        }
      }
    
    func textFieldValidatorEmail(_ string: String) -> Bool {
        if string.count > 100 {
            return false
        }
        let emailFormat = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" + "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" + "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" + "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" + "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" + "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" + "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: string)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
