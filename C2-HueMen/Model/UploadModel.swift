//
//  UploadModel.swift
//  C2-HueMen
//
//  Created by Muhammad Raihan Abdillah Lubis on 08/05/25.
//

enum UploadType: String, Identifiable, Hashable {
    case top, bottom
    
    var id: String { self.rawValue }
}
