//
//  IconPickerView.swift
//  Flip
//
//  Created by Jesal Patel on 7/26/22.
//

import SwiftUI

struct IconPickerView: View {
    var body: some View {
        List {
            Section("Classic") {
                Group {
                    IconButtonView(iconName: nil, iconImage: "AppIconBlueImage", iconText: "Blue")
                    IconButtonView(iconName: "AppIconBrown", iconImage: "AppIconBrownImage", iconText: "Brown")
                    IconButtonView(iconName: "AppIconCyan", iconImage: "AppIconCyanImage", iconText: "Cyan")
                    IconButtonView(iconName: "AppIconGray", iconImage: "AppIconGrayImage", iconText: "Gray")
                    IconButtonView(iconName: "AppIconGreen", iconImage: "AppIconGreenImage", iconText: "Green")
                    IconButtonView(iconName: "AppIconIndigo", iconImage: "AppIconIndigoImage", iconText: "Indigo")
                    IconButtonView(iconName: "AppIconMint", iconImage: "AppIconMintImage", iconText: "Mint")
                    IconButtonView(iconName: "AppIconOrange", iconImage: "AppIconOrangeImage", iconText: "Orange")
                    IconButtonView(iconName: "AppIconPink", iconImage: "AppIconPinkImage", iconText: "Pink")
                }
                IconButtonView(iconName: "AppIconPurple", iconImage: "AppIconPurpleImage", iconText: "Purple")
                IconButtonView(iconName: "AppIconRed", iconImage: "AppIconRedImage", iconText: "Red")
                IconButtonView(iconName: "AppIconTeal", iconImage: "AppIconTealImage", iconText: "Teal")
                IconButtonView(iconName: "AppIconYellow", iconImage: "AppIconYellowImage", iconText: "Yellow")
            }
            Section("Extra") {
                IconButtonView(iconName: "AppIconCandy", iconImage: "AppIconCandyImage", iconText: "Pastel")
                IconButtonView(iconName: "AppIconBlack", iconImage: "AppIconBlackImage", iconText: "Black")
            }
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
                    .frame(width: 60, height: 60)
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
