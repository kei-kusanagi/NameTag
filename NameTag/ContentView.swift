//
//  ContentView.swift
//  NameTag
//
//  Created by Juan Carlos Robledo Morales on 15/11/24.
//

import SwiftUI
import PhotosUI


struct NamedPhoto: Identifiable, Codable {
    let id: UUID
    let name: String
    let photoData: Data
}

struct ContentView: View {
    @State private var namedPhotos: [NamedPhoto] = NamedPhoto.load()
    @State private var selectedImageData: Data? = nil
    @State private var photoName: String = ""
    @State private var selectedPhoto: PhotosPickerItem? = nil

    var body: some View {
        NavigationView {
            VStack {
                // Lista de fotos guardadas
                List(namedPhotos) { namedPhoto in
                    NavigationLink(destination: DetailView(namedPhoto: namedPhoto)) {
                        HStack {
                            if let uiImage = UIImage(data: namedPhoto.photoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                            }
                            Text(namedPhoto.name)
                        }
                    }
                    
                }
                List {
                    ForEach(namedPhotos) { namedPhoto in
                        NavigationLink(destination: DetailView(namedPhoto: namedPhoto)) {
                            HStack {
                                if let uiImage = UIImage(data: namedPhoto.photoData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                }
                                Text(namedPhoto.name)
                            }
                        }
                    }
                    .onDelete(perform: deletePhoto)
                }


                Spacer()

                // Botón para agregar una nueva foto
                VStack {
                    PhotosPicker(
                        selection: $selectedPhoto,
                        matching: .images,
                        photoLibrary: .shared()
                    ) {
                        Text("Add New Photo")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    .onChange(of: selectedPhoto) { newItem in
                        guard let newItem else { return }
                        Task {
                            if let data = try? await newItem.loadTransferable(type: Data.self) {
                                selectedImageData = data
                                addPhoto()
                            }
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("NameTag")
            .onAppear {
                namedPhotos = NamedPhoto.load()
            }
        }
    }

    func addPhoto() {
        guard let imageData = selectedImageData, !photoName.isEmpty else { return }
        let newPhoto = NamedPhoto(id: UUID(), name: photoName, photoData: imageData)
        namedPhotos.append(newPhoto)
        NamedPhoto.save(namedPhotos: namedPhotos)
        selectedImageData = nil
        photoName = ""
    }
    
    func deletePhoto(at offsets: IndexSet) {
        namedPhotos.remove(atOffsets: offsets)
        NamedPhoto.save(namedPhotos: namedPhotos)
    }

}


#Preview {
    ContentView()
}
