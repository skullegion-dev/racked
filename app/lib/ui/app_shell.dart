import 'package:flutter/material.dart';
import 'theme.dart';
import 'lobby_ui.dart';
import 'wallet_ui.dart';
import 'history_ui.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int i = 0;
  @override
  Widget build(BuildContext context) {
    const pages = [LobbyUi(), WalletUi(), HistoryUi()];
    return Scaffold(
      body: SafeArea(child: pages[i]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: i,
        onTap: (v) => setState(() => i = v),
        backgroundColor: Rack.bg,
        selectedItemColor: Rack.gold,
        unselectedItemColor: Rack.muted,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sports), label: 'Lobby'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined), label: 'Wallet'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}