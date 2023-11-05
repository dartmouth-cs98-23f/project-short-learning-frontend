//
//  TestVideoData.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation

struct TestVideoData {
    
    struct SimpleTest: Decodable {
        var name: String
        var age: Int
    }
    
    static func getSampleData<T> (_ type: T.Type,
                                  forResource: String,
                                  withExtension: String)
    throws -> T where T: Decodable {
        
        let decoder = JSONDecoder()
        
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
            throw APIError.unknownError
        }
        
    }
    
    static func simpleTest() {
        do {
            _ = try getSampleData(SimpleTest.self, forResource: "simpletest", withExtension: "json")
            print("Test passed.")
        } catch {
            print("Test failed.")
        }
    }
    
    static func videoSequenceData() throws -> SequenceData {
        do {
            let data = try getSampleData(SequenceData.self,
                                        forResource: "smallsequencesample",
                                        withExtension: "json")
            
            print("Got sample data, returning it.")
            return data
        } catch {
            print("Couldn't get sample data.")
            throw error
        }
    }
    
    static func playlistData() throws -> SequenceData.PlaylistData {
        do {
            let data = try getSampleData(SequenceData.PlaylistData.self,
                                         forResource: "playlistsample",
                                         withExtension: "json")
            return data
        } catch {
            throw error
        }
    }

}
