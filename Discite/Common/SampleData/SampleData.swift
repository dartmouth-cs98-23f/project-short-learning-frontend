//
//  SampleData.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import Foundation

// Returns data decoded from a sample JSON file.
func getSampleData<T> (_ type: T.Type,
                       forResource: String,
                       withExtension: String)
throws -> T where T: Decodable {

    let decoder = CustomJSONDecoder()

    // Find path to resource
    guard let path = Bundle.main.url(forResource: forResource, withExtension: withExtension) else {
        print("Couldn't locate local resource.")
        throw APIError.unknownError
    }

    do {
        guard let data = try? Data(contentsOf: path) else {
            print("Failed to load data from path URL.")
            throw APIError.unknownError
        }

        let result = try decoder.decode(type.self, from: data)
        return result

    } catch {
        print(String(describing: error))
        throw APIError.invalidJSON
    }
}
