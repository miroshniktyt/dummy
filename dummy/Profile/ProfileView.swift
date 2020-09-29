//
//  ProfileView.swift
//  dummy
//
//  Created by Macbook Air on 25.09.2020.
//  Copyright © 2020 macbook. All rights reserved.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer()
                Image(uiImage: viewModel.uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 250.0, height: 250.0, alignment: .center)
                Text(viewModel.user.firstName + " " + viewModel.user.lastName)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let user = UserInfo(id: "", firstName: "", lastName: "", email: "", picture: "")
        let viewModel = ProfileViewModel(user: user, image: nil)
        return ProfileView(viewModel: viewModel)
    }
}
