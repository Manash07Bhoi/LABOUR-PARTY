class Settings {
  final bool isDarkMode;
  final String language;

  Settings({
    this.isDarkMode = false,
    this.language = 'en',
  });

  Settings copyWith({
    bool? isDarkMode,
    String? language,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      language: language ?? this.language,
    );
  }
}
