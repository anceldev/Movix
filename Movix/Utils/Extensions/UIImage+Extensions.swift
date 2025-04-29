//
//  UIImage+Extensions.swift
//  Movix
//
//  Created by Ancel Dev account on 21/4/25.
//

import Foundation
import UIKit

extension UIImage {
    func resizeTo(to imageSize: CGFloat) -> UIImage? {
        let targetSize = CGSize(width: imageSize, height: imageSize)
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        let scaledImageSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)
        
        UIGraphicsBeginImageContextWithOptions(scaledImageSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: scaledImageSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
