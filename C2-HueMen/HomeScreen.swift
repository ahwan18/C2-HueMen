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
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("What color are you planning to wear today?")
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
                    showUploadOptions = true
                }) {
                    Text("Upload")
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, maxHeight: 10)
                        .padding()
                        .background(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 4, y: 2)
                }
                .padding(.horizontal, 40)
                .confirmationDialog("", isPresented: $showUploadOptions, titleVisibility: .hidden) {
                    Button {
                        // Action utk Upload Top
                    } label: {
                        Label("Upload Top", systemImage: "tshirt")
                    }
                    
                    Button {
                        // Action utk Upload Bottom
                    } label: {
                        Label("Upload Bottom", systemImage: "figure.walk")
                    }
                    
                    Button("Cancel", role: .cancel) {}
                }
                
                
                Button(action: {
                    navigateToColorCloset = true
                }) {
                    Text("Color Closet")
                        .underline()
                        .foregroundColor(.black)
                        .padding(.top, 16)
                }
                
                Spacer()
            }
            .navigationBarItems(trailing:
                                    Button(action: {
                navigateToColorCloset = true
            }) {
                Image(systemName: "hanger")
                    .foregroundStyle(.black)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }
            )
            .background(
                ZStack {
                    NavigationLink(
                        destination: ColorClosetView(),
                        isActive: $navigateToColorCloset
                    ) { EmptyView() }
                    Color.white
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
                
            )
        }
        
    }
    
}


#Preview {
    HomeScreen()
}
