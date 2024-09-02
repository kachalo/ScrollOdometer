//
//  ContentView.swift
//  ScrollOdometer
//
//  Created by Andriy Kachalo on 8/28/24.
//

import SwiftUI

struct ContentView: View
{
	@State var distance: CGFloat = 0
	@State var scrollingInProgress = false
	
	var lengthValue: String
	{
		return formatDistance(convertPointsToInches(distance))
	}
	
	var body: some View
	{
		ZStack(alignment: .bottom)
		{
			InfiniteScrollViewRep(distance: $distance, scrollingInProgress: $scrollingInProgress)
				.ignoresSafeArea()
		
			Text(lengthValue)
				.foregroundStyle(.white)
				.font(.footnote.weight(.semibold))
				.multilineTextAlignment(.center)
				.monospacedDigit()
				.contentTransition(.numericText())
				.animation(.smooth, value: distance)
				.padding(.horizontal, 8)
				.padding(.vertical, 2)
				.background(Color.black)
				.clipShape(Capsule())
				.shadow(radius: 4, y: 2)
				.scaleEffect(scrollingInProgress ? 1.5 : 1.0)
				.animation(.smooth, value: scrollingInProgress)
		}
	}
}

#Preview
{
	ContentView()
}
