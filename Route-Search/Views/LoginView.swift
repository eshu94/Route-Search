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
                    TextField("Enter your email", text: $email)
                        .foregroundColor(Color.black)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                HStack {
                    Image(systemName: "person")
                        .foregroundColor(.secondary)
                    TextField("Enter password", text: $password)
                        .foregroundColor(Color.black)
                    
                }.padding()
                .background(Color.white)
                .cornerRadius(10)
            }.padding([.leading, .trailing], 27.5)
            
            Button(action: {
                if self.email == "abc@quin.design" && self.password == "Quin123" {
                    self.loginDidFail = false
                    self.loginDidSucceed = true
                    UserDefaults.standard.set(self.loginDidSucceed, forKey: "loginActive")
                } else {
                    self.loginDidFail = true
                    self.loginDidSucceed = false
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
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
