import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/secret_words.dart';
import 'app_settings_provider.dart';

/// Game state: players, secret word, imposters, reveal order.
class GameState {
  final List<String> players;
  final String? secretWord;
  final AppLanguage language;
  final int imposterCount;
  final List<int> imposterIndices;
  final List<int> revealOrder;
  final int currentRevealIndex;

  const GameState({
    this.players = const [],
    this.secretWord,
    this.language = AppLanguage.english,
    this.imposterCount = 1,
    this.imposterIndices = const [],
    this.revealOrder = const [],
    this.currentRevealIndex = 0,
  });

  GameState copyWith({
    List<String>? players,
    String? secretWord,
    AppLanguage? language,
    int? imposterCount,
    List<int>? imposterIndices,
    List<int>? revealOrder,
    int? currentRevealIndex,
  }) {
    return GameState(
      players: players ?? this.players,
      secretWord: secretWord ?? this.secretWord,
      language: language ?? this.language,
      imposterCount: imposterCount ?? this.imposterCount,
      imposterIndices: imposterIndices ?? this.imposterIndices,
      revealOrder: revealOrder ?? this.revealOrder,
      currentRevealIndex: currentRevealIndex ?? this.currentRevealIndex,
    );
  }

  /// Index of the player whose turn it is (0-based in reveal order).
  int get currentPlayerIndexInOrder =>
      currentRevealIndex < revealOrder.length ? revealOrder[currentRevealIndex] : -1;

  String? get currentPlayerName {
    final idx = currentPlayerIndexInOrder;
    if (idx < 0 || idx >= players.length) return null;
    return players[idx];
  }

  bool get isImposterCurrent =>
      imposterIndices.contains(currentPlayerIndexInOrder);

  bool get allRevealed => currentRevealIndex >= players.length;
}

class GameNotifier extends StateNotifier<GameState> {
  final _random = Random();

  GameNotifier() : super(const GameState());

  void setPlayers(List<String> names) {
    state = state.copyWith(players: names);
  }

  void addPlayer(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    if (state.players.length >= 20) return;
    if (state.players.any((p) => p.toLowerCase() == trimmed.toLowerCase())) return;
    state = state.copyWith(players: [...state.players, trimmed]);
  }

  void removePlayer(int index) {
    if (index < 0 || index >= state.players.length) return;
    final updated = List<String>.from(state.players)..removeAt(index);
    state = state.copyWith(players: updated);
  }

  /// Start a new round: pick random word, random imposters, random reveal order.
  void startGame({
    required AppLanguage language,
    required int imposterCount,
  }) {
    if (state.players.length < 3 || state.players.length > 20) return;

    final availableImposterMax = state.players.length - 1;
    final effectiveImposterCount = imposterCount.clamp(1, availableImposterMax);

    final words = language == AppLanguage.malayalam ? secretWordsMalayalam : secretWords;
    final word = words[_random.nextInt(words.length)];

    // Pick N distinct imposter indices.
    final indices = <int>{};
    while (indices.length < effectiveImposterCount) {
      indices.add(_random.nextInt(state.players.length));
    }
    final imposterIndices = indices.toList()..sort();

    final order = List<int>.generate(state.players.length, (i) => i)..shuffle(_random);

    state = state.copyWith(
      language: language,
      imposterCount: effectiveImposterCount,
      secretWord: word,
      imposterIndices: imposterIndices,
      revealOrder: order,
      currentRevealIndex: 0,
    );
  }

  void advanceToNextPlayer() {
    if (state.currentRevealIndex >= state.players.length) return;
    state = state.copyWith(currentRevealIndex: state.currentRevealIndex + 1);
  }

  void restartWithSamePlayers() {
    startGame(language: state.language, imposterCount: state.imposterCount);
  }

  void newGame() {
    state = const GameState();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
