//
//  Share.swift
//  Discite
//
//  Created by Jessie Li on 11/12/23.
//  Updated by Bansharee Ireen on 02/16/24.
//

import SwiftUI

struct Share: View {

    var playlist: Playlist
    @Binding var isShowing: Bool

    @State private var isShowingActivities = false
    @State private var friendSearch = ""
    @State private var message = "Wanted to share a playlist with you. Join me on Discite to unlock personalized and engaging computer science content, made for the modern attention span.\n"

    @ObservedObject var viewModel = FriendsViewModel()
    @State private var friends: [Friend]?
    @State private var selection = Set<Friend>()

    var body: some View {
            NavigationStack {
                VStack {
                    VStack(alignment: .leading, spacing: 16) {
                        // Horizontally scrolling list of friends
                        if let friends = friends {
                            ScrollView(.horizontal) {
                                HStack(spacing: 18) {
                                    ForEach(filteredFriends(friendsList: friends, searchText: friendSearch)) { friend in
                                        profileSelectButton(friend: friend)
                                            .frame(minWidth: 56)
                                    }
                                }
                            }
                            .frame(minHeight: 84)
                        }

                        // Add friend or Export
                        moreSharingOptions()

                        // Message box
                        messageBox()

                        Spacer()

                        // Share button
                        shareButton()
                    }
                }
                .animation(.spring(duration: 1), value: friends == nil)
                .task {
                    if friends == nil && viewModel.error == nil {
                        friends = await viewModel.getFriends()
                    }
                }
                .sheet(isPresented: self.$isShowingActivities) {
                    ShareRepresentable(message: message)
                        .ignoresSafeArea()
                }
                .navigationTitle("Share")
                .padding(18)
            }
            .foregroundColor(.primaryBlueBlack)
            .background(.white)
            .searchable(text: $friendSearch, prompt: "Share with")
    }

    func moreSharingOptions() -> some View {
        VStack(spacing: 4) {
            Text("Can't find who you're looking for?")
                .font(.body2)

            HStack {
                Button("Add friend") { }
                    .foregroundColor(.secondaryPurplePink)

                Text("or")
                    .foregroundColor(.primaryBlueBlack)

                Button("Export") {
                    self.isShowingActivities.toggle()
                }
                .foregroundColor(.secondaryPurplePink)
            }
            .font(.button)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background {
            RoundedRectangle(cornerRadius: 5)
                .strokeBorder(Color.secondaryPurplePink, lineWidth: 2)
        }
    }

    func messageBox() -> some View {
        VStack(alignment: .leading, spacing: 8) {
            playlistPreview()
                .padding(.horizontal, 8)

            Divider()

            // Text area
            TextField("Message", text: $message, axis: .vertical)
                .font(Font.body1)
                .lineSpacing(5)
                .frame(maxWidth: .infinity, maxHeight: 180, alignment: .top)
                .padding(.horizontal, 12)
        }
        .padding(.vertical, 8)
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
                if let thumbnailURL = playlist.thumbnailURL,
                   let url = URL(string: thumbnailURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 54, height: 54)
                            .clipShape(RoundedRectangle(cornerRadius: 5))
                    } placeholder: {
                        Rectangle()
                            .fill(Color.grayNeutral)
                            .frame(width: 54, height: 54)
                    }
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
            primaryActionButton(label: "Share", disabled: selection.count == 0, maxWidth: .infinity)
        }
        .disabled(selection.count == 0)
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
                if selection.contains(friend) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 52, height: 52)

                } else {
                    if let imageStringURL = friend.profileImage,
                       let imageURL = URL(string: imageStringURL) {
                        AsyncImage(url: imageURL) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)

                        } placeholder: {
                            Image(systemName: "person.circle")
                                .resizable()
                                .scaledToFit()

                        }
                        .frame(width: 54, height: 54)
                        .clipShape(Circle())

                    } else {
                        Image(systemName: "person.circle")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 54, height: 54)
                    }
                }

                Text(friend.username).font(Font.small)
            }
            .animation(.easeInOut(duration: 0.3), value: selection.contains(friend))
        }
        .foregroundColor(Color.primaryBlueBlack)
    }

    func clearProfileSelection() {
        selection.removeAll()
    }
}

struct ShareRepresentable: UIViewControllerRepresentable {

    var message: String
    var appStoreLink: URL = URL(string: "https://apps.apple.com/us/app/discite/id6471923551")!

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }

    func makeUIViewController(context: Context) -> UIViewController {
        return UIActivityViewController(activityItems: [ message, appStoreLink ], applicationActivities: nil)

    }
}
