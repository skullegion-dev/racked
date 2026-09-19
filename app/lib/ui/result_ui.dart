import 'package:flutter/material.dart';
import 'theme.dart';

class ResultUi extends StatelessWidget {
  const ResultUi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Text('MATCH RESULT',
                  style: TextStyle(color: Rack.muted, letterSpacing: 2)),
              const SizedBox(height: 8),
              const Text('YOU WIN',
                  style: TextStyle(color: Rack.gold, fontSize: 40)),
              const Text('Demo payout — not on-chain yet',
                  style: TextStyle(color: Rack.goldSoft)),
              const Spacer(),
              _row('Pot', '20.00 USDT'),
              _row('Rake (5%)', '−1.00 USDT'),
              _row('Paid to you', '19.00 USDT', gold: true),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Rack.gold,
                    foregroundColor: Rack.bg,
                  ),
                  onPressed: () =>
                      Navigator.popUntil(context, (r) => r.isFirst),
                  child: const Text('Play again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _row(String k, String v, {bool gold = false}) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(k, style: const TextStyle(color: Rack.muted)),
            Text(v,
                style: TextStyle(color: gold ? Rack.gold : Colors.white)),
          ],
        ),
      );
}