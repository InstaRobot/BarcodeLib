## Installation

### Swift Package Manager

1. File > Swift Packages > Add Package Dependency
2. Add `https://github.com/InstaRobot/BarcodeLib.git`

_OR_

Обновить `зависимости` в `Package.swift`
```swift
dependencies: [
    .package(url: "https://github.com/InstaRobot/BarcodeLib.git", .upToNextMajor(from: "1.0.0"))
]
```

## Usage

```swift

// заменить старый импорт на новое название модуля
import BarcodeLib

// MARK: - Обратная совместимость

Здесь ничего не поменялось, только обращение идет уже к 'BarcodeLib'


// MARK: - Новые методы (опционально)

let QR = "9y0VBn9tXu0WgNX/7uNNs0oSEKtGreAo0oDvo4B6rUz0Idk="

// Валидация QR-кода (опциоанально)
let validate = BarcodeLib.validateQR(QR)
        
print("qr: \(QR)")

// Генерация первой части билета (опционально)
let generated = BarcodeLib.generateBarcode(qrString: QR)

// Полная сборка тела билета (опционально)
let fullBarcode = generated + ...

// Баркод для билета (можно использовать старый результат из 'public static func validate(qrValue: String, ticketBarcodeValue: String) -> TicketValidatorCore.Result')
@State var barcodeImage: UIImage? = BarcodeLib.generatePDF417Barcode(from: fullBarcode)

```
