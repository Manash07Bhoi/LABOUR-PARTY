class Settings {
  final bool isDarkMode;
  final bool animationsEnabled;
  final String currencySymbol;
  final String dateFormat;
  final String? userName;

  Settings({
    this.isDarkMode = true,
    this.animationsEnabled = true,
    this.currencySymbol = '₹',
    this.dateFormat = 'dd/MM/yyyy',
    this.userName,
  });

  Settings copyWith({
    bool? isDarkMode,
    bool? animationsEnabled,
    String? currencySymbol,
    String? dateFormat,
    String? userName,
  }) {
    return Settings(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      dateFormat: dateFormat ?? this.dateFormat,
      userName: userName ?? this.userName,
    );
  }
}
