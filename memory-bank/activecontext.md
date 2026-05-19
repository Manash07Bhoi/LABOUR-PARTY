# Active Context

**Current Task:** Setup core project documentation and replace the main launcher icon.

**Recent Actions:**
1. Downloaded the provided `ic_launcher.png` asset.
2. Utilized `imagemagick` to crop the image to a square and resize it.
3. Deployed the resized image across the 5 Android `mipmap` resource directories (mdpi, hdpi, xhdpi, xxhdpi, xxxhdpi), overwriting the existing `ic_launcher.png`.
4. Refactored the `README.md` to reflect the technical stack, project guidelines, and personal-use-only constraints.
5. Bootstrapped the `/memory-bank/` directory with 7 core context files.

**Immediate Next Steps:**
- Complete the creation of the memory-bank documentation.
- Commit all changes to the repository.
- Ensure no further intermediate approval is requested during this execution phase, adhering to the user's latest instruction.

**Key Focus Areas for Upcoming Code Changes:**
- Double-check layer purity when modifying Dart files.
- Ensure any new UI/BLoC implementations strictly map the 4 distinct states (Loading, Empty, Error, Data).
