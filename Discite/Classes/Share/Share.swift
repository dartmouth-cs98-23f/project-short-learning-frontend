//
//  Share.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import SwiftUI

struct Share: View {
    
    var playlist: SharedPlaylist
    var friends: [Friend]
    
    @State private var isShowingActivities = false
    @State private var isShowingConfirmation = false
    @State private var friendSearch = ""
    @State private var message = "This playlist is perfect for you. ✨ Join me on Discite to unlock more personalized, tailored content and enhance your learning experience! 📚"
    @Binding var isShowing: Bool
    
    @State private var selection = Set<Friend>()
    
    var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Search", text: $friendSearch)
                .font(Font.body1)
        }
        .padding(8)
        .background(Color.grayLight)
        .cornerRadius(10)
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            TextualButton(action: {
                isShowing = false
            }, label: "Cancel")
            
            Text("Share")
                .font(Font.H2)
                .padding(.top, 18)
            
            searchBar
            
            // Section: Horizontally scrolling list of friends
            ScrollView(.horizontal) {
                HStack(spacing: 18) {
                    Button {
                        self.isShowingActivities = true
                        
                    } label: {
                        Image(systemName: "message.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .addGradient(gradient: LinearGradient.pinkOrangeGradient)
                    }
                    .sheet(isPresented: self.$isShowingActivities) {
                        ShareRepresentable(message: message)
                            .ignoresSafeArea()
                    }
                    
                    ForEach(friends) { friend in
                        profileSelectButton(friend: friend)
                    }
                }
            }

            // Section: Video to be shared
            ShareCard(playlist: playlist.playlist)
            
            // Message box
            TextField("Message", text: $message, axis: .vertical)
                .font(Font.body1)
                .lineSpacing(5)
                .frame(maxWidth: .infinity, maxHeight: 180, alignment: .top)
                .padding(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.grayNeutral, lineWidth: 1)
                        .opacity(0.5)
                )
            
            // Share button
            PrimaryActionButton(action: { isShowingConfirmation = true }, 
                                label: "Share",
                                disabled: selection.count == 0)
            
            .sheet(isPresented: self.$isShowingConfirmation,
                   onDismiss: clearProfileSelection) {
                ShareConfirmation(isShowing: $isShowingConfirmation, isShowingShare: $isShowing, playlist: playlist.playlist)
            }

        }
        .padding([.top, .bottom], 32)
        .padding([.leading, .trailing], 24)
    }
    
    func profileSelectButton(friend: Friend) -> some View {
        Button {
            if selection.contains(friend) {
                selection.remove(friend)
            } else {
                selection.insert(friend)
            }
            
        } label: {
            VStack {
                Image(systemName: selection.contains(friend) ? "checkmark.circle.fill" : friend.profileImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 56, height: 56)
                Text(friend.username).font(Font.small)
            }
        }
        .foregroundColor(Color.primaryBlueBlack)
    }
    
    func clearProfileSelection() {
        selection.removeAll()
    }
    
    static func createSampleFriends() -> [Friend] {
        var friends: [Friend] = []
        
        for i in (1..<5) {
            friends.append(Friend(id: "\(i)", username: "janedoe", firstName: "Jane", lastName: "Doe", profileImage: "person.circle"))
        }
        
        return friends
    }
    
}

struct ShareRepresentable: UIViewControllerRepresentable {
    
    var message: String
    var videoURL: String = "www.youtube.com"
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let fullMessage = message + " [\(videoURL)]"
        return UIActivityViewController(activityItems: [ fullMessage ], applicationActivities: nil)
        
    }
}

