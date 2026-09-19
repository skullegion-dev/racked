import 'package:flutter/material.dart';
import 'ui/theme.dart';
import 'ui/app_shell.dart';

void main() => runApp(const RackedApp());

class RackedApp extends StatelessWidget {
  const RackedApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: Rack.theme(),
      home: const AppShell(),
    );
  }
}