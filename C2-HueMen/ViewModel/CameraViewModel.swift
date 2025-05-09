import AVFoundation
import UIKit

class CameraViewModel: NSObject, ObservableObject, AVCaptureVideoDataOutputSampleBufferDelegate {
    @Published var detectedColor: (r: Int, g: Int, b: Int)?
    @Published var detectedColorLabel: String?
    @Published var isFlashOn: Bool = false
    @Published var capturedImage: UIImage? = nil
    private var isCapturing = false
    let session = AVCaptureSession()
    
    private let output = AVCaptureVideoDataOutput()
    private let queue = DispatchQueue(label: "CameraQueue")
    private var lastUpdate = Date()
    
    func configure() {
        session.beginConfiguration()
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input),
              session.canAddOutput(output) else {
            return
        }
        
        session.addInput(input)
        output.setSampleBufferDelegate(self, queue: queue)
        session.addOutput(output)
        session.commitConfiguration()
        
        DispatchQueue.global(qos: .userInitiated).async {
            self.session.startRunning()
        }
        
    }
    
    func labelColor(from hue: CGFloat, saturation: CGFloat, brightness: CGFloat) -> String {
        // Grayscale check
            if saturation < 0.15 {
                if brightness < 0.2 {
                    return "Black"
                } else if brightness > 0.85 {
                    return "White"
                } else if brightness < 0.3 {
                    return "Dark Gray"
                } else if brightness > 0.7 {
                    return "Light Gray"
                } else {
                    return "Gray"
                }
            }

            // Browns and Beiges
            if hue >= 15 && hue <= 45 {
                if saturation > 0.3 && brightness < 0.4 {
                    return "Dark Brown"
                } else if saturation > 0.25 && brightness < 0.6 {
                    return "Brown"
                } else if saturation < 0.3 && brightness > 0.7 {
                    return "Beige"
                }
            }

            // RED variants
            if (hue >= 345 || hue < 15) {
                if brightness < 0.3 {
                    return "Dark Red"
                } else if brightness > 0.7 && saturation < 0.6 {
                    return "Pink"
                } else {
                    return "Red"
                }
            }

            // Coral
            if hue >= 15 && hue < 30 {
                if brightness > 0.7 {
                    return "Coral"
                }
            }

            if hue >= 30 && hue < 45 {
                return "Orange"
            }

            // Yellow
            if hue >= 45 && hue < 60 {
                return "Yellow"
            }

            // Lime & Chartreuse
            if hue >= 60 && hue < 75 {
                if brightness > 0.7 {
                    return "Lime"
                } else {
                    return "Chartreuse"
                }
            }

            // Chartreuse green zone
            if hue >= 75 && hue < 90 {
                return "Chartreuse"
            }

            // Greens
            if hue >= 90 && hue < 150 {
                if brightness < 0.5 && saturation > 0.4 {
                    return "Dark Green"
                } else {
                    return "Green"
                }
            }

            // Olive (green + yellow + dark)
            if hue >= 60 && hue <= 90 && brightness < 0.6 && saturation < 0.5 {
                return "Olive"
            }

            // Teal
            if hue >= 150 && hue < 180 {
                return "Teal"
            }

            // Cyan & Azure
            if hue >= 180 && hue < 210 {
                if brightness > 0.7 {
                    return "Cyan"
                } else {
                    return "Azure"
                }
            }

            // Blue variants
            if hue >= 210 && hue < 240 {
                if brightness < 0.3 {
                    return "Navy"
                } else {
                    return "Blue"
                }
            }

            // Indigo
            if hue >= 240 && hue < 270 {
                return "Indigo"
            }

            // Purple & Violet
            if hue >= 270 && hue < 300 {
                if brightness > 0.6 {
                    return "Violet"
                } else {
                    return "Purple"
                }
            }

            // Magenta
            if hue >= 300 && hue < 330 {
                return "Magenta"
            }

            // Fallback
            return "Unclassified"
    }
    
    func captureOutput(_ output: AVCaptureOutput,
                       didOutput sampleBuffer: CMSampleBuffer,
                       from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        // Update warna setiap 0.2 detik
        let now = Date()
        guard now.timeIntervalSince(lastUpdate) > 0.2 || isCapturing else { return }
        lastUpdate = now
        
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        let centerRect = CGRect(x: ciImage.extent.midX - 5, y: ciImage.extent.midY - 5, width: 10, height: 10)
        
        let cropped = ciImage.cropped(to: centerRect)
        if let cgImage = context.createCGImage(cropped, from: cropped.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            if let color = uiImage.averageColor {
                DispatchQueue.main.async {
                    self.detectedColor = (
                        Int(color.redValue * 255),
                        Int(color.greenValue * 255),
                        Int(color.blueValue * 255)
                    )
                    
                    let uiColor = UIColor(red: color.redValue, green: color.greenValue, blue: color.blueValue, alpha: 1)
                    if let hsb = uiColor.toHSB() {
                        let label = self.labelColor(from: hsb.hue, saturation: hsb.saturation, brightness: hsb.brightness)
                        self.detectedColorLabel = label
                        print("Detected Color Label: \(label)")
                        print(color)
                    }
                }
            }
            // Capture full frame jika diminta
            if isCapturing {
                let fullUIImage = UIImage(ciImage: ciImage)
                DispatchQueue.main.async {
                    self.capturedImage = fullUIImage
                    self.isCapturing = false
                }
            }
        }
    }
    
    func toggleFlash(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            device.torchMode = on ? .on : .off
            try device.setTorchModeOn(level: 1.0)
            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used: \(error)")
        }
    }
    
    func capturePhoto() {
        isCapturing = true
    }
}
