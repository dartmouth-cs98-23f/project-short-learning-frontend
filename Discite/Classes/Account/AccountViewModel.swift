//
//  AccountViewModel.swift
//  Discite
//
//  Created by Colton Sankey on 11/12/23.
//

import Foundation

class AccountViewModel: ObservableObject {

    func logout() {
        Auth.shared.logout()
    }
}
