//
//  FriendProfile.swift
//  Discite
//
//  Created by Bansharee Ireen on 2/20/24.
//

import SwiftUI

struct FriendProfile: View {
    @State var friend: Friend?
    @State var spiderGraphData: SpiderGraphData?
    @ObservedObject var viewModel: FriendViewModel = FriendViewModel()

    let photoSize: CGFloat = 120
    let photoBorderWidth: CGFloat = 10

    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 32) {
                // photo and name
                displayBasicInfo()
                
                // possible section: friends since
                Text("Friends since September, 2023.")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                // overlapped spider graph
                displaySpiderGraph()
                    .frame(minHeight: 350)

                Spacer()
            }
            .task {
                if self.spiderGraphData == nil {
                    self.spiderGraphData = await viewModel.getSpiderGraphData()
                }
            }
            .padding()
        }
        .animation(.easeIn(duration: 0.5), value: friend == nil)
        .ignoresSafeArea(edges: .bottom)
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
    
    func displaySpiderGraph() -> some View {
            VStack(alignment: .leading) {
                Text((friend?.firstName ?? "") + "'s roles ")
                    .font(.H5)
                
                if let spiderGraphData = spiderGraphData {
                    GeometryReader { geometry in
                        let center = CGPoint(x: geometry.size.width/2, y: geometry.size.height/2)
                        
                        SpiderGraph(
                            axes: spiderGraphData.axes,
                            values: spiderGraphData.data,
                            textColor: spiderGraphData.titleColor,
                            center: center,
                            radius: 125
                        )
                    }
                } else {
                    placeholderSection()
                }
            }
            .animation(.easeIn(duration: 0.5), value: spiderGraphData == nil)
    }

    func placeholderSection() -> some View {
        VStack(alignment: .leading) {
           HStack(spacing: 8) {
               Rectangle()
                   .frame(maxWidth: .infinity, minHeight: 100)
                   .foregroundColor(.grayLight)
           }
        }
<<<<<<< HEAD
=======
        // .animation(.easeIn(duration: 0.5))
>>>>>>> 9126e65 (friend profile merge)
    }
}

//#Preview {
//    AccountView(user: User.anonymousUser)
//        .environment(TabSelectionManager(selection: .Account))
//}
