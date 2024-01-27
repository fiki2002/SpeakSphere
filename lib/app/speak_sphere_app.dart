import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speak_sphere/features/features.dart';

class SpeakSphereApp extends StatelessWidget {
  const SpeakSphereApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SelectionNotifier(),
        ),
          ChangeNotifierProvider(
          create: (_) => NavBarNotifier(),
        ),
      ],
      child: const MaterialApp(
        title: 'Speak Sphere',
        debugShowCheckedModeBanner: false,
        home: SplashView(),
      ),
    );
  }
}
