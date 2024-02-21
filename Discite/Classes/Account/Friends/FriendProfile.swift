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
        ScrollView(.vertical) {
            VStack(spacing: 32) {
                // photo and name
                displayBasicInfo()

                // section
                placeholderSection()

                Spacer()
            }
            .padding()
        }
        .animation(.easeIn(duration: 0.5), value: friend == nil)
        .padding()
    }

    func displayBasicInfo() -> some View {
        VStack {
            // profile photo
            displayProfilePhoto()

            // name
            Text((friend?.firstName ?? "") + " " + (friend?.lastName ?? ""))
                .font(.H3)
            
            // username
            Text(friend?.username ?? "")
                .font(.body1)
        }
    }

    func displayProfilePhoto() -> some View {
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

    func placeholderSection() -> some View {
        VStack(alignment: .leading) {
            Text("Section")
                .font(.H5)

           HStack(spacing: 8) {
               Rectangle()
                   .frame(maxWidth: .infinity, minHeight: 100)
                   .foregroundColor(.grayLight)
           }
        }
        .animation(.easeIn(duration: 0.5))
    }
}
