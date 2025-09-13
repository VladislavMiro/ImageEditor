//
//  ImageEditorFooter.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 12.09.2025.
//

import SwiftUI

struct ImageEditorFooter: View {
    
    @EnvironmentObject private var viewModel: ImageEditorViewModel
    
    @State private var viewHeigt = 100.0
    
    @Binding var selectedTab: ButtonType
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            if selectedTab == .filters {
                FiltersList() { selectedFilter in
                    viewModel.addFilter(of: selectedFilter)
                }
                .frame(height: viewHeigt)
            } else if selectedTab == .text {
                FontsView()
                    .frame(height: viewHeigt)
                    .environmentObject(viewModel)
            }
            
            
            VStack(alignment: .leading) {
                Divider()
                    .overlay(Color.white)
                    .padding(.all, 0)
                
                HStack {
                    ImageEditorFooterButton(image: "camera.filters", title: "filters") {
                        selectedTab = selectedTab == .filters ? .none : .filters
                    }
                    
                    ImageEditorFooterButton(image: "pencil.line", title: "Draw") {
                        selectedTab = selectedTab == .draw ? .none : .draw
                    }
                    
                    ImageEditorFooterButton(image: "character.cursor.ibeam",
                                            title: "Text") {
                        selectedTab = selectedTab == .text ? .none : .text
                    }
                }
                .padding()
                
            }
            .background(Color.lightBlack)
            
        }
        .background(Color.clear)
        .onChange(of: selectedTab) { selectedTab in
            switch selectedTab {
            case .filters:
                viewHeigt = 100
            case .draw:
                viewHeigt = 0
            case .text:
                viewHeigt = 130
            case .none:
                viewHeigt = 0
            }
        }
        
    }
}

//MARK: - Extension with subobjects

extension ImageEditorFooter {
    
    enum ButtonType: Hashable {
        case filters
        case draw
        case text
        case none
    }
    
}

#Preview {
    ImageEditorFooter(selectedTab: .constant(.none))
        .environmentObject(ImageEditorViewModel())
}
