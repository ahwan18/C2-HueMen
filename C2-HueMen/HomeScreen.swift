//
//  HomeScreen.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 08/05/25.
//

import SwiftUI

struct HomeScreen: View {
    @State private var navigateToColorCloset = false
    @State private var showUploadOptions = false
    @State private var selectedUploadType: UploadType?
    @State private var navigateToColorSegmented = false
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("What color are you planning to wear today?")
                    .foregroundStyle(.black)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Text("We’ll help you find the best mix and match based on your colors")
                    .font(.callout)
                    .foregroundColor(Color.description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 1)
                
                Spacer().frame(height: 60)
                
                Button(action: {
                    withAnimation {
                        showUploadOptions = true
                    }
                }) {
                    Text("Take a photo")
                        .foregroundColor(.white)
                        .frame(maxWidth: 198, maxHeight: 10)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 4, y: 2)
                }
                .padding(.horizontal, 40)
                
                .confirmationDialog("", isPresented: $showUploadOptions, titleVisibility: .hidden) {
                    Button {
                        selectedUploadType = .top
                    } label: {
                        Label("Upload Top", systemImage: "tshirt")
                    }
                    .navigationDestination(for: UploadType.self) { type in
                        CameraColorDetectorView(uploadType: type)
                    }
                    
                    Button {
                        selectedUploadType = .bottom
                    } label: {
                        Label("Upload Bottom", systemImage: "figure.walk")
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                .navigationDestination(item: $selectedUploadType) { type in
                    CameraColorDetectorView(uploadType: type)
                }
                
                
                Text("or")
                    .padding(.vertical, 5)
                    .foregroundStyle(.black)
                
                Button(action: {
                    navigateToColorSegmented = true
                }) {
                    Text("Pick from wardrobe")
                        .foregroundColor(.white)
                        .frame(maxWidth: 198, maxHeight: 10)
                        .padding()
                        .background(.description)
                        .cornerRadius(10)
                        .shadow(radius: 4, y: 2)
                }
                .padding(.horizontal, 40)
                .navigationDestination(isPresented: $navigateToColorSegmented) {
                    ColorClosetSegmentedView()
                    }
                
                Spacer()
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                navigateToColorCloset = true
            }) {
                Image(systemName: "cabinet.fill")
                    .foregroundStyle(.black)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            )
            .navigationDestination(isPresented: $navigateToColorCloset) {
                ColorClosetView()
                }
            
            .background(
                ZStack {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.decorationShape)
                                .frame(width: 200, height: 300)
                                .rotationEffect(.degrees(40))
                                .offset(x: -180, y: 50)
                            
                            Circle()
                                .fill(Color.decorationShape)
                                .frame(width: 190, height: 350)
                                .offset(x: -120, y: 80)
                        }
                        
                        Spacer()
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color.decorationShape)
                                .frame(width: 200, height: 300)
                                .rotationEffect(.degrees(-40))
                                .offset(x: 220, y: 300)
                            
                            Circle()
                                .fill(Color.decorationShape)
                                .frame(width: 260, height: 300)
                                .offset(x: 190, y: 170)
                        }
                        
                    }
                }
            )
            .ignoresSafeArea()
            .background(
                Color(.white)
            )
        }
        .navigationBarBackButtonHidden()
        
    }
    
}


#Preview {
    HomeScreen()
}
