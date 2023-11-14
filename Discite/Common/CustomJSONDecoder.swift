//
//  CustomJSONDecoder.swift
//  Discite
//
//  Created by Jessie Li on 11/1/23.
//

import Foundation

class CustomJSONDecoder: JSONDecoder {
    
    static let shared: CustomJSONDecoder = CustomJSONDecoder()
    
    override init() {
        super.init()
        
        // Custom Date format
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-DD'T'HH:mm:ss.SSS'Z'"
        self.dateDecodingStrategy = .formatted(formatter)
    }
    
}
