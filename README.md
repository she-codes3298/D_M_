# Disaster Management App: Centralized Communication and Response System

## Overview
The **Disaster Management App** is a Flutter-based solution designed to enhance disaster response and resource management. The app features a **dual-interface system**:

1. **User Interface (Civilians/Refugees)** – Provides emergency alerts, navigation to safe zones, medical record access, virtual training, and donation options.
2. **Government Interface (Central, State, Inventory Management)** – Manages disaster alerts, refugee centers, inventory tracking, and communication.

The system integrates **LoRa (Long Range) for critical low-bandwidth communication** and **Internet/Cellular networks for high-bandwidth tasks**, ensuring seamless communication even in disaster-hit areas.

---

## Features

### 1. User Interface (Civilians/Refugees)
- **SOS Emergency Alert** – Sends distress signals with real-time location.
- **Map Navigation to Safe Spots** – Guides users to nearby shelters.
- **AI Chatbot** – Answers disaster-related queries.
- **ABHA Integration** – Fetches medical records via QR code.
- **Virtual Training Module** – Provides disaster preparedness training.
- **Live Alert Section** – Displays real-time government alerts.
- **Donation Portal** – Facilitates contributions to disaster relief funds.

### 2. Government Interface
- **Automated Disaster Detection & Alerts**
  - Uses AI to analyze web-scraped data from official sources.
  - Central Government sends real-time alerts based on disaster thresholds.
  - Fallback Mechanism: NDRF/rescue teams are notified if state organizations are unresponsive.
- **Refugee Center Management** – Updates locations of available shelters.
- **Neutral Community Section** – Enables official announcements and public engagement.
- **Inventory Management** – Tracks and distributes emergency supplies.

### 3. Wearable Device for Rescue Teams
- **Team Coordination & GPS Tracking** – Real-time location updates for rescue teams.
- **SOS Button** – Rescue personnel can send distress alerts.
- **Vital Monitoring** – Tracks heart rate, temperature, and oxygen levels.
- **Environmental Sensors** – Detects hazardous conditions (gas leaks, extreme temperatures).

### 4. Hybrid Communication Approach
- **LoRa (Long Range) for critical alerts, SOS, and basic navigation.**
- **Internet/Cellular networks for detailed maps, real-time updates, and community interactions.**

---

## Key Highlights
✅ **Dual-Interface Design** – For both civilians and government agencies.  
✅ **AI-Powered Disaster Detection** – Uses Gemini AI for proactive alerts.  
✅ **Hybrid Communication Model** – Ensures reliability in disaster scenarios.  
✅ **ABHA Medical Integration** – Quick access to health records in emergencies.  
✅ **Wearable Tech for Rescue Teams** – Enhances safety and coordination.  
✅ **Community Engagement** – Fosters communication between civilians and officials.  
✅ **Pre-Deployed LoRa Gateways** – Ensures connectivity in disaster-prone areas.  

---

## Installation & Setup

### Requirements:
- Flutter SDK
- Dart
- Firebase (for authentication & cloud messaging)
- LoRa gateway setup for offline communication (optional but recommended)
- API access to IMD, NDMA, and ABHA services

### Steps to Install:
1. Clone the repository:
   ```bash
   git clone https://github.com/your-repo/disaster-management-app.git
   ```
2. Navigate to the project directory:
   ```bash
   cd disaster-management-app
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app:
   ```bash
   flutter run
   ```

---

## Contributing
We welcome contributions! Follow these steps:
1. Fork the repository.
2. Create a new branch: `git checkout -b feature-name`
3. Commit changes: `git commit -m "Add new feature"`
4. Push to the branch: `git push origin feature-name`
5. Open a pull request.

---


