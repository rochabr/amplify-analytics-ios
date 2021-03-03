//
//  PrettyModifierExtensions.swift
//  traveldeals
//
//  Created by Rocha Silva, Fernando on 2021-02-19.
//

import SwiftUI

extension TextField {
    func pretty() -> some View {
        self.padding()
            .border(Color.gray, width: 1)
            .cornerRadius(3)
    }
}

extension SecureField {
    func pretty() -> some View {
        self.padding()
            .border(Color.gray, width: 1)
            .cornerRadius(3)
    }
}

extension Button {
    func pretty() -> some View {
        self.padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(3)
    }
}
