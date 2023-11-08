//
//  TestVideoData.swift
//  Discite
//
//  Created by Jessie Li on 11/2/23.
//

import Foundation

struct TestVideoData {
    
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
