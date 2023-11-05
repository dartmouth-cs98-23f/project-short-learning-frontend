//
//  TestVideoData.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation
import SwiftUI

struct TestVideoData: View {
    
    @State var passedSimpleTest: Bool?
    
    var body: some View {
        Button {
            self.passedSimpleTest = TestVideoData.simpleTest()
        } label: {
            Text("Run simple test.")
        }
        
        // Must explicitly compare with Bool because passedSimpleTest could be nil
        if passedSimpleTest == false {
            Text("Test failed.")
        } else if passedSimpleTest == true {
            Text("Test passed.")
        }
        
    }
    
    struct SimpleTest: Decodable {
        var name: String
        var age: Int
        var date: Date
    }
    
    static func getSampleData<T> (_ type: T.Type,
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
            throw APIError.unknownError
        }
        
    }
    
    static func simpleTest() -> Bool {
        do {
            _ = try getSampleData(SimpleTest.self, forResource: "simpletest", withExtension: "json")
            print("Test passed.")
            return true
        } catch {
            print("Test failed.")
            return false
        }
    }
    
    static func videoSequenceData() throws -> SequenceData {
        do {
            let data = try getSampleData(SequenceData.self,
                                        forResource: "videosequencesample",
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

#Preview {
    TestVideoData()
        .environmentObject(Sequence())
}
