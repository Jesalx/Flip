//
//  EmptySelectionView.swift
//  Flip
//
//

import SwiftUI

struct EmptySelectionView: View {
    var body: some View {
        Text("Please select a book from your library to begin.")
            .italic()
            .foregroundColor(.secondary)
    }
}

struct EmptySelectionView_Previews: PreviewProvider {
    static var previews: some View {
        EmptySelectionView()
    }
}
