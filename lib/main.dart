import 'dart:async';

import 'package:flutter/material.dart';

import 'app/app.dart';

void main() {
  runApp(const _BootstrapApp());
}

class _BootstrapApp extends StatefulWidget {
  const _BootstrapApp();

  @override
  State<_BootstrapApp> createState() => _BootstrapAppState();
}

class _BootstrapAppState extends State<_BootstrapApp> {
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 2), () {
      if (!mounted) return;

      setState(() {
        _showSplash = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_showSplash) {
      return const PetanqueApp();
    }

    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SizedBox.expand(
          child: Image(
            image: AssetImage('assets/images/splash_screen.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}