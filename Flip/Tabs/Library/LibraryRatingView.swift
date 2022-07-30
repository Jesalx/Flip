//
//  LibraryRatingView.swift
//  Flip
//
//  Created by Jesal Patel on 7/18/22.
//

import SwiftUI

struct LibraryRatingView: View {
    @Binding var rating: Int

    let maxRating = 5
    let color = Color.accentColor

    var body: some View {
        HStack {
            Image(systemName: "arrow.uturn.backward")
                .foregroundColor(color)
                .onTapGesture {
                    ratingTapped(number: 0)
                }
                .padding(.trailing, 10)
            ForEach(1..<maxRating + 1, id: \.self) { number in
                image(for: number)
                    .foregroundColor(color)
                    .onTapGesture {
                        ratingTapped(number: number)
                    }
            }
        }
    }

    func ratingTapped(number: Int) {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
        rating = number
    }

    func image(for number: Int) -> Image {
        if number > rating {
            return Image(systemName: "star")
        }
        return Image(systemName: "star.fill")
    }
}

struct LibraryRatingView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryRatingView(rating: .constant(4))
    }
}
