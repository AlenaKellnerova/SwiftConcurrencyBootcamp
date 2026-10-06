//
//  DoCatchTryThrowsBoot.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Heimdal Data on 10.07.2026.
//

import SwiftUI
import Combine

class DoCatchTryThrowsBootDataManager {
    
    let isActive: Bool = true
    
    func getTitle1() -> (title: String?, error: Error?) {
        if isActive {
            return ("New text", nil)
        } else {
            return (nil, URLError(.badServerResponse))
        }
    }
    
    func getTitle2() -> Result<String, Error> {
        if isActive {
            return .success("New text")
        } else {
            return .failure(URLError(.badURL))
        }
    }
    
    func getTitle3() throws -> String {
        if isActive {
//            return "New text"
            throw URLError(.badServerResponse)
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL text"
        } else {
            throw URLError(.badServerResponse)
        }
    }
    
}

class DoCatchTryThrowsBootViewModel: ObservableObject {
    
    @Published var text: String = "Starting text.."
    let manager = DoCatchTryThrowsBootDataManager()
    
    
    func fetchTitle() {
        /*
        let returnedValue = manager.getTitle()
        if let newTitle = returnedValue.title {
            self.text = newTitle
        } else if let error = returnedValue.error {
            self.text = error.localizedDescription
        }
         */
        /*
         let result = manager.getTitle2()
         switch result {
         case .success(let newTitle):
             self.text = newTitle
         case .failure(let error):
             self.text = error.localizedDescription
         }
         */
        
        do {
            let newTitle = try? manager.getTitle3()
            if let newTitle = newTitle {
                self.text = newTitle
            }
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch let error {
            self.text = error.localizedDescription
        }
    }
         
}

struct DoCatchTryThrowsBoot: View {
    
    @StateObject private var viewModel = DoCatchTryThrowsBootViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBoot()
}
