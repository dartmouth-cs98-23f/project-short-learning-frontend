//
//  FriendProfile.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/20/24.
//

import SwiftUI

struct FriendProfile: View {
    @State var friend: Friend?

    let photoSize: CGFloat = 120
    let photoBorderWidth: CGFloat = 10

    var body: some View {
        VStack {
            DisplayProfilePhoto()

            Text((friend?.firstName ?? "") + " " + (friend?.lastName ?? ""))
                .font(.H3)
            
            Text(friend?.username ?? "")
                .font(.body1)

            Spacer()
        }
        .animation(.easeIn(duration: 0.5), value: friend == nil)
    }

    func DisplayProfilePhoto() -> some View {
        VStack {
            if let friend = friend,
            let imageStringURL = friend.profileImage,
            let imageURL = URL(string: imageStringURL) {
                ZStack {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            // loading
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: photoSize, height: photoSize)
                                .clipShape(Circle())
                        case .failure:
                            // error image
                            Image(systemName: "photo")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: photoSize, height: photoSize)
                                .clipShape(Circle())
                        }
                    }

                    // border around image
                    Circle()
                        .stroke(Color.black, lineWidth: photoBorderWidth)
                        .frame(width: photoSize+photoBorderWidth, height: photoSize+photoBorderWidth) 
                }
            }
        }
    }
}
