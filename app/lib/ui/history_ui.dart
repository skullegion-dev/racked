import 'package:flutter/material.dart';
import 'theme.dart';

class HistoryUi extends StatelessWidget {
  const HistoryUi({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Match history', style: TextStyle(color: Rack.muted)),
    );
  }
}