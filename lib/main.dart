import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'providers/user_provider.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider()..initialize(),
      child: const NetEtisalatApp(),
    ),
  );
}

class NetEtisalatApp extends StatelessWidget {
  const NetEtisalatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Net Etisalat',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: GoogleFonts.cairo().fontFamily,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00C853),
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF080B10),
      ),
      home: const HomeScreen(),
    );
  }
}
