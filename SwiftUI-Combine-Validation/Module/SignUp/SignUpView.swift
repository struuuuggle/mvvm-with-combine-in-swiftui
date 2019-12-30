//
//  SignUpView.swift
//  SwiftUI-Combine-Validation
//
//  Created by Mikiya Abe on 2019/12/29.
//  Copyright © 2019 Mikiya Abe. All rights reserved.
//

import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    
    var body: some View {
        VStack {
            TextField("Username", text: $viewModel.username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            HStack {
                Text($viewModel.status.wrappedValue.content)
                    .foregroundColor($viewModel.status.wrappedValue.color)
                Spacer()
            }
        }
        .padding(.horizontal)
        .onAppear(perform: viewModel.onAppear)
        .onDisappear(perform: viewModel.onDisappear)
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
