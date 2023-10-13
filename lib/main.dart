import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:htt_proj/LoginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // obtain shared preferences
    return MaterialApp(
      title: 'Htt project',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const FlashPage(message: 'Welcome to Htt Project', duration: 3),
      routes: {
        '/login': (context) => const LoginPage(),
      },
    );
  }
}

class FlashPage extends StatefulWidget {
  const FlashPage({super.key, required this.message, required this.duration});

  final String message;
  final int duration;

  @override
  State<FlashPage> createState() => _FlashPageState();
}

class _FlashPageState extends State<FlashPage> {
  bool timeUp = false;
  late bool hasUserData;
  String? userId;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then(
      (prefs) {
        hasUserData = prefs.containsKey('htt_proj_userId');
        if (hasUserData) {
          userId = prefs.getString('htt_proj_userId');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!timeUp) {
      Future.delayed(Duration(seconds: widget.duration), () {
        setState(() {
          timeUp = true;
        });
      });
    }

    return Scaffold(
      body: Center(
        child: AnimatedDefaultTextStyle(
          curve: Curves.linear,
          duration: const Duration(milliseconds: 500),
          style: timeUp
              ? Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Colors.transparent)
              : Theme.of(context).textTheme.titleLarge!,
          child: Text(widget.message),
          onEnd: () {
            log('FlashPage ends.');
            if (hasUserData) {
              // Navigator.pushNamed(context, '/home', arguments: userId);
            } else {
              log('No user data found.');
              Navigator.pushNamed(context, '/login');
            }
          },
        ),
      ),
    );
  }
}
