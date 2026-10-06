//
//  TaskGroupBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Heimdal Data on 06.08.2026.
//

import SwiftUI
import Combine

class TaskBootcampDataManager {
    
//    func fetchImages() async -> [UIImage] {
//        async let fetchImage1 = fetchImage(with: "https://picsum.photos/200")
//        async let fetchImage2 = fetchImage(with: "https://picsum.photos/200")
//        async let fetchImage3 = fetchImage(with: "https://picsum.photos/200")
//        async let fetchImage4 = fetchImage(with: "https://picsum.photos/200")
//        async let fetchImage5 = fetchImage(with: "https://picsum.photos/200")
//        async let fetchImage6 = fetchImage(with: "https://picsum.photos/200")
//        
//        let (image1, image2, image3, image4, image5, image6) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5, try fetchImage6)
//    }
    
    
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
        }
    }
    
    
}

#Preview {
    TaskGroupBootcamp()
}
