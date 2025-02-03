//
//  ShimmerChartView.swift
//  FourGames
//
//  Created by Stanisław Makijenko on 03/02/2025.
//

import SwiftUI
import Shimmer

struct ShimmerChartView: View {
    @EnvironmentObject var profileVm: UserProfileViewModel
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 29, height: profileVm.maxChartHeight)
            RoundedRectangle(cornerRadius: 10)
                .frame(width: profileVm.chartIconWidth, height: profileVm.chartIconWidth)
        }
        .shimmering(bandSize: 1)
        .foregroundStyle(.lightGray)
        .frame(width: 125, height: 400)
    }
}

#Preview {
    ShimmerChartView()
        .environmentObject(UserProfileViewModel())
}
