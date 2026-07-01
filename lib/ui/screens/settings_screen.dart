import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yu_gi_oh_app/l10n/app_localizations.dart';
import '../../viewmodel/settings_viewmodel.dart';
import '../../viewmodel/theme_viewmodel.dart';
import '../../viewmodel/app_language_viewmodel.dart';
import '../components/settings/market_chip.dart';
// Debug
import 'package:yu_gi_oh_app/debug/debug_logger.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final settingsVM = Provider.of<SettingsViewModel>(context);
    final themeProvider = Provider.of<ThemeViewmodel>(context);
    final appLanguageProvider = Provider.of<AppLanguageViewmodel>(context);

    final orientation = MediaQuery.of(context).orientation;
    final bool isLandscape = orientation == Orientation.landscape;
    final double titlePadding = isLandscape ? 6.0 : 2.0;

    String statusMessage() {
      switch (settingsVM.updateStatus) {
        case UpdateStatus.checking:
          return l10n.checkingForUpdates;
        case UpdateStatus.success:
          return l10n.dbUpdated;
        case UpdateStatus.already:
          return l10n.dbAlreadyUpToDate;
        case UpdateStatus.error:
          return '${l10n.dbUpdateError} ${settingsVM.errorMessage}';
        default:
          return '';
      }
    }

    Color statusColor() {
      switch (settingsVM.updateStatus) {
        case UpdateStatus.success:
          return Colors.green;
        case UpdateStatus.error:
          return Colors.red;
        default:
          return Theme.of(context).colorScheme.onSurface;
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: titlePadding),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: Theme.of(context).primaryColor, size: 42),
                    onPressed: () {
                      DebugLogger().logTap(details: 'Back from Settings');
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(width: 8),
                  Text(
                    l10n.settingsTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 35,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // Language Options Card
                    Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.languageOptions,
                                style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface)),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(l10n.appLanguage,
                                    style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                                const Spacer(),
                                DropdownButton<String>(
                                  value: settingsVM.appLanguage,
                                  items: const [
                                    DropdownMenuItem(value: 'en', child: Text('English')),
                                    DropdownMenuItem(value: 'pt', child: Text('Portuguese')),
                                    DropdownMenuItem(value: 'de', child: Text('German')),
                                    DropdownMenuItem(value: 'fr', child: Text('French')),
                                    DropdownMenuItem(value: 'it', child: Text('Italian')),
                                  ],
                                  onChanged: (value) async {
                                    DebugLogger().logTap(details: 'App Language $value');
                                    await settingsVM.setAppLanguage(value!);
                                    await appLanguageProvider.setLocale(Locale(value));
                                  },
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                  dropdownColor: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Text(l10n.cardTranslation,
                                    style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                                const Spacer(),
                                DropdownButton<String>(
                                  value: settingsVM.cardTranslation,
                                  items: const [
                                    DropdownMenuItem(value: '', child: Text('English')),
                                    DropdownMenuItem(value: 'pt', child: Text('Portuguese')),
                                    DropdownMenuItem(value: 'de', child: Text('German')),
                                    DropdownMenuItem(value: 'fr', child: Text('French')),
                                    DropdownMenuItem(value: 'it', child: Text('Italian')),
                                  ],
                                  onChanged: (value) {
                                    DebugLogger().logTap(details: 'Card Translation $value');
                                    settingsVM.setCardTranslation(value!);
                                  },
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                  dropdownColor: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Dark Mode Card
                    Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
                        child: Row(
                          children: [
                            Text(l10n.darkMode,
                                style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface)),
                            const Spacer(),
                            Switch(
                              value: settingsVM.themeMode == 'dark',
                              onChanged: (value) async {
                                final newMode = value ? 'dark' : 'light';
                                DebugLogger().logTap(details: 'Dark Mode $newMode');
                                await settingsVM.setThemeMode(newMode);
                                await themeProvider.setThemeMode(value ? ThemeMode.dark : ThemeMode.light);
                              },
                              activeThumbColor: Theme.of(context).colorScheme.surface,
                              activeTrackColor: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                              inactiveThumbColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
                              inactiveTrackColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Market Options Card
                    Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.marketOptions,
                                style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface)),
                            const SizedBox(height: 8),
                            Text(l10n.markets,
                                style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                            const SizedBox(height: 4),
                            Wrap(
                              spacing: 8,
                              children: [
                                MarketChip(
                                  label: l10n.marketCardmarket,
                                  selected: settingsVM.enabledMarkets.contains('cardmarket'),
                                  onTap: () {
                                    DebugLogger().logTap(details: 'Toggle Market Cardmarket');
                                    settingsVM.toggleMarket('cardmarket');
                                  },
                                ),
                                MarketChip(
                                  label: l10n.marketTcgplayer,
                                  selected: settingsVM.enabledMarkets.contains('tcgplayer'),
                                  onTap: () {
                                    DebugLogger().logTap(details: 'Toggle Market Tcgplayer');
                                    settingsVM.toggleMarket('tcgplayer');
                                  },
                                ),
                                MarketChip(
                                  label: l10n.marketCoolstuffinc,
                                  selected: settingsVM.enabledMarkets.contains('coolstuffinc'),
                                  onTap: () {
                                    DebugLogger().logTap(details: 'Toggle Market Coolstuffinc');
                                    settingsVM.toggleMarket('coolstuffinc');
                                  },
                                ),
                                MarketChip(
                                  label: l10n.marketEbay,
                                  selected: settingsVM.enabledMarkets.contains('ebay'),
                                  onTap: () {
                                    DebugLogger().logTap(details: 'Toggle Market Ebay');
                                    settingsVM.toggleMarket('ebay');
                                  },
                                ),
                                MarketChip(
                                  label: l10n.marketAmazon,
                                  selected: settingsVM.enabledMarkets.contains('amazon'),
                                  onTap: () {
                                    DebugLogger().logTap(details: 'Toggle Market Amazon');
                                    settingsVM.toggleMarket('amazon');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Text(l10n.currency,
                                    style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                                const Spacer(),
                                DropdownButton<String>(
                                  value: settingsVM.currency,
                                  items: const [
                                    DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                                    DropdownMenuItem(value: 'USD', child: Text('USD')),
                                  ],
                                  onChanged: (value) {
                                    DebugLogger().logTap(details: 'Currency $value');
                                    settingsVM.setCurrency(value!);
                                  },
                                  style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                                  dropdownColor: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Database Update Card
                    Card(
                      color: Theme.of(context).cardColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(l10n.databaseUpdate,
                                style: TextStyle(fontSize: 22, color: Theme.of(context).colorScheme.onSurface)),
                            const SizedBox(height: 8),
                            Text('${l10n.databaseVersion} ${settingsVM.dbVersion}',
                                style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                            Text('${l10n.lastUpdate} ${settingsVM.lastUpdate}',
                                style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onSurface)),
                            if (statusMessage().isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Text(statusMessage(),
                                  style: TextStyle(fontSize: 14, color: statusColor())),
                            ],
                            const SizedBox(height: 12),
                            Center(
                              child: SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: settingsVM.updateStatus == UpdateStatus.checking
                                      ? null
                                      : () {
                                          DebugLogger().logTap(details: 'Check Updates');
                                          settingsVM.checkForUpdates();
                                        },
                                  child: settingsVM.updateStatus == UpdateStatus.checking
                                      ? const SizedBox(
                                          height: 20,
                                          width: 20,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : Text(l10n.checkForUpdates),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}