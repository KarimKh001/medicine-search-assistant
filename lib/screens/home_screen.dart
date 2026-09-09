import 'package:flutter/material.dart';
import 'search_screen.dart';
import 'library_screen.dart';
import 'settings_screen.dart';
import '../l10n/app_localizations.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final screens = [
      const SearchScreen(),
      LibraryScreen(),
      const SettingsScreen(),
    ];

    final titles = [
      'My Pharmacy Assistant - ${l10n.searchTabLabel}',
      l10n.libraryTitle,
      l10n.settingsTitle,
    ];

    return Scaffold(
      appBar: AppBar(title: Text(titles[_index])),
      body: IndexedStack(
        index: _index,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.search),
            label: l10n.searchTabLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.medical_information_outlined),
            label: l10n.libraryTabLabel,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            label: l10n.settingsTabLabel,
          ),
        ],
      ),
    );
  }
}
