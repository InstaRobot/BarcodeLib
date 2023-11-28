//
//  BarcodeMaker.swift
//  Created by Vitaliy Podolskiy on 28.11.2023.
//

import Foundation
import UIKit

struct BarcodeMaker {
    static func arrayOfInvertedPDF417Images(imageRef: CGImage) -> [UIImage]? {
        let originalMask = imageRef
        let image = UIImage(cgImage: originalMask)
        
        UIGraphicsBeginImageContext(image.size)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
            return nil
        }
        UIGraphicsEndImageContext()
        
        guard let png = newImage.pngData() else {
            return nil
        }
        let imageDataRef = png as CFData
        guard let imgDataProvider = CGDataProvider(data: imageDataRef) else {
            return nil
        }
        guard let mask = CGImage(
            pngDataProviderSource: imgDataProvider, 
            decode: nil, 
            shouldInterpolate: true, 
            intent: .defaultIntent
        ) 
        else {
            return nil
        }
        
        let bitsPerPixel = 32
        let bitsPerComponent = 8
        let bytesPerPixel = bitsPerPixel / bitsPerComponent
        let width = mask.width
        let height = mask.height
        let rect = CGRect(x: 0, y: 0, width: width, height: height)
        let bytesPerRow = width * bytesPerPixel
        let bufferLength = bytesPerRow * height
        
        var result = [UIImage]()
        
        for _ in 0 ..< 7 {
            guard let context = CGContext(
                data: malloc(bufferLength),
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: mask.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
            ) 
            else {
                continue
            }
            context.draw(mask, in: rect)
            
            guard let buf = context.data?.assumingMemoryBound(to: UInt8.self) else {
                continue
            }
            for i in stride(from: 0, to: bufferLength - 3, by: 4) {
                let r = buf[i]
                let g = buf[i + 1]
                let b = buf[i + 2]
                
                let sum = Int(r) + Int(g) + Int(b)
                if sum == 0 {
                    buf[i + 3] = 0
                }
            }
            
            for _ in 0 ..< 40 {
                let padding = 4
                let x = Int.random(in: padding ..< (width - padding))
                var y = Int.random(in: padding ..< (height - padding))
                y -= y % 3 + 1 // 0.33 dot ratio
                if x <= 20 || x >= width - 20 || y <= 4 || y >= height - 4 {
                    continue
                }
                
                for k in 0 ..< 3 {
                    for rgba in 0 ..< 4 {
                        buf[4 * x + (y + k) * bytesPerRow + rgba] = 0 // transparent
                    }
                }
            }
            
            guard let ctx = CGContext(
                data: buf,
                width: width,
                height: height,
                bitsPerComponent: bitsPerComponent,
                bytesPerRow: bytesPerRow,
                space: mask.colorSpace ?? CGColorSpaceCreateDeviceRGB(),
                bitmapInfo: CGImageAlphaInfo.premultipliedFirst.rawValue
            ), let imageRef = ctx.makeImage() else {
                continue
            }
            
            let rawImage = UIImage(cgImage: imageRef)
            result.append(rawImage)
        }
        
        return result
    }
}
