//
//  Model.swift
//  ScrollOdometer
//
//  Created by Andriy Kachalo on 9/1/24.
//

import UIKit

// Using data from https://www.ios-resolution.com.
func convertPointsToInches(_ points: CGFloat, for screen: UIScreen = .main) -> CGFloat
{
	let scale = screen.scale
	let nativePixels = points * scale
	
	let ppi: CGFloat
	if screen.traitCollection.userInterfaceIdiom == .pad
	{
		ppi = 326 // Typical PPI for iPads
	}
	else
	{
		switch screen.nativeBounds.height
		{
		
		// iPhone 12 mini, 13 mini
		case 2340:
			ppi = 476

		// iPhone 15, 15 Plus, 15 Pro, 15 Pro Max, 14, 14 Pro, 14 Pro Max, 12, 12 Pro, 13, 13 Pro
		case 2556, 2796, 2532:
			ppi = 460
			
		// iPhone X, XS, XS Max, 11 Pro, 11 Pro Max, 12 Pro, 12 Pro Max, 13 Pro, 13 Pro Max, 14 Plus
		case 2436, 2688, 2778:
			ppi = 458
			
		// iPhone 6 Plus, 6S Plus, 7 Plus, 8 Plus
		case 1920:
			ppi = 401

		// Others
		default:
			ppi = 326
		}
	}
	
	return nativePixels / ppi
}

func formatDistance(_ inches: CGFloat) -> String
{
	let formatter = LengthFormatter()
	let measurement = Measurement(value: Double(inches), unit: UnitLength.inches)
	
	let value: (Double, LengthFormatter.Unit)
	let fractionDigits: Int
	
	if Locale.current.measurementSystem == .metric
	{
		let centimeters = measurement.converted(to: .centimeters).value
		let meters = measurement.converted(to: .meters).value
		if centimeters < 100
		{
			fractionDigits = 0
			value = (centimeters, .centimeter)
		}
		else if meters < 1000
		{
			fractionDigits = 1
			value = (meters, .meter)
		}
		else
		{
			fractionDigits = 2
			value = (meters / 1000, .kilometer)
		}
	}
	else
	{
		let feet = measurement.converted(to: .feet).value
		if inches < 12
		{
			fractionDigits = 0
			value = (inches, .inch)
		}
		else if feet < 5280
		{
			fractionDigits = 1
			value = (feet, .foot)
		}
		else
		{
			fractionDigits = 2
			value = (feet / 5280, .mile)
		}
	}
	
	formatter.numberFormatter.minimumFractionDigits = fractionDigits
	formatter.numberFormatter.maximumFractionDigits = fractionDigits
	return formatter.string(fromValue: value.0, unit: value.1)
}
