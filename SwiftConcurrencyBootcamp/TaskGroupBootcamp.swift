//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Heimdal Data on 06.08.2026.
//

import SwiftUI
import Combine

class TaskBootcampDataManager {
    
    func fetchImages() async throws -> [UIImage] {
        
        async let fetchImage1 = fetchImage(with: "https://picsum.photos/200")
        async let fetchImage2 = fetchImage(with: "https://picsum.photos/200")
        async let fetchImage3 = fetchImage(with: "https://picsum.photos/200")
        async let fetchImage4 = fetchImage(with: "https://picsum.photos/200")
        async let fetchImage5 = fetchImage(with: "https://picsum.photos/200")
        async let fetchImage6 = fetchImage(with: "https://picsum.photos/200")
        
        let (image1, image2, image3, image4, image5, image6) = try await (fetchImage1, fetchImage2, fetchImage3, fetchImage4, fetchImage5, fetchImage6)
        
        return [image1, image2, image3, image4, image5, image6]
    }
    
//    func fetchImages
    
    func fetchWithTaskGroup() async throws -> [UIImage] {
        
        try await withThrowingTaskGroup(of: UIImage.self) { group in
            var images: [UIImage] = []
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            
            for try await image in group {
                images.append(image)
            }
            
            return images
        }
        
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        
        try await withThrowingTaskGroup(of: UIImage.self) { group in
            
            var images: [UIImage] = []
            print("inside task group")
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            group.addTask {
                try await self.fetchImage(with: "https://picsum.photos/200")
            }
            
            for try await taskResult in group {
                images.append(taskResult)
            }
            
            return images
        }
    }
    
    func fetchImagesWithTaskGroup2() async throws -> [UIImage] {
        
        let urlStrings = [
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
            "https://picsum.photos/200",
        ]
        
        return try await withThrowingTaskGroup(of: UIImage?.self) { group in
            var images: [UIImage] = []
            images.reserveCapacity(urlStrings.count)
            
            for urlString in urlStrings {
                group.addTask {
                    try? await self.fetchImage(with: urlString)
                }
            }
            
            for try await image in group {
                if let image {
                    images.append(image)
                }
            }
            
            return images
        }
    }
    
    
    private func fetchImage(with url: String) async throws -> UIImage {
        
        guard let url = URL(string: url) else {
            throw URLError(.badURL)
        }
        do {
          let (data, _) = try await URLSession.shared.data(from: url)
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch {
            throw error
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    
    @Published var images: [UIImage] = []
    let manager = TaskBootcampDataManager()
    
    func fetchImages() async {
//        if let images = try? await manager.fetchImages() {
//            self.images = images
//        }
//        if let images = try? await manager.fetchImagesWithTaskGroup() {
//            self.images = images
//        }
        if let images = try? await manager.fetchImagesWithTaskGroup2() {
            self.images = images
        }
    }
}

struct TaskGroupBootcamp: View {
    
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Task Group")
            .task {
                await viewModel.fetchImages()
            }
        }
    }
    
    
}

#Preview {
    TaskGroupBootcamp()
}
