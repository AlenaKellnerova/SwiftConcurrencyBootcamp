//
//  AsyncLetBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Heimdal Data on 04.08.2026.
//
/*
 Async let - multiple async operations at the same time
 => wait for their result later
 - withaout async let - operations run after each other
 */

import SwiftUI

struct AsyncLetBootcamp: View {
    
    let url = URL(string: "https://picsum.photos/200")!
    
    @State private var images: [UIImage] = []
    let columns = [GridItem(.flexible()), GridItem(.flexible())] // 2 columns
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp")
            .onAppear {
                // Run after each other
//                Task {
//                    let image1 = try await fetchImage()
//                    self.images.append(image1)
//                    
//                    let image2 = try await fetchImage()
//                    self.images.append(image2)
//                    
//                    let image3 = try await fetchImage()
//                    self.images.append(image3)
//                    
//                    let image4 = try await fetchImage()
//                    self.images.append(image4)
//                    
//                    let image5 = try await fetchImage()
//                    self.images.append(image5)
//                    
//                    let image6 = try await fetchImage()
//                    self.images.append(image6)
//                }
                
                // Run at the same time - waiting until all are finished
                Task {
                    do {
                        async let fetchTitle = fetchTitle()
                        async let fetchImage1 = fetchImage()
                        async let fetchImage2 = fetchImage()
                        async let fetchImage3 = fetchImage()
                        async let fetchImage4 = fetchImage()
                        async let fetchImage5 = fetchImage()
                        async let fetchImage6 = fetchImage()
                        
                        let (image1, image2, image3, image4, image5, image6) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4, try fetchImage5, try fetchImage6)
                        self.images.append(contentsOf: [image1, image2, image4, image3, image5, image6])
                        
                        let (image, title) = await (try fetchImage1, fetchTitle)
                    } catch {
                        
                    }
                   
                }
            }
            
        }
    }
    
    func fetchTitle () async -> String {
        "Hello World"
    }
    
    func fetchImage() async throws -> UIImage {
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

#Preview {
    AsyncLetBootcamp()
}
