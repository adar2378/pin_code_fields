import 'package:material_ui/material_ui.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Define separate light and dark PIN themes
    const lightPinTheme = MaterialPinTheme(
      shape: MaterialPinShape.outlined,
      cellSize: Size(56, 64),
      spacing: 12,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderWidth: 1.5,
      focusedBorderWidth: 2.5,
      borderColor: Colors.grey,
      focusedBorderColor: Colors.indigo,
    );

    const darkPinTheme = MaterialPinTheme(
      shape: MaterialPinShape.outlined,
      cellSize: Size(56, 64),
      spacing: 12,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderWidth: 1.5,
      focusedBorderWidth: 2.5,
      borderColor: Colors.grey,
      focusedBorderColor: Colors.indigoAccent,
    );

    return MaterialApp(
      title: 'Pin Code Fields',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Register the MaterialPinThemeExtension in the theme
        extensions: const [
          MaterialPinThemeExtension(theme: lightPinTheme),
        ],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        // Register the MaterialPinThemeExtension in the dark theme
        extensions: const [
          MaterialPinThemeExtension(theme: darkPinTheme),
        ],
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}
