//
//  DetailView.swift
//  NameTag
//
//  Created by Juan Carlos Robledo Morales on 15/11/24.
//

import SwiftUI

struct DetailView: View {
    let namedPhoto: NamedPhoto

    var body: some View {
        VStack {
            if let uiImage = UIImage(data: namedPhoto.photoData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }
            Text(namedPhoto.name)
                .font(.title)
                .padding()
        }
        .navigationTitle(namedPhoto.name)
    }
}

//
//#Preview {
//    DetailView(namedPhoto: NamedPhoto)
//}
