# Project Brief

**Project Name:** Labour Party
**Platform:** Android (Flutter)
**Core Purpose:** A professional, fully offline labour and work management tool for personal use.

## Core Directives

1. **Offline Only:** The app must be fully functional without an internet connection. Data privacy and constant availability are paramount. All fonts and assets must be bundled locally.
2. **Clean Architecture:** Strict adherence to Data, Domain, and Presentation layers. The Domain layer must be pure (no Flutter or Hive imports).
3. **Robust State Management:** The UI must handle all four BLoC states explicitly: Loading, Empty, Error, and Data.
4. **Data Handling:** Do not store computed fields or aggregates (e.g., total amounts) in the local database. Always compute them dynamically at runtime.
5. **No Cosmetic Polish Over Function:** Prioritize correctness of data flow, state handling, and architectural purity over UI animations or visual polish.

## Key Features
- Track labour attendance and work entries.
- Maintain accurate financial records (ledgers, advances, payments).
- Rapid, lightweight offline storage using Hive.
