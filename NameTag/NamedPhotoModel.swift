//
//  NamedPhotoModel.swift
//  NameTag
//
//  Created by Juan Carlos Robledo Morales on 15/11/24.
//

import Foundation


extension NamedPhoto {
    static let savePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("NamedPhotos.json")
    
    static func save(namedPhotos: [NamedPhoto]) {
        do {
            let data = try JSONEncoder().encode(namedPhotos)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Error saving data: \(error.localizedDescription)")
        }
    }
    
    static func load() -> [NamedPhoto] {
        do {
            let data = try Data(contentsOf: savePath)
            return try JSONDecoder().decode([NamedPhoto].self, from: data)
        } catch {
            print("Error loading data: \(error.localizedDescription)")
            return []
        }
    }
}
