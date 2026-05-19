# PRD Decisions & Deviations

1. **App Icon Implementation:**
   - **Original PRD Instruction:** Implement an Android Adaptive Icon with separate foreground and background layers alongside handling splash screens and specific notification icons.
   - **Decision/Deviation:** Per explicit user instruction, only Step 1 was executed, and it was done using a traditional flat `.png` replacement for `ic_launcher.png`. Adaptive XML configs and splash/about UI integration were intentionally skipped to focus solely on the primary launcher icon.

2. **Offline-First Enforcement:**
   - Decided to forcefully disable GoogleFonts runtime fetching (`GoogleFonts.config.allowRuntimeFetching = false`) rather than relying on chance, ensuring complete offline functionality.

3. **Data Storage Optimization:**
   - Aggregates and computed totals are intentionally excluded from Hive schemas. They are strictly calculated at runtime to prevent synchronization or stale data bugs.

4. **Architectural Purity vs Convenience:**
   - Prioritized strict isolation. Hive and Flutter dependencies are banished from the domain layer entirely, ensuring testability and longevity.
