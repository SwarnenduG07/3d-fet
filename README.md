# GrowMe MVP – Complete Development Description

## 1. Project Overview

GrowMe is a 3D avatar-based fitness training application designed to help users maintain exercise habits in a fun and gamified way. Users earn experience points (XP) by exercising, and their avatar gradually evolves in body shape and level as they progress.

The MVP version focuses on validating the core concept, collecting user feedback, and building a stable technical foundation for future expansion.

Target users are men and women in their late teens to 30s, especially beginners in muscle training or bodyweight workouts who want a simple and motivating experience.

---

## 2. Technical Architecture

### 2.1 Mobile Application

- Framework: Flutter  
- Language: Dart  
- Platforms: iOS and Android  
- State Management: Riverpod or Bloc  
- Development Tools: Visual Studio Code or Android Studio  

The application must be structured with clean architecture principles, separating UI, business logic, and data layers to allow future feature expansion.

---

### 2.2 Backend Services (Firebase)

The application will use Firebase services for backend infrastructure:

- Firebase Authentication for user login and identity management  
- Firebase Firestore as the primary database  
- Firebase Cloud Messaging (FCM) for push notifications  
- Firebase Analytics for tracking user behavior  
- Firebase Cloud Storage for storing avatar or related assets if required  

All services must be properly configured for both Android and iOS environments.

---

### 2.3 3D Avatar System

The avatar system will use:

- Ready Player Me for avatar generation and management  
- GLB format for 3D model rendering  
- model_viewer_plus or flutter_cube for in-app 3D viewing  

The avatar must:
- Display full body
- Support idle animation
- Reflect body stage changes visually
- Be viewable in both Home and Mirror screens

Performance optimization is required to ensure smooth rendering on mid-range devices.

---

## 3. Core Functional Requirements

### 3.1 Initial Setup

When the app is launched for the first time, users must provide:

- Gender (male / female)
- Height (cm)
- Current weight (kg)
- Target weight (kg)
- Goal type (muscle gain / weight loss / maintenance)
- Target timeframe (e.g., 30 days)

This information must be stored in Firestore under the user document.

---

### 3.2 Home Screen

The Home screen must include:

- Full-body 3D avatar display
- Current XP
- Current level (Lv1–50)
- Current protein balance (in-game currency)
- "Start Exercise" button
- "Look in the Mirror" button

The UI must remain simple, clean, and fitness-oriented. No complex 3D environments are required.

---

### 3.3 Mirror Screen

The Mirror screen must:

- Display the avatar in underwear
- Reflect the current body stage
- Show a visual indicator (e.g., exclamation mark) when a body stage change occurs
- Trigger a simple celebratory animation when transformation happens

---

### 3.4 Exercise Tracking System

The exercise system must allow:

- Start Exercise: Record start timestamp
- End Exercise: Record end timestamp
- Calculate duration in minutes
- Automatically calculate rewards

Reward calculation:
- 1 minute = 10 XP
- 1 minute = 5 Protein

After completion:
- Update user XP
- Update total XP
- Update protein balance
- Store workout record in Firestore

---

### 3.5 Level System

Maximum level: 50

XP requirements per level:

- Levels 1–10: 500 × level
- Levels 11–20: 800 × level
- Levels 21–30: 1200 × level
- Levels 31–40: 2000 × level
- Levels 41–50: 3000 × level

The system must:

- Automatically calculate level progression
- Trigger level-up animation
- Send push notification on level-up
- Update Firestore data

---

### 3.6 Body Stage System

There are 5 body stages:

- Lv1–10: Stage 1 (Slim)
- Lv11–20: Stage 2 (Toned)
- Lv21–30: Stage 3 (Muscular)
- Lv31–40: Stage 4 (Athletic)
- Lv41–50: Stage 5 (Ideal Form)

When the level crosses into a new stage:
- Update bodyStage value
- Trigger visual update
- Record body_change event
- Display transformation animation

---

## 4. Database Structure (Firestore)

### users Collection

Each user document must include:

- gender (String)
- height (Number)
- weight (Number)
- targetWeight (Number)
- goalType (String)
- currentLevel (Number)
- currentXP (Number)
- totalXP (Number)
- protein (Number)
- bodyStage (Number)
- bodyChangeFlag (Boolean)
- createdAt (Timestamp)
- lastLoginAt (Timestamp)

---

### workouts Collection

Each workout record must include:

- userId (String)
- startTime (Timestamp)
- endTime (Timestamp)
- duration (Number)
- earnedXP (Number)
- earnedProtein (Number)
- createdAt (Timestamp)

---

## 5. Analytics Tracking

The following events must be tracked:

- user_login
- workout_start
- workout_end
- level_up
- body_change

Each event must include relevant parameters such as userId, timestamps, XP gained, and level reached.

---

## 6. Push Notifications

The system must:

- Send a notification immediately after level-up
- Allow users to toggle notifications ON/OFF
- Default notification setting: ON

Example notification:
"Congratulations! You've reached level {level}!"

---

## 7. UI/UX Requirements

Design must reflect:

- Clean and minimal layout
- Fitness and growth theme
- Game-like but intuitive interface

Color scheme:
- Primary: White (#FFFFFF)
- Secondary: Blue (#4A90E2)
- Accent: Green (#7ED321) or Orange (#FF9500)

Animations required:
- XP increment animation
- Level-up celebration effect
- Fade effect for body stage change

---

## 8. Excluded Features (Future Expansion)

The following features are not included in MVP:

- Ads integration
- Login bonus system
- Level expansion beyond 50
- Costume system
- Dialogue system
- Apple HealthKit / Google Fit integration
- Gacha system
- In-app purchases
- Community features
- Detailed nutrition analysis

---

## 9. Deliverables

Upon completion, the following will be delivered:

- Complete Flutter source code (GitHub repository)
- Firebase configuration files
- Basic design documentation
- Environment setup instructions
- Store submission materials (icons, screenshots)

After final payment, full copyright ownership transfers to the client.

A one-month warranty period is provided for bug fixes, including store rejection corrections.

---

End of GrowMe MVP Description
