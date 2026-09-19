import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../game/ball_set.dart';
import '../game/pool_game.dart';
import 'theme.dart';

class TableUi extends StatefulWidget {
  const TableUi({super.key});

  @override
  State<TableUi> createState() => _TableUiState();
}

class _TableUiState extends State<TableUi> {
  late final PoolGame game;

  @override
  void initState() {
    super.initState();
    game = PoolGame(
      ballSet: BallSet.blueRed,
      onWin: _win,
      onPocket: _pocket,
    );
  }

  void _win(bool youWin) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(youWin ? 'You win the pot' : 'You lost')),
    );
  }

  void _pocket(String kind) {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RackColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Text('YOU', style: TextStyle(color: Colors.white)),
                  const Spacer(),
                  Text('20 USDT',
                      style: TextStyle(color: RackColors.gold, fontSize: 16)),
                  const Spacer(),
                  const Text('MAYA', style: TextStyle(color: Colors.white)),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Column(
                      children: [
                        Expanded(
                          child: RotatedBox(
                            quarterTurns: 3,
                            child: Slider(
                              value: game.power,
                              min: 0.08,
                              max: 1,
                              activeColor: RackColors.gold,
                              onChanged: (v) {
                                setState(() => game.setPower(v));
                              },
                            ),
                          ),
                        ),
                        Text('${(game.power * 100).round()}',
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: () {
                            game.setPower(game.power);
                            game.shoot();
                          },
                          child: const Text('Shoot'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(child: GameWidget(game: game)),
                  SizedBox(
                    width: 48,
                    child: ListView(
                      children: game.returnRail
                          .map((k) => Container(
                                margin: const EdgeInsets.all(4),
                                height: 18,
                                decoration: BoxDecoration(
                                  color: k == BallKind.black
                                      ? Colors.black
                                      : k == BallKind.a
                                          ? Colors.blue
                                          : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}