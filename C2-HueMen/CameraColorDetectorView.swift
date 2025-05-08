import SwiftUI
import AVFoundation

struct CameraColorDetectorView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CameraViewModel()
    @State private var showColorSuggestion = false
    @State private var capturedColor: Color?
    @State private var isCapturing = false
    var uploadType: UploadType
    
    var body: some View {
        ZStack {
            CameraPreview(session: viewModel.session)
                .ignoresSafeArea()
            
            // Kotak deteksi di tengah layar
            //            Rectangle()
            //                .stroke(Color.white, lineWidth: 2)
            //                .frame(width: 10, height: 10)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .font(.system(size: 18, weight: .medium))
                    }
                    Spacer()
                    Text("Capture Cloth Color")
                        .foregroundColor(.white)
                        .font(.headline)
                    Spacer()
                    Spacer().frame(width: 24) // for symmetry
                }
                .padding()
                .background(Color.black)
                
                Spacer()
                
                Rectangle()
                    .stroke(Color.white, lineWidth: 2)
                    .frame(width: 10, height: 10)
                
                Spacer()
                
                VStack(spacing: 4) {
                    Label("Ensure good lighting", systemImage: "lightbulb")
                    Label("Point camera at the cloth color", systemImage: "scope")
                }
                .font(.footnote)
                .foregroundColor(.white.opacity(0.7))
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
                .padding(.bottom, 12)
                .fontWeight(.bold)
                .preferredColorScheme(.dark)
                
                if let label = viewModel.detectedColorLabel {
                    Text(label)
                        .font(.title2.bold())
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 16)
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding(.bottom, 8)
                }
                
                VStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                            isCapturing = true
                        }

                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            isCapturing = false
                        }

                        if let color = viewModel.detectedColor {
                            capturedColor = Color(
                                red: Double(color.r) / 255.0,
                                green: Double(color.g) / 255.0,
                                blue: Double(color.b) / 255.0
                            )
                            showColorSuggestion = true
                        }
                    }) {
                        ZStack {
                            Circle()
                                .stroke(Color.white, lineWidth: 5)
                                .frame(width: 70, height: 70)
                            Circle()
                                .fill(Color.white)
                                .frame(width: isCapturing ? 50 : 60, height: isCapturing ? 50 : 60)
                                .scaleEffect(isCapturing ? 0.85 : 1.0)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .animation(.easeInOut(duration: 0.2), value: isCapturing)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.black)
            }
            .navigationBarBackButtonHidden(true)
        }
        .onAppear {
            viewModel.configure()
        }
        .fullScreenCover(isPresented: $showColorSuggestion) {
            if let color = capturedColor {
                RecommendationView(selectedColor: color, uploadType: uploadType, path: .constant(NavigationPath()))
            }
        }
    }
}

// Agar UIImage bisa digunakan sebagai Identifiable untuk .fullScreenCover
//extension UIImage: Identifiable {
//    public var id: String { self.pngData()?.base64EncodedString() ?? UUID().uuidString }
//}

// RGB feedback
//            VStack {
//                Spacer()
//                if let color = viewModel.detectedColor {
//                    Text("R: \(color.r) G: \(color.g) B: \(color.b)")
//                        .padding()
//                        .background(Color.black.opacity(0.5))
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                }
//                if let label = viewModel.detectedColorLabel {
//                    Text("\(label)")
//                        .padding(6)
//                        .background(Color.black.opacity(0.5))
//                        .cornerRadius(8)
//                        .foregroundColor(.white)
//                }
//                Button(action: {
//                    viewModel.isFlashOn.toggle()
//                    viewModel.toggleFlash(on: viewModel.isFlashOn)
//                }) {
//                    Image(systemName: viewModel.isFlashOn ? "flashlight.on.fill" : "flashlight.off.fill")
//                        .font(.system(size: 24))
//                        .foregroundColor(.white)
//                        .padding()
//                        .background(Color.black.opacity(0.6))
//                        .clipShape(Circle())
//                }
//                .padding()
//                .position(x: UIScreen.main.bounds.width - 50, y: 60)

// Tombol Capture
//                Button(action: {
//                    viewModel.capturePhoto()
//                }) {
//                    Image(systemName: "camera.circle.fill")
//                        .resizable()
//                        .frame(width: 64, height: 64)
//                        .foregroundColor(.white)
//                        .background(Color.black.opacity(0.4))
//                        .clipShape(Circle())
//                        .padding(.top, 16)
//                }
//}
