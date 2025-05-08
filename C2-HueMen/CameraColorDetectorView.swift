import SwiftUI
import AVFoundation

struct CameraColorDetectorView: View {
    @StateObject private var viewModel = CameraViewModel()
    var uploadType: UploadType
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()

            // Kotak deteksi di tengah layar
            Rectangle()
                .stroke(Color.white, lineWidth: 2)
                .frame(width: 10, height: 10)

            // RGB feedback
            VStack {
                Spacer()
                if let color = viewModel.detectedColor {
                    Text("R: \(color.r) G: \(color.g) B: \(color.b)")
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                if let label = viewModel.detectedColorLabel {
                    Text("\(label)")
                        .padding(6)
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(8)
                        .foregroundColor(.white)
                }
                Button(action: {
                    viewModel.isFlashOn.toggle()
                    viewModel.toggleFlash(on: viewModel.isFlashOn)
                }) {
                    Image(systemName: viewModel.isFlashOn ? "flashlight.on.fill" : "flashlight.off.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.6))
                        .clipShape(Circle())
                }
                .padding()
                .position(x: UIScreen.main.bounds.width - 50, y: 60)
                
                // Tombol Capture
                Button(action: {
                    viewModel.capturePhoto()
                }) {
                    Image(systemName: "camera.circle.fill")
                        .resizable()
                        .frame(width: 64, height: 64)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.4))
                        .clipShape(Circle())
                        .padding(.top, 16)
                }
            }
        }
        .onAppear {
            viewModel.configure()
        }
        // Navigasi ke screen baru jika ada hasil capture
//        .fullScreenCover(item: $viewModel.capturedImage) { image in
//            CapturedImageView(image: image) {
//                viewModel.capturedImage = nil
//            }
//        }
    }
}

// Agar UIImage bisa digunakan sebagai Identifiable untuk .fullScreenCover
//extension UIImage: Identifiable {
//    public var id: String { self.pngData()?.base64EncodedString() ?? UUID().uuidString }
//}
