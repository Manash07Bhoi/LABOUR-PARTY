# Architecture

This project strictly follows Clean Architecture principles, divided into three main layers:

## 1. Domain Layer
- **Purity:** The core of the application. Contains business logic.
- **Rules:** Must NOT contain any `package:flutter` or `package:hive` imports.
- **Components:** Entities, Abstract Repositories, Use Cases.

## 2. Data Layer
- **Responsibility:** Handles all data operations and local storage.
- **Components:** Data Sources (Hive Box implementations), Models (with Hive type adapters), and Repository Implementations.
- **Hive Boxes:**
  - `works`: Stores `WorkModel` data.
  - `labours`: Stores `LabourModel` data.
  - `drivers`: Stores `DriverModel` data.
  - `tractors`: Stores `TractorModel` data.
  - `places`: Stores `PlaceModel` data.
  - `settings`: Stores `SettingsModel` data.
- **Rules:** Data retrieved is converted to Domain Entities before being passed to the Domain layer.

## 3. Presentation Layer
- **Responsibility:** UI and State Management.
- **Components:** Screens, Widgets, and BLoC (Events, States, Blocs).
- **Rules:** BLoCs depend on Use Cases from the Domain layer. Every screen's `BlocBuilder` must explicitly handle four states:
  1. Loading
  2. Empty
  3. Error
  4. Data

## Global Constraints
- **Offline Fonts:** Google Fonts runtime fetching is disabled globally (`GoogleFonts.config.allowRuntimeFetching = false`).
- **Computed Fields:** Computed properties (like totals) are not persisted; they are calculated dynamically.
