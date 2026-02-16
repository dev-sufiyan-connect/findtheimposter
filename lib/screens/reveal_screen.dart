import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/game_provider.dart';
import 'game_summary_screen.dart';

class RevealScreen extends ConsumerStatefulWidget {
  const RevealScreen({super.key});

  @override
  ConsumerState<RevealScreen> createState() => _RevealScreenState();
}

class _RevealScreenState extends ConsumerState<RevealScreen> {
  bool _roleRevealed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final currentName = state.currentPlayerName;
    final allRevealed = state.allRevealed;

    if (allRevealed) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const GameSummaryScreen()),
          );
        }
      });
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: const Center(
            child: CircularProgressIndicator(color: AppTheme.startGameGlow),
          ),
        ),
      );
    }

    if (currentName == null) {
      return Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
          child: const Center(
            child: Text('Something went wrong.', style: TextStyle(color: Colors.white)),
          ),
        ),
      );
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!_roleRevealed) ...[
                  Text(
                    'Give phone to',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white70,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    currentName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: AppTheme.titleImposterShadow.withValues(alpha: 0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                  ),
                  const SizedBox(height: 48),
                  _buildRevealButton(context),
                ] else ...[
                  if (state.isImposterCurrent)
                    _buildImposterCard(context)
                  else
                    _buildWordCard(context, state.secretWord!),
                  const SizedBox(height: 32),
                  _buildHideNextButton(context),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRevealButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.addPlayerGlow.withValues(alpha: 0.5),
            blurRadius: 12,
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: () => setState(() => _roleRevealed = true),
        icon: const Icon(Icons.visibility_rounded, size: 24),
        label: const Text('Tap to Reveal'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.addPlayerBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.addPlayerGlow.withValues(alpha: 0.6), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildHideNextButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.startGameGlow.withValues(alpha: 0.4),
            blurRadius: 12,
          ),
        ],
      ),
      child: FilledButton.icon(
        onPressed: () {
          ref.read(gameProvider.notifier).advanceToNextPlayer();
          setState(() => _roleRevealed = false);
        },
        icon: const Icon(Icons.visibility_off_rounded, size: 22),
        label: const Text('Hide & Next Player'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.startGameGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.startGameGlow.withValues(alpha: 0.6), width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildWordCard(BuildContext context, String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.boardBg,
            Color.lerp(AppTheme.boardBg, AppTheme.boardEdge, 0.2)!,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.boardEdge, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'The secret word is',
            style: TextStyle(
              color: AppTheme.bannerText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            word,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppTheme.bannerText,
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImposterCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 28),
      decoration: BoxDecoration(
        color: AppTheme.titleImposter.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.titleImposter, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppTheme.titleImposter.withValues(alpha: 0.3),
            blurRadius: 16,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            size: 48,
            color: AppTheme.questionMark,
          ),
          const SizedBox(height: 12),
          Text(
            'You are the Imposter',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: AppTheme.titleImposterShadow,
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "You don't know the word. Blend in!",
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
