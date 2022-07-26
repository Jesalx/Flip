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
            IconButtonView(iconName: nil, iconImage: "AppIconPurpleImage", iconText: "Purple")
            IconButtonView(iconName: "AppIconGreen", iconImage: "AppIconGreenImage", iconText: "Green")
            IconButtonView(iconName: "AppIconBlue", iconImage: "AppIconBlueImage", iconText: "Blue")
            IconButtonView(iconName: "AppIconCandy", iconImage: "AppIconCandyImage", iconText: "Cotton Candy")
            IconButtonView(iconName: "AppIconPink", iconImage: "AppIconPinkImage", iconText: "Pink")
            IconButtonView(iconName: "AppIconTeal", iconImage: "AppIconTealImage", iconText: "Teal")
            IconButtonView(iconName: "AppIconYellow", iconImage: "AppIconYellowImage", iconText: "Yellow")
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
