// The Swift Programming Language
// https://docs.swift.org/swift-book
//
//  BarcodeLib.swift
//  Created by Vitaliy Podolskiy on 28.11.2023.
//

import Foundation
import UIKit

public struct BarcodeLib {
    /// QRCode validation from device
    /// - Parameter qrString: string for validation
    /// - Returns: result of validation
    public static func validateQR(_ qrString: String) -> Bool {
        if
            qrString.count == 48 &&
            qrString[qrString.index(qrString.startIndex, offsetBy: 10)] == "0" &&
            qrString[qrString.index(qrString.startIndex, offsetBy: 21)] == "0" &&
            qrString[qrString.index(qrString.startIndex, offsetBy: 32)] == "0" &&
            qrString[qrString.index(qrString.startIndex, offsetBy: 43)] == "0"
        {
            return true
        }
        else {
            let pattern1 = "^(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?$"
            let pattern2 = "^[\\w\\d+=/]+$"
            let range = NSRange(location: 0, length: qrString.utf16.count)
            do {
                var regex = try NSRegularExpression(pattern: pattern1)
                
                if let _ = regex.firstMatch(in: qrString, options: [], range: range) {
                    return true
                }
                else {
                    regex = try NSRegularExpression(pattern: pattern2)
                    if let _ = regex.firstMatch(in: qrString, options: [], range: range) {
                        return true
                    }
                }
            }
            catch {
                return false
            }
        }
        
        return false
    }
    
    /// Generate part of barcode
    /// - Parameter qrString: qr string from reader
    /// - Returns: generated string
    public static func generateBarcode(qrString: String) -> String {
        let qrCodeBytes = [UInt8](qrString.utf8)
        let qrCodeBytesString = qrCodeBytes.map({ String($0) }).joined(separator: " ") + " "
        
        return qrCodeBytesString
    }
    
    /// Generate barcode image
    /// - Parameter string: qr string + body string
    /// - Returns: UIImage or NIL
    public static func generatePDF417Barcode(from string: String) -> UIImage? {
        let separatedString = string.components(separatedBy: " ")
        let bytes: [Int8] = separatedString.compactMap( { Int8($0) })
        let data = Data(bytes: bytes, count: bytes.count)
        
        if let filter = CIFilter(name: "CIPDF417BarcodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            filter.setValue(4.0, forKey: "inputCorrectionLevel")
            filter.setValue(4, forKey: "inputDataColumns")
            filter.setValue(0.3333, forKey: "inputPreferredAspectRatio")
            
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            guard let image = filter.outputImage?.transformed(by: transform) else {
                return nil
            }
            
            let colorSpace = CGColorSpaceCreateDeviceRGB()
            let contextOptions: [CIContextOption : Any]? = [
                CIContextOption.workingColorSpace : colorSpace,
                CIContextOption.outputColorSpace : colorSpace,
                CIContextOption.useSoftwareRenderer : true,
                CIContextOption.outputPremultiplied : true
            ]
            guard let image_ref = CIContext(options: contextOptions).createCGImage(image, from: image.extent) else {
                return nil
            }
            let images = BarcodeMaker.arrayOfInvertedPDF417Images(imageRef: image_ref)
            return images?.first
        }
        
        return nil
    }
}
