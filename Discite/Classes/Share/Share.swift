//
//  Share.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//

import SwiftUI

struct Share: View {
    
    var playlist: Playlist
    @Binding var isShowing: Bool
    
    @State private var isShowingActivities = false
    @State private var friendSearch = ""
    @State private var message = "This playlist is perfect for you. ✨ Join me on Discite to unlock more personalized, tailored content and enhance your learning experience! 📚"
    
    @State private var friends: [Friend]?
    @State private var selection = Set<Friend>()
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                TextualButton(action: {
                    isShowing.toggle()
                }, label: "Cancel")
                
                Text("Share")
                    .font(Font.H2)
                    .padding(.top, 18)
                
                SearchBar(text: $friendSearch)
                
                // Horizontally scrolling list of friends
                ScrollView(.horizontal) {
                    HStack(spacing: 18) {
                        
                        // External messaging
                        externalMessageButton()
                        
                        // List of friends
                        if let friends {
                            ForEach(friends) { friend in
                                profileSelectButton(friend: friend)
                            }
                        }
                    }
                }
                // task: load friends
                
                // Section: Video to be shared
                // ShareCard(playlist: playlist.playlist)
                
                // Message box
                messageBox()
                
                // Share button
                shareButton()
                
            }
            .padding([.top, .bottom], 32)
            .padding([.leading, .trailing], 24)
        }
    }
    
    func moreSharingOptions() -> some View {
        Text("More sharing")
    }
    
    func externalMessageButton() -> some View {
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
    }
    
    func messageBox() -> some View {
        VStack {
            playlistPreview()
            
            Divider()
            
            // Text area
            TextField("Message", text: $message, axis: .vertical)
                .font(Font.body1)
                .lineSpacing(5)
                .frame(maxWidth: .infinity, maxHeight: 180, alignment: .top)
                .padding(12)
        }
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.grayNeutral, lineWidth: 1)
                .opacity(0.5)
        )
    }
    
    // Preview of playlist being shared
    func playlistPreview() -> some View {
        HStack {
            ZStack {
                // Placeholder
                Rectangle()
                    .fill(Color.grayNeutral)
                    .frame(width: 54, height: 54)
                
                // Check thumbnail URL
                if let url = URL(string: playlist.thumbnailURL) {
                    AsyncImage(url: url)
                        .frame(width: 54, height: 54)
                }
                
            }
            
            VStack(alignment: .leading) {
                Text("PLAYLIST").font(.small)
                Text(playlist.title).font(.H6)
            }
            
        }
    
    }
    
    // Internal share button
    func shareButton() -> some View {
        NavigationLink {
            ShareConfirmation(isShowingShare: $isShowing, playlist: playlist)
        } label: {
            primaryActionButton(label: "Share", disabled: selection.count == 0)
        }
        .disabled(selection.count == 0)
    }
    
    // Profile icons for each friend
    func profileSelectButton(friend: Friend) -> some View {
        Button {
            if selection.contains(friend) {
                selection.remove(friend)
            } else {
                selection.insert(friend)
            }
            
        } label: {
            VStack {
                Image(systemName: selection.contains(friend) ? "checkmark.circle.fill" : friend.profileImage ?? "person.circle")
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
