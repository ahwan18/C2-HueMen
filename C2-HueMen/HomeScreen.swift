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
    @State private var showActionSheet = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()
                
                VStack {
                    Spacer()
                    
                    Text("What color are you planning to wear today?")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                    
                    Text("We’ll help you find the best mix and match based on your colors")
                        .font(.callout)
                        .foregroundStyle(Color.description)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 40)
                        .padding(.top, 1)
                    
                    Spacer().frame(height: 60)
                    Spacer().frame(height: 60)
                    
                    Button(action: {
                        withAnimation {
                            showActionSheet = true
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
                    
                    Text("or")
                        .padding(.vertical, 5)
                        .foregroundStyle(.black)
                    
                    Button(action: {
                        navigateToColorCloset = true
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
                if showActionSheet {
                    ZStack {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                showActionSheet = false
                            }
                        
                        VStack(spacing: 8) {
                            VStack(spacing: 0) {
                                Button {
                                    selectedUploadType = .top
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showActionSheet = false
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "tshirt")
                                            .foregroundColor(.blue)
                                        Text("Upload Top")
                                            .foregroundColor(.blue)
                                        Spacer()
                                    }
                                    .padding()
                                }
                                .navigationDestination(for: UploadType.self) { type in
                                    CameraColorDetectorView(uploadType: type)
                                }
                                
                                Divider()
                                Button {
                                    selectedUploadType = .bottom
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                            showActionSheet = false
                                    }
                                } label: {
                                    HStack {
                                        Image("bottom")
                                            .resizable()
                                            .frame(width: 30, height: 32)
                                        Text("Upload Bottom")
                                            .foregroundColor(.blue)
                                        Spacer()
                                    }
                                    .padding()
                                }
                                .navigationDestination(item: $selectedUploadType) { type in
                                    CameraColorDetectorView(uploadType: type)
                                }
                            }
                            .background(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                            
                            Button(role: .cancel) {
                                showActionSheet = false
                            } label: {
                                Text("Cancel")
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(.white)
                                    .cornerRadius(12)
                                    .foregroundColor(.red)
                                    .padding(.horizontal)
                            }
                        }
                        .padding(.bottom, 20)
                        .frame(maxHeight: .infinity, alignment: .bottom)
                    }
                    
                }
            }
        }
    }
}


#Preview {
    HomeScreen()
}
