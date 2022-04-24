//
//  Utils.swift
//  LastFMClone
//
//  Created by shayan amindaneshpour on 10/11/21.
//

import UIKit

//MARK: - Device
struct ScreenSize
{
    static let SCREEN_WIDTH = UIScreen.main.bounds.size.width
    static let SCREEN_HEIGHT = UIScreen.main.bounds.size.height
}

extension String {
  
    var withoutHTMLTag: String {
        if let data = self.data(using: .unicode) {
            let attributed = try? NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
            return attributed?.string ?? self
            
        }
        return self
    }
    
}

