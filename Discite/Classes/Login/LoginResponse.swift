//
//  LoginResponse.swift
//  ShortLearning
//
//  Created by Jessie Li on 10/13/23.
//  Source:
//      https://medium.com/mop-developers/build-your-first-swiftui-app-part-3-create-the-login-screen-334d90ef1763

import Foundation

struct LoginResponse: Decodable {
    let data: LoginResponseData
}

struct LoginResponseData: Decodable {
    let token: String
    let userId: String
    let message: String
}
