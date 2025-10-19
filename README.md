# erp_solution
A modern Flutter-based ERP application built to streamline internal business operations — including **Dashboard, Notifications, Attendance**, and **HR Management**.  
Designed for internal company use with secure API communication and modular architecture.

ERP Solution is a Flutter-based internal business application developed to centralize and streamline day-to-day company operations.
It provides employees and administrators with a single, efficient platform to manage attendance, monitor HR activities, receive real-time notifications, and view key business insights through an interactive dashboard.
The app ensures secure API communication, a modular MVVM architecture, and smooth state management using Provider — making it scalable, maintainable, and optimized for enterprise environments.
Its goal is to improve organizational transparency, minimize manual processes, and create a connected digital workspace for all internal departments.

---

## 🧩 Features
- **Dashboard** – Quick overview of employee activities, KPIs, and system stats.  
- **Notifications** – Real-time push and in-app updates using REST API integration.  
- **Attendance** – Daily attendance tracking and summary views.  
- **HR Module** – Employee profiles, leave requests, and performance tracking. 

---

## ⚙️ Tech Stack

| Layer | Technology |
|-------|-------------|
| Frontend | Flutter (Dart) |
| State Management | Provider |
| Networking | Dio (REST API) |
| Architecture | MVVM pattern |
| Backend | Private REST API (secured endpoints) |

---

## 🏗️ Project Structure

lib/
├── core/
│ ├── constants/ # App-wide constants and configuration
│ ├── utils/ # Common helpers and extensions
│ └── services/ # Networking, API clients, and shared logic
│ └── http_helper.dart
├── models/ # Data models and response structures
├── providers/ # State management using Provider
├── screens/
│ ├── dashboard/ # Dashboard UI and logic
│ ├── notifications/ # Notification list and detail views
│ ├── attendance/ # Attendance tracking and summary
│ └── hr/ # HR module (employee profiles, leave, etc.)
├── widgets/ # Shared UI components
└── main.dart # App entry point

---


🚀 Getting Started

Prerequisites
Flutter SDK 3.0+
Android Studio or VS Code
Company API access (authentication token required)


Installation

git clone https://github.com/your-org/erp_solution.git
cd erp_solution
flutter pub get
flutter run

---


🧠 Development Guidelines
Follow MVVM architecture for clear separation of logic, data, and presentation.
Use Provider for dependency injection and reactive UI updates.
Centralize network calls and handle all API responses gracefully.
Maintain consistent ThemeData for branding and light/dark modes.
Keep modules independent for easier scalability.

