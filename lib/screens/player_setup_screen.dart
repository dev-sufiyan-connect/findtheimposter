import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../providers/game_provider.dart';
import '../providers/app_settings_provider.dart';
import 'reveal_screen.dart';
import 'settings_screen.dart';

class PlayerSetupScreen extends ConsumerStatefulWidget {
  const PlayerSetupScreen({super.key});

  @override
  ConsumerState<PlayerSetupScreen> createState() => _PlayerSetupScreenState();
}

class _PlayerSetupScreenState extends ConsumerState<PlayerSetupScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _addPlayer() {
    ref.read(gameProvider.notifier).addPlayer(_controller.text);
    _controller.clear();
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(gameProvider);
    final players = state.players;
    final canStart = players.length >= 3 && players.length <= 20;
    final isFull = players.length >= 20;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: AppTheme.backgroundGradient),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildTitle(context),
                      const SizedBox(height: 16),
                      _buildCharacterRow(players.length),
                      const SizedBox(height: 20),
                      _buildWoodenBoard(
                        context,
                        players: players,
                        canStart: canStart,
                        isFull: isFull,
                        controller: _controller,
                        focusNode: _focusNode,
                        onAdd: _addPlayer,
                        onRemove: (i) => ref.read(gameProvider.notifier).removePlayer(i),
                      ),
                      const SizedBox(height: 24),
                      _buildStartGameButton(context, canStart),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const Spacer(),
          Text(
            'Add Players',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.settings_rounded, color: Colors.white),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Find The',
              style: TextStyle(
                color: AppTheme.titleFindThe,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 2),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  AppTheme.titleImposterGlow,
                  AppTheme.titleImposter,
                ],
              ).createShader(bounds),
              child: Text(
                'IMPOSTER',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
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
          ],
        ),
        const SizedBox(width: 6),
        Container(
          width: 44,
          height: 44,
          margin: const EdgeInsets.only(bottom: 2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppTheme.magnifyingGlassFrame, width: 2),
            color: AppTheme.magnifyingGlassInner.withValues(alpha: 0.15),
          ),
          child: const Icon(
            Icons.search_rounded,
            color: AppTheme.magnifyingGlassFrame,
            size: 22,
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterRow(int playerCount) {
    final colors = [
      const Color(0xFFE53935),
      const Color(0xFF43A047),
      const Color(0xFFFB8C00),
      const Color(0xFF8E24AA),
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colors[i].withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white24, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  i == 3 ? Icons.psychology_rounded : Icons.face_rounded,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppTheme.questionMark.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.questionMarkGlow.withValues(alpha: 0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.help_outline_rounded,
                  color: AppTheme.questionMark,
                  size: 16,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildWoodenBoard(
    BuildContext context, {
    required List<String> players,
    required bool canStart,
    required bool isFull,
    required TextEditingController controller,
    required FocusNode focusNode,
    required VoidCallback onAdd,
    required void Function(int) onRemove,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppTheme.woodenBoardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildRibbonBanner(context),
          const SizedBox(height: 20),
          TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Player ${players.length + 1}',
              prefixIcon: const Icon(Icons.person_outline_rounded, color: AppTheme.bannerText, size: 20),
            ),
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => onAdd(),
            inputFormatters: [LengthLimitingTextInputFormatter(20)],
            style: const TextStyle(color: Color(0xFF333333), fontSize: 15),
          ),
          if (players.isNotEmpty) ...[
            ...List.generate(players.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(top: 10),
                child: _buildPlayerChip(context, players[i], i, onRemove),
              );
            }),
          ],
          const SizedBox(height: 16),
          _buildAddPlayerButton(context, isFull, onAdd),
          if (!canStart && players.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                players.length < 3
                    ? 'Add at least ${3 - players.length} more player(s).'
                    : 'Maximum 20 players.',
                style: const TextStyle(
                  color: AppTheme.titleImposter,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRibbonBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: AppTheme.bannerBg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.boardEdge, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        'Enter Player Names',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: AppTheme.bannerText,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildPlayerChip(
    BuildContext context,
    String name,
    int index,
    void Function(int) onRemove,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.inputBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppTheme.addPlayerBlue.withValues(alpha: 0.3),
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: AppTheme.bannerText,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.remove_circle_outline, color: AppTheme.titleImposter, size: 22),
            onPressed: () => onRemove(index),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
          ),
        ],
      ),
    );
  }

  Widget _buildAddPlayerButton(BuildContext context, bool isFull, VoidCallback onAdd) {
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
      child: FilledButton.icon(
        onPressed: isFull ? null : onAdd,
        icon: const Icon(Icons.add_rounded, size: 22),
        label: const Text('Add Player'),
        style: FilledButton.styleFrom(
          backgroundColor: AppTheme.addPlayerBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: AppTheme.addPlayerGlow.withValues(alpha: 0.6),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStartGameButton(BuildContext context, bool canStart) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: canStart
                ? AppTheme.startGameGlow.withValues(alpha: 0.5)
                : Colors.black.withValues(alpha: 0.2),
            blurRadius: canStart ? 16 : 8,
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: FilledButton(
        onPressed: canStart
            ? () {
                final settings = ref.read(appSettingsProvider);
                ref
                    .read(gameProvider.notifier)
                    .startGame(language: settings.language, imposterCount: settings.imposterCount);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const RevealScreen()),
                );
              }
            : null,
        style: FilledButton.styleFrom(
          backgroundColor: canStart ? AppTheme.startGameGreen : Colors.grey.shade700,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade800,
          disabledForegroundColor: Colors.white54,
          padding: const EdgeInsets.symmetric(vertical: 18),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: canStart
                  ? AppTheme.startGameGlow.withValues(alpha: 0.8)
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: const Text('START GAME'),
      ),
    );
  }
}
