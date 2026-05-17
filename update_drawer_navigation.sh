sed -i 's#_buildDrawerItem(Icons.people_outline, '"'"'Labours'"'"', () {}),#_buildDrawerItem(Icons.people_outline, '"'"'Labours'"'"', () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const LabourScreen())); }),#g' lib/presentation/screens/shell/main_shell_screen.dart
sed -i 's#_buildDrawerItem(Icons.local_shipping_outlined, '"'"'Drivers'"'"', () {}),#_buildDrawerItem(Icons.local_shipping_outlined, '"'"'Drivers'"'"', () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const DriverScreen())); }),#g' lib/presentation/screens/shell/main_shell_screen.dart
sed -i 's#_buildDrawerItem(Icons.agriculture_outlined, '"'"'Tractors'"'"', () {}),#_buildDrawerItem(Icons.agriculture_outlined, '"'"'Tractors'"'"', () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TractorScreen())); }),#g' lib/presentation/screens/shell/main_shell_screen.dart
sed -i 's#_buildDrawerItem(Icons.place_outlined, '"'"'Places'"'"', () {}),#_buildDrawerItem(Icons.place_outlined, '"'"'Places'"'"', () { Navigator.of(context).push(MaterialPageRoute(builder: (_) => const PlaceScreen())); }),#g' lib/presentation/screens/shell/main_shell_screen.dart

sed -i '1i import '"'../management/labour_screen.dart'"';\n' lib/presentation/screens/shell/main_shell_screen.dart
sed -i '1i import '"'../management/driver_screen.dart'"';\n' lib/presentation/screens/shell/main_shell_screen.dart
sed -i '1i import '"'../management/tractor_screen.dart'"';\n' lib/presentation/screens/shell/main_shell_screen.dart
sed -i '1i import '"'../management/place_screen.dart'"';\n' lib/presentation/screens/shell/main_shell_screen.dart
