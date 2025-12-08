# Team-Bagel
CPT_S 484 Team Project - Theia Accessibility Assistant

## Project Overview
Theia is an accessibility assistant app designed to help visually impaired users navigate indoor spaces safely and independently. The app implements three core scenarios: navigation assistance, emergency detection, and voice-guided navigation.

## Implemented Features

### Core Scenarios (AS-IS to TO-BE)
1. **Real-Time Obstacle Detection** - Voice-activated navigation to locations with obstacle detection in place
2. **Emergency Assistance** - Automatic fall detection with emergency contact notification
3. **Voice Navigation** - Turn-by-turn voice guidance for indoor navigation

### Key Features
- Voice recognition for hands-free operation
- Text-to-speech for audio feedback
- Fall detection using device sensors
- Emergency contact system
- Blind-friendly interface design
- Settings configuration for personalization

## How to run Prototype:

1. Ensure you have Flutter SDK installed on your machine. If not, follow the installation guide at https://flutter.dev/docs/get-started/install.

2. Navigate to the theia directory:
   ```
   cd theia
   ```

3. Install the dependencies:
   ```
   flutter pub get
   ```

4. Run the app:
   ```
   flutter run
   ```
   I suggest running in a browser or a mobile emulator

## Using the App

### Initial Setup
1. Tap "TOOLS" button to configure:
   - Personal information (name, height, preferred units)
   - Emergency contact details
   - Voice settings (speed, language)

### Main Features
- **Green Microphone Button** - Tap to give voice commands like "Find nearest restroom" or "Navigate to classroom 205"
- **Red Stop Button** - Stop current operations or voice input
- **Demo Mode** - Access through Tools > "Demo All Scenarios" to see all three scenarios in action

### Voice Commands
- "Find nearest restroom" - Navigate to closest restroom
- "Navigate to [location]" - Get directions to specific places
- "Navigate to classroom [number]" - Find specific classrooms
- "Simulate fall" - Test emergency detection system

### Troubleshooting:

If you encounter startup problems, try running:
```
flutter clean
```
Then repeat steps 3 and 4.

### Collaborative work links:
Phase I:
- Meeting Records: https://docs.google.com/document/d/1y9gCFaHZys-RqAzONrJkoeT6k_kGpRrFH5g9OOTqEX4/edit?usp=sharing
- Mockups: https://docs.google.com/document/d/1gQ3-1TZ_W4CJULN0vPu3N-UuXa1LSEs0lul_IlzoNHI/edit?usp=sharing
- Phase I Plan: https://docs.google.com/document/d/1jnfFqopK0dEU_5J-1JOpOnjxFbfotYnb5kgKgvmhfRw/edit?usp=sharing
- Presentation Slides: https://docs.google.com/presentation/d/146cCqX_i2UMvBiJZF-1Dk1Y37j6wtTA-eeEx3DozYQg/edit?usp=sharing
- WRS: https://docs.google.com/document/d/1L9AKpQu2uBtrZr04H5oJIXo2P44MAEagR18glFRNz6s/edit?usp=sharing

Phase II:
- Final Project Plan: https://docs.google.com/document/d/1soKC13sNAtbXyWVl8O2LHPFBiQClmF5QbCUN5C4hgds/edit?usp=sharing
- Project Specification: https://docs.google.com/document/d/19AVVH9jyyldxsKYxMjoL2dTZ-F_L3amtxyDPG-yJBUk/edit?usp=sharing
- Vision & Scope Document: https://docs.google.com/document/d/1iWf1TrsNyEK-eO_KS6oVSJu1pnuzn4yD8wKR3fPYD-E/edit?usp=sharing
- New WRS: https://docs.google.com/document/d/1L9AKpQu2uBtrZr04H5oJIXo2P44MAEagR18glFRNz6s/edit?usp=sharing
