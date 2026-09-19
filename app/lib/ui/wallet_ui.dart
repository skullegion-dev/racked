import 'package:flutter/material.dart';
import 'theme.dart';

class WalletUi extends StatelessWidget {
  const WalletUi({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: const [
        Text('Wallet', style: TextStyle(color: Rack.gold, fontSize: 32)),
        SizedBox(height: 16),
        Text('Polygon USDT', style: TextStyle(color: Rack.muted)),
        Text('0.00', style: TextStyle(color: Rack.gold, fontSize: 40)),
        SizedBox(height: 12),
        Text('Connect Wallet in a later step. Chrome preview only.',
            style: TextStyle(color: Rack.muted)),
      ],
    );
  }
}