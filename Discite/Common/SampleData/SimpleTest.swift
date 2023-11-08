//
//  SimpleTest.swift
//  Discite
//
//  Created by Jessie Li on 11/8/23.
//

import SwiftUI

struct SimpleTestData: Decodable {
    var name: String
    var age: Int
    var date: Date
}

struct SimpleTest: View {
    @State var passedSimpleTest: Bool?
    
    var body: some View {
        Button {
            self.passedSimpleTest = SimpleTest.simpleTest()
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
    
    static func simpleTest() -> Bool {
        do {
            _ = try getSampleData(SimpleTestData.self, forResource: "simpletest", withExtension: "json")
            print("Test passed.")
            return true
        } catch {
            print("Test failed.")
            return false
        }
    }
}

#Preview {
    SimpleTest()
}
