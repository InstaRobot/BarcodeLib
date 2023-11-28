//
//  ContentView.swift
//  Example
//
//  Created by Vitaliy Podolskiy on 28.11.2023.
//

import SwiftUI
import BarcodeLib

let oldQR = "9y0VBn9tXu0WgNX/7uNNs0oSEKtGreAo0oDvo4B6rUz0Idk="
let newQR = "CigIkQMQARoXCLCp+KkGEJFGGIGJeiIIcZkionHjEe4iCDvHIJDZ9SefCl0IkAMQARoQCKjA6KkGEgQRIwAAGIGJeiJEUj4DwLdjHYEjPNGwzDt1p5UwMwuAsMHDumyGbxrAHYLg/ENvGCKxedAbY50htGTGTzcDz3c9/fXLzSxm+wA8iJThug4="

let ticketBody: [Double] = [
    22.0,
    -48.0,
    15.0,
    12.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    0.0,
    112.0,
    -90.0,
    101.0,
    101.0,
    72.0,
    20.0,
    15.0,
    0.0,
    71.0,
    89.0,
    3.0,
    -64.0,
    -99.0,
    -23.0,
    57.0,
    -112.0,
    -11.0,
    -115.0,
    6.0,
    -102.0,
    99.0,
    61.0,
    43.0,
    42.0,
    -36.0,
    125.0,
    61.0,
    121.0,
    -22.0,
    -16.0,
    9.0,
    54.0,
    118.0,
    -73.0,
    80.0,
    21.0,
    75.0,
    -109.0,
    92.0,
    15.0,
    -126.0,
    -43.0,
    -30.0,
    -85.0,
    -44.0,
    53.0,
    98.0,
    -48.0,
    -28.0,
    -17.0,
    -109.0,
    -113.0,
    55.0,
    122.0,
    4.0,
    -99.0,
    13.0,
    92.0,
    78.0,
    125.0,
    77.0,
    12.0,
    -45.0,
    -118.0,
    103.0,
    -65.0,
    -50.0,
    110.0,
    69.0,
    92.0,
    100.0,
    29.0,
    -108.0,
    -86.0,
    37.0,
    41.0
]

struct ContentView: View {
    @State var barcodeImageOld: UIImage?
    @State var barcodeImageNew: UIImage?
    
    var barcodeBody: String {
        let bytes = ticketBody.map { Int($0) }
        let barcodeString = bytes.map({ String($0) }).joined(separator: " ")
        return barcodeString
    }
    
    var fullBarcode1: String = ""
    var fullBarcode2: String = ""
    
    init() {
        let validateOld = BarcodeLib.validateQR(oldQR)
        let validateNew = BarcodeLib.validateQR(newQR)
        
        print("old: \(validateOld)")
        print("new: \(validateNew)")
        
        let generatedOld = BarcodeLib.generateBarcode(qrString: oldQR)
        let generatedNew = BarcodeLib.generateBarcode(qrString: newQR)
        
        print(generatedOld)
        print("************")
        print(generatedNew)
        
        
        fullBarcode1 = generatedOld + barcodeBody
        fullBarcode2 = generatedNew + barcodeBody
        
        print("************")
        print(fullBarcode1)
        print("************")
        print(fullBarcode2)
    }
    
    var body: some View {
        VStack(spacing: 40) {
            Text("OLD TICKET")
                .font(.title)
            if let imageOld = barcodeImageOld {
                Rectangle()
                    .overlay(
                        Image(uiImage: imageOld)
                            .resizable()
                            .frame(height: 128)
                    )
                    .foregroundColor(.black)
                    .frame(height: 128)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else {
                Rectangle()
                    .overlay(
                        Text("Error generating barcode")
                            .foregroundColor(.black.opacity(0.2))
                    )
                    .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 121)
                    .foregroundColor(.gray)
                    .padding()
            }
            Text("NEW TICKET")
                .font(.title)
            if let imageNew = barcodeImageNew {
                Rectangle()
                    .overlay(
                        Image(uiImage: imageNew)
                            .resizable()
                            .frame(height: 128)
                    )
                    .foregroundColor(.black)
                    .frame(height: 128)
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
            }
            else {
                Rectangle()
                    .overlay(
                        Text("Error generating barcode")
                            .foregroundColor(.black.opacity(0.2))
                    )
                    .frame(maxWidth: .infinity, minHeight: 120, maxHeight: 121)
                    .foregroundColor(.gray)
                    .padding()
            }
        }
        .task {
            barcodeImageOld = BarcodeLib.generatePDF417Barcode(from: fullBarcode1)
            barcodeImageNew = BarcodeLib.generatePDF417Barcode(from: fullBarcode2)
        }
    }
}

#Preview {
    ContentView()
}
