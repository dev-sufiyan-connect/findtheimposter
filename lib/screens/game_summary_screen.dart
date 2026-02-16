import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/app_theme.dart';
import '../providers/game_provider.dart';
import 'player_setup_screen.dart';
import 'reveal_screen.dart';

class GameSummaryScreen extends ConsumerStatefulWidget {
  const GameSummaryScreen({super.key});

  @override
  ConsumerState<GameSummaryScreen> createState() => _GameSummaryScreenState();
}

class _GameSummaryScreenState extends ConsumerState<GameSummaryScreen> {
  bool _imposterRevealed = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final players = state.players;
    final imposterIndex = state.imposterIndex;
    final imposterName = imposterIndex != null && imposterIndex < players.length
        ? players[imposterIndex]
        : null;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),
                _buildTitle(context),
                const SizedBox(height: 24),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _buildWoodenBoard(
                          context,
                          players: players,
                          imposterIndex: imposterIndex,
                          imposterRevealed: _imposterRevealed,
                          imposterName: imposterName,
                          onRevealImposter: () => setState(() => _imposterRevealed = true),
                        ),
                        const SizedBox(height: 24),
                        if (!_imposterRevealed)
                          _buildRevealImposterButton(context)
                        else if (imposterName != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: Text(
                              'The Imposter was $imposterName',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: AppTheme.startGameGlow,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        _buildRestartButton(context),
                        const SizedBox(height: 12),
                        _buildNewGameButton(context),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Find The ',
          style: TextStyle(
            color: AppTheme.titleFindThe,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppTheme.titleImposterGlow, AppTheme.titleImposter],
          ).createShader(bounds),
          child: Text(
            'IMPOSTER',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
              shadows: [
                Shadow(
                  color: AppTheme.titleImposterShadow,
                  offset: const Offset(1, 1),
                  blurRadius: 2,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        const Text(
          ' – Game Over',
          style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildWoodenBoard(
    BuildContext context, {
    required List<String> players,
    required int? imposterIndex,
    required bool imposterRevealed,
    required String? imposterName,
    required VoidCallback onRevealImposter,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.woodenBoardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.bannerBg,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.boardEdge),
            ),
            child: Text(
              'Players',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppTheme.bannerText,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(players.length, (index) {
            final name = players[index];
            final isImposter = index == imposterIndex && imposterRevealed;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: isImposter
                      ? AppTheme.titleImposter.withValues(alpha: 0.3)
                      : AppTheme.inputBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isImposter ? AppTheme.titleImposter : AppTheme.inputBorder,
                    width: isImposter ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: isImposter
                          ? AppTheme.titleImposter
                          : AppTheme.addPlayerBlue.withValues(alpha: 0.3),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isImposter ? Colors.white : AppTheme.bannerText,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        name,
                        style: TextStyle(
                          color: isImposter ? Colors.white : const Color(0xFF333333),
                          fontSize: 16,
                          fontWeight: isImposter ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ),
                    if (isImposter)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.titleImposter,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'IMPOSTER',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildRevealImposterButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: AppTheme.addPlayerGlow.withValues(alpha: 0.4),
            blurRadius: 8,
          ),
        ],
      ),
      child: OutlinedButton.icon(
        onPressed: () => setState(() => _imposterRevealed = true),
        icon: const Icon(Icons.visibility_rounded, size: 22, color: AppTheme.addPlayerBlue),
        label: const Text(
          'Reveal Imposter',
          style: TextStyle(
            color: AppTheme.addPlayerBlue,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: AppTheme.addPlayerBlue, width: 2),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildRestartButton(BuildContext context) {
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
      child: FilledButton(
        onPressed: () {
          ref.read(gameProvider.notifier).restartWithSamePlayers();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const RevealScreen()),
          );
        },
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.startGameGreen,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: AppTheme.startGameGlow.withValues(alpha: 0.6), width: 2),
          ),
        ),
        child: const Text('Restart with Same Players'),
      ),
    );
  }

  Widget _buildNewGameButton(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        ref.read(gameProvider.notifier).newGame();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const PlayerSetupScreen()),
          (route) => false,
        );
      },
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white70,
        padding: const EdgeInsets.symmetric(vertical: 16),
        side: const BorderSide(color: Colors.white38, width: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      child: const Text('New Game'),
    );
  }
}
