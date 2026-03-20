import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppLanguage {
  english,
  malayalam,
}

class AppSettings {
  final AppLanguage language;
  final int imposterCount;

  const AppSettings({
    this.language = AppLanguage.english,
    this.imposterCount = 1,
  });

  AppSettings copyWith({
    AppLanguage? language,
    int? imposterCount,
  }) {
    return AppSettings(
      language: language ?? this.language,
      imposterCount: imposterCount ?? this.imposterCount,
    );
  }
}

/// App-wide (but session-only) settings used for game setup.
final appSettingsProvider = StateProvider<AppSettings>(
  (ref) => const AppSettings(),
);

