//
//  AsyncAwaitBoot.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Heimdal Data on 23.07.2026.
//

/*
 await - we may/ may not be switching threads
 but we do updates on the main thread
 - when having multiple await func after each other - they do execute in order - after first one is complete, the second one runs
 */

import SwiftUI
import Combine

class AsyncAwaitBootViewModel: ObservableObject {
    
    @Published var dataArray: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataArray.append("Title1 : \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2 : \(Thread.current)"
            DispatchQueue.main.async {
                self.dataArray.append(title)
                
                let title3 = "Title3 : \(Thread.current)"
                self.dataArray.append(title3)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1 : \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(author2)
            let author3 = "Author3 : \(Thread.current)"
            self.dataArray.append(author3)
        }
       
//        await addSomething()
    }
    
    func addSomething() async {
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let something1 = "Something1 : \(Thread.current)"
        await MainActor.run {
            self.dataArray.append(something1)
            
            let something2 = "Something2 : \(Thread.current)"
            self.dataArray.append(something2)
        }
    }
}

struct AsyncAwaitBoot: View {
    
    @StateObject private var viewModel = AsyncAwaitBootViewModel()
    
    var body: some View {
        VStack {
            Text("Hey")
                .font(.largeTitle)
                .padding()
            
            List {
                ForEach(viewModel.dataArray, id: \.self) { data in
                    Text(data)
                }
            }
        }
       
        .onAppear {
//            viewModel.addTitle1()
//            viewModel.addTitle2()
            Task {
                await viewModel.addAuthor1()
                await viewModel.addSomething()
                
                let finalText = "Final Text: \(Thread.current)"
                viewModel.dataArray.append(finalText)
            }
        }
    }
}

#Preview {
    AsyncAwaitBoot()
}
