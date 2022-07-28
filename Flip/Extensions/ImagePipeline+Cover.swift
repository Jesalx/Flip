//
//  ImagePipeline+Cover.swift
//  Flip
//
//  Created by Jesal Patel on 7/27/22.
//

import Foundation
import Nuke

extension ImagePipeline {
    static let coverPipeline = ImagePipeline(configuration: .withDataCache)
    // static let coverPipeline = ImagePipeline(configuration: .withDataCache(sizeLimit: 1024 * 1024 * 250))
    // 250 MB Cache
}
