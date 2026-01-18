#!/usr/bin/env swift

import AppKit
import Foundation

let size = CGSize(width: 1024, height: 1024)
let cornerRadius: CGFloat = 228 // iOS icon corner radius ratio

// Create image
let image = NSImage(size: size)
image.lockFocus()

// Background gradient (soft teal to blue)
let context = NSGraphicsContext.current!.cgContext
let colorSpace = CGColorSpaceCreateDeviceRGB()
let colors = [
    NSColor(red: 0.4, green: 0.8, blue: 0.85, alpha: 1.0).cgColor,
    NSColor(red: 0.3, green: 0.5, blue: 0.9, alpha: 1.0).cgColor
]
let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: [0.0, 1.0])!

// Rounded rect path
let rect = CGRect(origin: .zero, size: size)
let path = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
path.addClip()

// Draw gradient
context.drawLinearGradient(gradient, start: CGPoint(x: 0, y: size.height), end: CGPoint(x: size.width, y: 0), options: [])

// Draw checkmark icon
let checkmarkPath = NSBezierPath()
let centerX = size.width / 2
let centerY = size.height / 2
let scale: CGFloat = 280

// Checkmark coordinates
checkmarkPath.move(to: CGPoint(x: centerX - scale * 0.9, y: centerY - scale * 0.1))
checkmarkPath.line(to: CGPoint(x: centerX - scale * 0.3, y: centerY - scale * 0.7))
checkmarkPath.line(to: CGPoint(x: centerX + scale * 0.9, y: centerY + scale * 0.7))

checkmarkPath.lineWidth = 100
checkmarkPath.lineCapStyle = .round
checkmarkPath.lineJoinStyle = .round
NSColor.white.setStroke()
checkmarkPath.stroke()

image.unlockFocus()

// Save as PNG
let outputPath = "CheckMeIn/Assets.xcassets/AppIcon.appiconset/AppIcon.png"
if let tiffData = image.tiffRepresentation,
   let bitmap = NSBitmapImageRep(data: tiffData),
   let pngData = bitmap.representation(using: .png, properties: [:]) {
    try! pngData.write(to: URL(fileURLWithPath: outputPath))
    print("Icon saved to \(outputPath)")
} else {
    print("Failed to generate icon")
    exit(1)
}
