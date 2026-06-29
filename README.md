# HueMen

HueMen is an iOS wardrobe assistant that helps users organize outfits through camera-based color detection and a virtual closet experience.

## Problem

Choosing outfit colors can be confusing when users rely only on memory or manual color matching. HueMen helps users capture clothing colors from photos and organize wardrobe items more clearly.

## What I Built

- Camera-based color detection for clothing photos
- Virtual closet flow for organizing wardrobe items
- Photo-based color picking and clothing categorization
- Color-matching logic to support outfit decisions
- Onboarding flow for tops and bottoms setup
- User-tested navigation improvements based on TestFlight feedback

## App Flow

```text
Splash / Onboarding
-> Home
-> Camera Color Detector
-> Tops and Bottoms Setup
-> Color Closet
-> Color Suggestions
```

## Tech Stack

- Swift
- SwiftUI
- AVFoundation
- Core ML
- Xcode

## Project Structure

```text
C2-HueMen/
  CameraColorDetectorView.swift   Camera-based color detection UI
  CameraPreview.swift             Live camera preview integration
  ColorClosetView.swift           Virtual wardrobe interface
  ColorSuggestionView.swift       Outfit color suggestion screen
  ColorTheoryManager.swift        Color relationship and matching logic
  ViewModel/CameraViewModel.swift Camera state and detection logic
  Model/UploadModel.swift         Clothing item data model
```

## Role

Developer and researcher. I worked on the iOS implementation, product flow, camera/color interaction, and user feedback iteration.

## Result

Released on TestFlight with 33 installs and 117 sessions. Feedback was used to improve navigation and reduce duplicate color selection during wardrobe input.

## How to Run

1. Open `C2-HueMen.xcodeproj` in Xcode.
2. Select an iPhone simulator or physical iPhone target.
3. Build and run the app.
4. Use a physical device for the best camera-detection experience.

## Notes

This repository is a portfolio project from Apple Developer Academy work. The implementation focuses on validating the camera-based wardrobe interaction and the user flow around color selection.
