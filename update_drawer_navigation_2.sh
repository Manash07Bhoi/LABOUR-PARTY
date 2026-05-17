sed -i 's#_buildDrawerItem(Icons.settings_outlined, '"'"'Settings'"'"', () {}),#_buildDrawerItem(Icons.settings_outlined, '"'"'Settings'"'"', () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SettingsScreen())); }),#g' lib/presentation/screens/shell/main_shell_screen.dart
sed -i 's#_buildDrawerItem(Icons.info_outline, '"'"'About'"'"', () {}),#_buildDrawerItem(Icons.info_outline, '"'"'About'"'"', () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AboutScreen())); }),#g' lib/presentation/screens/shell/main_shell_screen.dart
sed -i '1i import '"'../settings/settings_screen.dart'"';\n' lib/presentation/screens/shell/main_shell_screen.dart
sed -i '1i import '"'../settings/about_screen.dart'"';\n' lib/presentation/screens/shell/main_shell_screen.dart
