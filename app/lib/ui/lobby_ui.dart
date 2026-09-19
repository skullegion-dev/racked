import 'package:flutter/material.dart';
import 'theme.dart';
import 'table_ui.dart';

class LobbyUi extends StatefulWidget {
  const LobbyUi({super.key});
  @override
  State<LobbyUi> createState() => _LobbyUiState();
}

class _LobbyUiState extends State<LobbyUi> {
  double stake = 10;

  final tables = const [
    ('Alex', 'Open', 5),
    ('Maya', 'Live', 10),
    ('Jordan', 'Open', 25),
  ];

  void _goTable() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => const TableUi()));
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      children: [
        const Center(
          child: Text('RACKED',
              style: TextStyle(
                color: Rack.gold,
                fontSize: 28,
                letterSpacing: 6,
                fontWeight: FontWeight.w600,
              )),
        ),
        const SizedBox(height: 8),
        const Text('Connected  ·  demo',
            textAlign: TextAlign.center,
            style: TextStyle(color: Rack.muted, fontSize: 12)),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Rack.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Rack.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Open table',
                  style: TextStyle(color: Rack.goldSoft, fontSize: 18)),
              Slider(
                value: stake,
                min: 1,
                max: 50,
                divisions: 49,
                activeColor: Rack.gold,
                onChanged: (v) => setState(() => stake = v.roundToDouble()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Winner takes pot minus 5%',
                      style: TextStyle(color: Rack.muted, fontSize: 12)),
                  Text('${stake.toInt()} USDT',
                      style: const TextStyle(color: Rack.gold, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Rack.gold,
                    foregroundColor: Rack.bg,
                  ),
                  onPressed: _goTable,
                  child: Text('Lock ${stake.toInt()} USDT'),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Open tables', style: TextStyle(color: Rack.goldSoft)),
        const SizedBox(height: 8),
        ...tables.map((t) {
          final (name, status, s) = t;
          final open = status == 'Open';
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Rack.card,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Rack.line),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Rack.line,
                  child: Text(name[0], style: const TextStyle(color: Rack.gold)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name),
                      Text(status,
                          style: TextStyle(
                            color: open ? Colors.greenAccent : Colors.orange,
                            fontSize: 12,
                          )),
                    ],
                  ),
                ),
                Text('$s USDT', style: const TextStyle(color: Rack.gold)),
                const SizedBox(width: 8),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: open ? Rack.gold : Rack.line,
                    foregroundColor: Rack.bg,
                  ),
                  onPressed: open ? _goTable : null,
                  child: const Text('Join'),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}