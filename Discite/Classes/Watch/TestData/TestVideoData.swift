//
//  TestVideoData.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation

struct TestVideoData {
    static let decoder = CustomJSONDecoder()

    static func getSampleData<T> (_ type: T.Type,
                                  forResource: String,
                                  withExtension: String)
    throws -> T where T: Decodable {
        
        guard let path = Bundle.main.url(forResource: forResource, withExtension: withExtension) else {
            throw APIError.unknownError
        }
        
        do {
            let data = try Data(contentsOf: path)
            let result = try decoder.decode(type, from: data)
            return result

        } catch {
            throw APIError.unknownError
        }
        
    }
    
    static func videoSequenceData() throws -> SequenceData {
        do {
            let data = try getSampleData(SequenceData.self,
                                         forResource: "videosequencesample",
                                         withExtension: "json")
            return data
        } catch {
            throw error
        }
    }
    
    static func playlistData() throws -> SequenceData.PlaylistData {
        do {
            let data = try getSampleData(SequenceData.PlaylistData.self,
                                         forResource: "videosequencesample",
                                         withExtension: "json")
            return data
        } catch {
            throw error
        }
    }

}
