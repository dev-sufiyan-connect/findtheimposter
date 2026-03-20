import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/secret_words.dart';

/// Game state: players, secret word, imposter index, reveal order.
class GameState {
  final List<String> players;
  final String? secretWord;
  final int? imposterIndex;
  final List<int> revealOrder;
  final int currentRevealIndex;

  const GameState({
    this.players = const [],
    this.secretWord,
    this.imposterIndex,
    this.revealOrder = const [],
    this.currentRevealIndex = 0,
  });

  GameState copyWith({
    List<String>? players,
    String? secretWord,
    int? imposterIndex,
    List<int>? revealOrder,
    int? currentRevealIndex,
  }) {
    return GameState(
      players: players ?? this.players,
      secretWord: secretWord ?? this.secretWord,
      imposterIndex: imposterIndex ?? this.imposterIndex,
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
      imposterIndex != null && currentPlayerIndexInOrder == imposterIndex;

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

  /// Start a new round: pick random word, random imposter, random reveal order.
  void startGame() {
    if (state.players.length < 3 || state.players.length > 20) return;

    final word =
        secretWords[_random.nextInt(secretWords.length)];
    final imposter = _random.nextInt(state.players.length);
    final order = List<int>.generate(state.players.length, (i) => i)..shuffle(_random);

    state = state.copyWith(
      secretWord: word,
      imposterIndex: imposter,
      revealOrder: order,
      currentRevealIndex: 0,
    );
  }

  void advanceToNextPlayer() {
    if (state.currentRevealIndex >= state.players.length) return;
    state = state.copyWith(currentRevealIndex: state.currentRevealIndex + 1);
  }

  void restartWithSamePlayers() {
    startGame();
  }

  void newGame() {
    state = const GameState();
  }
}

final gameProvider = StateNotifierProvider<GameNotifier, GameState>((ref) {
  return GameNotifier();
});
