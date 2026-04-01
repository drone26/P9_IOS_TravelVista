//
//  TitleView.swift
//  TravelVista
//
//  Created by Mathieu ARRIO on 26/03/2026.
//

import SwiftUI

struct TitleView: View {
    let name: String
    let capital: String
    let rate: Int
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(name)
                    .font(.system(size: 22, weight: .medium))
                    .foregroundColor(Color("CustomBlue"))
                    .frame(height: 28)
                Text(capital)
                    .font(.system(size: 17))
                    .foregroundColor(Color(UIColor.darkGray))
                    .frame(height: 21)
            }
            .padding(.vertical, 8)
            .padding(.leading, 20)
            
            Spacer()
            
            HStack(spacing: 0) {
                ForEach(0..<rate, id: \.self) { _ in
                    Image(systemName: "star.fill")
                        .font(.system(size: 15))
                        .frame(width: 19, height: 19)
                        .clipped()
                        .foregroundColor(Color("CustomSand"))
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 16)
            
        }
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    TitleView(name: "France", capital: "Paris", rate: 5)
}
