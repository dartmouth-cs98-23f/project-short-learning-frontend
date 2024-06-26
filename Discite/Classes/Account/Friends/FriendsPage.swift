//
//  FriendsPage.swift
//  Discite
//
//  Created by Jessie Li on 2/9/24.
//  Updated by Bansharee Ireen on 2/16/24.
//

import SwiftUI

struct FriendsPage: View {
    @ObservedObject var viewModel = FriendsViewModel()
    @State var friends: [Friend]?
    
    var body: some View {
        VStack(spacing: 8) {
            if viewModel.error != nil {
                Text("Nobody here to display.")
                                
            } else if friends == nil {
                ProgressView("Loading...")
                    .frame(minHeight: 400)
                    .task {
                        friends = await viewModel.getFriends()
                    }
                
            } else {
                ScrollView(.vertical) {
                    LazyVStack(alignment: .leading) {
                        ForEach(filteredFriends(friendsList: friends, searchText: viewModel.searchText)) { friend in
                            NavigationLink(destination: FriendProfile(friend: friend)) {
                                friendRow(friend: friend)
                            }
                        }
                    }
                }
                .padding(.vertical, 8)
            }
                
            Spacer()
            
        }
        .navigationTitle("Friends")
        .padding(.horizontal, 18)
        .searchable(text: $viewModel.searchText, placement: .navigationBarDrawer(displayMode: .always))
    }
    
    func friendRow(friend: Friend) -> some View {
        HStack {
            // Profile image
            if let imageStringURL = friend.profileImage,
               let imageURL = URL(string: imageStringURL) {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    placeHolderProfileImage()
                    
                }
                .frame(width: 52, height: 52)
                .clipShape(Circle())
                
            } else {
                placeHolderProfileImage()
            }
            
            VStack {
                Text(friend.username)
                    .font(.button)
                
                Text(friend.firstName + " " + friend.lastName)
                    .font(.body2)
            }
            .foregroundColor(Color.primaryBlueBlack)
        }
        .padding([.top, .bottom], 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func placeHolderProfileImage() -> some View {
        Image(systemName: "person.circle")
            .resizable()
            .scaledToFit()
            .frame(width: 48, height: 48)
    }

}

#Preview {
    FriendsPage()
}
