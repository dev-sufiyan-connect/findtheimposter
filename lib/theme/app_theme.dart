import 'package:flutter/material.dart';

/// FITMA design system – colors, gradients, and styles from Figma reference.
class AppTheme {
  AppTheme._();

  // Background
  static const Color bgTop = Color(0xFF2C2E4A);
  static const Color bgCenter = Color(0xFF252740);
  static const Color bgBottom = Color(0xFF1A1B2E);

  // Title
  static const Color titleFindThe = Color(0xFFFFFFFF);
  static const Color titleImposter = Color(0xFFFF4D4D);
  static const Color titleImposterGlow = Color(0xFFFF8C00);
  static const Color titleImposterShadow = Color(0xFF8B0000);

  // Magnifying glass / accent
  static const Color magnifyingGlassInner = Color(0xFF6DD5ED);
  static const Color magnifyingGlassFrame = Color(0xFF9E9E9E);

  // Question marks / mystery
  static const Color questionMark = Color(0xFFFFD700);
  static const Color questionMarkGlow = Color(0xFFFFEB3B);

  // Wooden board / parchment
  static const Color boardBg = Color(0xFFD2B48C);
  static const Color boardEdge = Color(0xFF8B7355);
  static const Color bannerBg = Color(0xFFA08060);
  static const Color bannerText = Color(0xFF5A3B1B);

  // Inputs
  static const Color inputBg = Color(0xFFE8E8E8);
  static const Color inputBorder = Color(0xFF87CEEB);
  static const Color inputBorderFocused = Color(0xFF6DD5ED);

  // Buttons
  static const Color addPlayerBlue = Color(0xFF2196F3);
  static const Color addPlayerGlow = Color(0xFF64B5F6);
  static const Color startGameGreen = Color(0xFF4CAF50);
  static const Color startGameGlow = Color(0xFFA7FFEB);

  // Silhouette / imposter hint
  static const Color silhouetteGlow = Color(0xFFFFA500);

  // Cards
  static const Color cardParchment = Color(0xFFF5DEB3);

  static LinearGradient get backgroundGradient => const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [bgTop, bgCenter, bgBottom],
      );

  static BoxDecoration get woodenBoardDecoration => BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            boardBg,
            Color.lerp(boardBg, boardEdge, 0.3)!,
            boardBg,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: boardEdge, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      );

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bgBottom,
        colorScheme: ColorScheme.dark(
          primary: addPlayerBlue,
          secondary: startGameGreen,
          surface: bgCenter,
          error: titleImposter,
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onSurface: Colors.white,
          onError: Colors.white,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          titleTextStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: inputBg,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: inputBorder, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: inputBorderFocused, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          hintStyle: TextStyle(color: Colors.grey.shade700, fontSize: 15),
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white, fontSize: 16),
          bodyMedium: TextStyle(color: Colors.white70, fontSize: 14),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 16),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          headlineMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
          headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22),
        ),
      );
}
