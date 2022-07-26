//
//  IconPickerView.swift
//  Flip
//
//  Created by Jesal Patel on 7/26/22.
//

import SwiftUI

struct IconPickerView: View {
    var body: some View {
        Form {
            IconButtonView(
                iconName: nil,
                iconImage: "AppIconImage",
                iconText: "Default"
            )
            IconButtonView(
                iconName: "AppIconGreen",
                iconImage: "AppIconGreenImage",
                iconText: "Green"
            )
        }
        .navigationTitle("Icon Options")
    }
}

struct IconButtonView: View {
    let iconName: String?
    let iconImage: String
    let iconText: String

    var body: some View {
        Button {
            UIApplication.shared.setAlternateIconName(iconName)
        } label: {
            HStack {
                Image(iconImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 70, height: 70)
                    .cornerRadius(12)
                Text(iconText)
                    .foregroundColor(.primary)
            }
        }
    }
}

struct IconPickerView_Previews: PreviewProvider {
    static var previews: some View {
        IconPickerView()
    }
}
