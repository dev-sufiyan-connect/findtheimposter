import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/app_settings_provider.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildTopBar(context),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Language'),
                const SizedBox(height: 12),
                DropdownButtonFormField<AppLanguage>(
                  value: settings.language,
                  dropdownColor: const Color(0xFF252740),
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24, width: 1.5),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: AppLanguage.english,
                      child: Text('English', style: TextStyle(color: Colors.white)),
                    ),
                    DropdownMenuItem(
                      value: AppLanguage.malayalam,
                      child: Text('Malayalam', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                  onChanged: (value) {
                    if (value == null) return;
                    ref.read(appSettingsProvider.notifier).state =
                        settings.copyWith(language: value);
                  },
                ),
                const SizedBox(height: 24),
                _buildSectionTitle(context, 'Number of imposters'),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: settings.imposterCount,
                  dropdownColor: const Color(0xFF252740),
                  decoration: InputDecoration(
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.white24, width: 1.5),
                    ),
                  ),
                  items: const [1, 2, 3, 4, 5]
                      .map(
                        (n) => DropdownMenuItem(
                          value: n,
                          child: Text('$n', style: const TextStyle(color: Colors.white)),
                        ),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    ref.read(appSettingsProvider.notifier).state =
                        settings.copyWith(imposterCount: value);
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  'Maximum imposters is limited by the number of players (we keep at least 1 non-imposter).',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),
                const SizedBox(height: 24),
                _buildBackToGameButton(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        const Spacer(),
        const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Spacer(),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white),
    );
  }

  Widget _buildBackToGameButton(BuildContext context) {
    return FilledButton(
      onPressed: () => Navigator.of(context).pop(),
      style: FilledButton.styleFrom(
        backgroundColor: AppTheme.startGameGreen,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text('Done'),
    );
  }
}

