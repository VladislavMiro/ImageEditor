//
//  FiltersList.swift
//  ImageEditor
//
//  Created by Vladislav Miroshnichenko on 11.09.2025.
//

import SwiftUI

struct FiltersList: View {
    
    private var filters = Filters.allCases
    @State private var selectedIndex: Int = 0
    
    private var onTapGesture: ((Filters) -> Void)?
    
    init(onTapGesture: ((Filters) -> Void)? = nil) {
        self.onTapGesture = onTapGesture
    }
    
    var body: some View {
        VStack {
            ScrollView(.horizontal)  {
                    LazyHStack {
                        ForEach(0..<filters.count, id: \.self) { index in
                            let item = filters[index]
                            let isSelected = index == selectedIndex
                            
                            FilterCell(title: item.description, isSelected: isSelected)
                                .onTapGesture {
                                    selectedIndex = index
                                    onTapGesture?(item)
                                }
                        }
                    }.padding(.horizontal)
                }
        }
        .background(
            UnevenRoundedRectangle(cornerRadii: .init(topLeading: 16,
                                                      topTrailing: 16))
            .fill(Color.lightBlack)
        )
        .scrollIndicators(.hidden)
        
    }
}

#Preview {
    FiltersList()
}
