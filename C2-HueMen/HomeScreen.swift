//
//  HomeScreen.swift
//  C2-HueMen
//
//  Created by Rifki Hidayatullah on 08/05/25.
//

import SwiftUI

struct HomeScreen: View {
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
                
                Text("We'll help you find the best mix and match based on your colors")
                    .font(.callout)
                    .foregroundColor(Color.description)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                    .padding(.top, 1)
                
                Spacer().frame(height: 60)
                
                Button(action: {
                    showUploadOptions = true
                }) {
                    Text("Take a photo")
                        .foregroundColor(.white)
                        .frame(maxWidth: 198, maxHeight: 15)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 4, y: 2)
                }
                .confirmationDialog("", isPresented: $showUploadOptions, titleVisibility: .hidden) {
                    Button("Upload Top") {
                        selectedUploadType = .top
                    }
                    Button("Upload Bottom") {
                        selectedUploadType = .bottom
                    }
                    Button("Cancel", role: .cancel) {}
                }
                
                // Always-rendered NavigationLinks
                NavigationLink(
                    destination: CameraColorDetectorView(uploadType: .top),
                    tag: UploadType.top,
                    selection: $selectedUploadType
                ) {
                    EmptyView()
                }

                NavigationLink(
                    destination: CameraColorDetectorView(uploadType: .bottom),
                    tag: UploadType.bottom,
                    selection: $selectedUploadType
                ) {
                    EmptyView()
                }

                Text("or")
                    .padding(.vertical, 5)
                    .foregroundStyle(.black)
                
                NavigationLink(destination: ColorClosetSegmentedView(), isActive: $navigateToColorSegmented) {
                    Text("Pick from wardrobe")
                        .foregroundColor(.white)
                        .frame(maxWidth: 198, maxHeight: 15)
                        .padding()
                        .background(Color.description)
                        .cornerRadius(10)
                        .shadow(radius: 4, y: 2)
                }
                .padding(.horizontal, 40)
                
                Spacer()
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
            .background(Color.white)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeScreen()
}
