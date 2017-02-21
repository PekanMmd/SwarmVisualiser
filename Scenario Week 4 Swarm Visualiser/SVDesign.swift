//
//  SVDesign.swift
//  Scenario Week 4 Swarm Visualiser
//
//  Created by The Steez on 20/02/2017.
//  Copyright © 2017 UCL. All rights reserved.
//

import Cocoa

typealias SVColour = NSColor

extension SVColour {
	
	convenience init(hex: Double) {
		let red   = Float( (hex  / 0x1000000) / 0xFF )
		let green = Float( ((hex / 0x10000).truncatingRemainder(dividingBy: 0x100) / 0xFF) )
		let blue  = Float( ((hex / 0x100).truncatingRemainder(dividingBy: 0x100) / 0xFF) )
		let alpha = Float( (hex.truncatingRemainder(dividingBy: 0x100) / 0xFF) )
		
		self.init(colorLiteralRed: red, green: green, blue: blue, alpha: alpha)
	}
}


class SVDesign: NSObject {
	
	//MARK: - Fonts
	class func fontOfSize(size: CGFloat) -> NSFont {
		return NSFont(name: "Helvetica", size: size)!
	}
	
	class func fontBoldOfSize(size: CGFloat) -> NSFont {
		return NSFont(name: "Helvetica Bold", size: size)!
	}
	
	
	//MARK: - Sizes
	class func sizeCornerRadius() -> CGFloat {
		return 12.0
	}
	
	class func sizeBottomButton() -> CGFloat {
		return 60.0
	}
	
	class func sizeLineWidth() -> CGFloat {
		return 2.0
	}
	
	class func sizeBorderWidth() -> CGFloat {
		return 1.0
	}
	
	class func sizePointWidth() -> CGFloat {
		return 3.0
	}
	
	
	//MARK: - Colours
	class func colourBlack() -> SVColour {
		return SVColour(hex: 0x000000FF)
	}
	
	class func colourWhite() -> SVColour {
		return SVColour(hex: 0xFFFFFFFF)
	}
	
	class func colourRed() -> SVColour {
		return SVColour(hex: 0xFC8868FF)
	}
	
	class func colourOrange() -> SVColour {
		return SVColour(hex: 0xF7B409FF)
	}
	
	class func colourYellow() -> SVColour {
		return SVColour(hex: 0xF8F8A8FF)
	}
	
	class func colourGreen() -> SVColour {
		return SVColour(hex: 0xC8E89CFF)
	}
	
	class func colourBlue() -> SVColour {
		return SVColour(hex: 0x70ACFFFF)
	}
	
	class func colourPurple() -> SVColour {
		return SVColour(hex: 0xC207EDFF)
	}
	
	class func colourPink() -> SVColour {
		return SVColour(hex: 0xFC80F6FF)
	}
	
	class func colourNavy() -> SVColour {
		return SVColour(hex: 0x28276BFF)
	}
	
	class func colourLightBlack() -> SVColour {
		return SVColour(hex: 0x282828FF)
	}
	
	class func colourGrey() -> SVColour {
		return SVColour(hex: 0xC0C0C8FF)
	}
	
	class func colourDarkGrey() -> SVColour {
		return SVColour(hex: 0xA0A0A8FF)
	}
	
	class func colourLightGrey() -> SVColour {
		return SVColour(hex: 0xF0F0FCFF)
	}
	
	class func colourMainTheme() -> SVColour {
		return colourBlue()
	}
	
	class func colourBackground() -> SVColour {
		return colourLightGrey()
	}
	
	class func colourBlur() -> SVColour {
		return SVColour(hex: 0x70ACFF80)
	}
	
	
}

