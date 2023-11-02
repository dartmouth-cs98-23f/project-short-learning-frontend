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
            throw error
        }
        
    }
    
    static func videoSequenceData() -> VideoSequenceData? {
        do {
            let data = try getSampleData(VideoSequenceData.self,
                                         forResource: "videosequencesample",
                                         withExtension: "json")
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    static func playlistData() -> VideoSequenceData.PlaylistData? {
        do {
            let data = try getSampleData(VideoSequenceData.PlaylistData.self,
                                         forResource: "videosequencesample",
                                         withExtension: "json")
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
