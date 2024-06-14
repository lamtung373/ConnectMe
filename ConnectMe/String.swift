//
//  String.swift
//  ConnectMe
//
//  Created by Tisp on 19/5/24.
//

import UIKit

extension String {
    func heightWithConstraineWidth(_ width: CGFloat, font: UIFont) -> CGFloat {
        let constrainRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        
        let boundingBox = self.boundingRect (with: constrainRect, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil)
        
        return ceil(boundingBox.height)
    }
}
