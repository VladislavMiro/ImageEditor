//
//  MainViewCell.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 13.09.2025.
//

import SwiftUI

struct MainViewCell: View {
    
    private let index: Int
    @State private var image: UIImage = .init()
    @EnvironmentObject var viewModel: MainViewModel
    
    init(index: Int) {
        self.index = index
    }
    
    var body: some View {
        ZStack {
            Color.white
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
        }
        .background(Color.white)
        .onAppear {
            viewModel.getImageForCell(at: index) { image in
                if let image = image {
                    self.image = image
                }
            }
        }
    }
}

#Preview {
    MainViewCell(index: 0)
}
