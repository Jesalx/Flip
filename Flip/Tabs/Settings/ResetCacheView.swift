//
//  ResetCacheView.swift
//  Flip
//
//  Created by Jesal Patel on 7/31/22.
//

import SwiftUI
import Nuke

struct ResetCacheView: View {
    @State private var cacheSize: Int

    var cacheString: String {
        return ByteCountFormatter().string(fromByteCount: Int64(cacheSize))
    }

    init() {
        if let dataCache = ImagePipeline.coverPipeline.configuration.dataCache as? DataCache,
           let imageCache = ImagePipeline.coverPipeline.configuration.imageCache as? ImageCache {
            _cacheSize = State(wrappedValue: dataCache.totalSize + imageCache.totalCost)
        } else {
            _cacheSize = State(wrappedValue: 0)
        }
    }

    var body: some View {
        Button {
            clearCache()
        } label: {
            HStack {
                Text("Clear Image Cache")
                Spacer()
                Text(cacheString)
                    .font(.callout)
                    .foregroundColor(.secondary)
            }
        }
        .onAppear(perform: getSize)
    }

    func clearCache() {
        if let dataCache = ImagePipeline.coverPipeline.configuration.dataCache as? DataCache,
           let imageCache = ImagePipeline.coverPipeline.configuration.imageCache as? ImageCache {
            imageCache.removeAll()
            dataCache.removeAll()
            dataCache.flush()
            print("Cleared Cache")
            getSize()
        }
    }

    func getSize() {
        if let dataCache = ImagePipeline.coverPipeline.configuration.dataCache as? DataCache,
           let imageCache = ImagePipeline.coverPipeline.configuration.imageCache as? ImageCache {
            cacheSize = dataCache.totalSize + imageCache.totalCost
        } else {
            cacheSize = 0
        }
    }
}

struct ResetCacheView_Previews: PreviewProvider {
    static var previews: some View {
        ResetCacheView()
    }
}
