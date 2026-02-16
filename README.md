# LocalQuest
LocalQuest - An application that makes your local area fun :)

---
## Introduction

this application is a Flutter proof-of-concept app demonstrating:

* Interactive map using `flutter_map`
* OSRM walking route generation
* Displaying "Quests" and "Friends"
* Animated UI components

## Requirements

* Flutter (latest stable)
* VSCode, Android Studio or Xcode
* Android emulator, iOS simulator, or physical device

---

## 1. Install Flutter

Download and install Flutter:

[https://docs.flutter.dev/get-started/install](https://docs.flutter.dev/get-started/install)

After installation, verify:

```bash
flutter doctor
```

Resolve any issues shown.

---

## 2. Clone the Project

```bash
git clone https://github.com/aditiya-dhar/LocalQuest.git
cd LocalQuest/localquest
```

---

## 3. Install Dependencies

```bash
flutter pub get
```

---

## 4. Run the App

Make sure a device or emulator is running, then execute:

```bash
flutter run
```

---

## Notes

* The app uses OpenStreetMap tiles.
* Routing is powered by the public OSRM demo server.
* Location permissions must be enabled on the device.

---