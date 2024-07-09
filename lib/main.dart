import 'package:anonymy/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:anonymy/screens/loading.dart';
import 'package:anonymy/screens/onboarding/onboarding.view.dart'; // Adjust import based on your file structure

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool onboardingCompleted = prefs.getBool('onboarding') ?? false;
  prefs.clear();
  final token = getToken();
  runApp(App(
    onboarding: onboardingCompleted,
  ));
}

class App extends StatelessWidget {
  final bool onboarding;

  const App({Key? key, required this.onboarding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Define the default font family
        fontFamily: GoogleFonts.libreBaskerville().fontFamily,
      ),
      home: onboarding ? Loading() : OnBoarding(),
    );
  }
}
