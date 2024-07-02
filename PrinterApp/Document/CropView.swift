//
//  CropView.swift
//  PrinterApp
//
//  Created by IVANKIS on 01.07.2024.
//

import SwiftUI

struct CropView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var croppingRect = CGRect.zero
    @State private var startPoint: CGPoint?
    let image: UIImage
    var didCropImage: (UIImage) -> Void
    var onRetake: () -> Void

    var body: some View {
        VStack {
            GeometryReader { geometry in
                ZStack {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .gesture(DragGesture()
                            .onChanged { value in
                                if startPoint == nil {
                                    startPoint = value.location
                                }
                                let rect = CGRect(x: startPoint!.x,
                                                  y: startPoint!.y,
                                                  width: value.location.x - startPoint!.x,
                                                  height: value.location.y - startPoint!.y)
                                croppingRect = rect
                            }
                            .onEnded { value in
                                startPoint = nil
                            }
                        )
                        .overlay(
                            Rectangle()
                                .path(in: croppingRect)
                                .stroke(Color.blue, lineWidth: 2)
                        )
                }
            }
            .padding()

            HStack {
                Button("Retake") {
                    presentationMode.wrappedValue.dismiss()
                    onRetake()
                }
                Spacer()
                Button("Keep Scan") {
                    if let croppedImage = cropImage(image: image, toRect: croppingRect) {
                        didCropImage(croppedImage)
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
            .padding()
        }
    }

    private func cropImage(image: UIImage, toRect rect: CGRect) -> UIImage? {
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale,
                                y: rect.origin.y * scale,
                                width: rect.size.width * scale,
                                height: rect.size.height * scale)

        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else {
            return nil
        }

        return UIImage(cgImage: cgImage, scale: image.scale, orientation: image.imageOrientation)
    }
}
