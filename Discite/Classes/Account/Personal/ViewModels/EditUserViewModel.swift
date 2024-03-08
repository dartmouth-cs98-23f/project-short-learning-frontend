//
//  EditUserViewModel.swift
//  Discite
//
//  Created by Bansharee Ireen & Jessie Li on 3/8/24.
//

import Foundation

class EditUserViewModel: ObservableObject {
    @Published var state: ViewModelState = .loaded
    
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var username: String = ""
    @Published var profilePicture: String?
    
    @Published var toast: Toast?
    
    private var task: Task<Void, Error>? {
        willSet {
            if let currentTask = task {
                if currentTask.isCancelled { return }
                currentTask.cancel()
                // Setting a new task cancelling the current task
            }
        }
    }
    
    public func configureWith(user: User) {
        print("configuring user")
        self.firstName = user.firstName
        self.lastName = user.lastName
        self.username = user.username
        self.profilePicture = user.profilePicture
    }
    
    // PUT user information
    @MainActor
    func updateUser(user: User) {
        let request = UpdateUserRequest(
            firstName: firstName,
            lastName: lastName,
            username: username,
            profilePicture: profilePicture
        )
        
        task = Task {
            do {
                try await user.updateUser(request: request)
                toast = Toast(style: .success, message: "Successfully updated profile.")
                
            } catch {
                self.state = .error(error: error)
                toast = Toast(style: .error, message: "Couldn't update profile.")
                print("Error in EditUserViewModel.updateUser: \(error)")
            }
        }
    }
    
    deinit {
        task?.cancel()
    }
}
