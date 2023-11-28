## Installation

### Swift Package Manager

1. File > Swift Packages > Add Package Dependency
2. Add `https://github.com/InstaRobot/BarcodeLib.git`

_OR_

Update `dependencies` in `Package.swift`
```swift
dependencies: [
    .package(url: "https://github.com/InstaRobot/BarcodeLib.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

```swift

import BarcodeLib

// Examples
let oldQR = "9y0VBn9tXu0WgNX/7uNNs0oSEKtGreAo0oDvo4B6rUz0Idk="
let newQR = "CigIkQMQARoXCLCp+KkGEJFGGIGJeiIIcZkionHjEe4iCDvHIJDZ9SefCl0IkAMQARoQCKjA6KkGEgQRIwAAGIGJeiJEUj4DwLdjHYEjPNGwzDt1p5UwMwuAsMHDumyGbxrAHYLg/ENvGCKxedAbY50htGTGTzcDz3c9/fXLzSxm+wA8iJThug4="

// Validation for QR-reader
let validateOld = BarcodeLib.validateQR(oldQR)
let validateNew = BarcodeLib.validateQR("newQR")
        
print("old: \(validateOld)")
print("new: \(validateNew)")

// Generate first part for barcode
let generatedOld = BarcodeLib.generateBarcode(qrString: oldQR)
let generatedNew = BarcodeLib.generateBarcode(qrString: newQR)

// all parts for barcode
let fullBarcode1 = generatedOld + ...
let fullBarcode2 = generatedNew + ...

// Images from barcode strings
@State var barcodeImageOld: UIImage? = BarcodeLib.generatePDF417Barcode(from: fullBarcode1)
@State var barcodeImageNew: UIImage? = BarcodeLib.generatePDF417Barcode(from: fullBarcode2)

```
