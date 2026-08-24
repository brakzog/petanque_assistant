enum RepechageRule {
  bestScore,
  bestPointDifference,
  random,
}

class TournamentRules {
  final int targetScore;

  final bool allowFirstRoundRepechage;

  final int firstRoundRepechageSlots;

  final RepechageRule repechageRule;

  const TournamentRules({
    this.targetScore = 13,
    this.allowFirstRoundRepechage = false,
    this.firstRoundRepechageSlots = 0,
    this.repechageRule = RepechageRule.bestScore,
  });

  TournamentRules copyWith({
    int? targetScore,
    bool? allowFirstRoundRepechage,
    int? firstRoundRepechageSlots,
    RepechageRule? repechageRule,
  }) {
    return TournamentRules(
      targetScore: targetScore ?? this.targetScore,
      allowFirstRoundRepechage:
      allowFirstRoundRepechage ?? this.allowFirstRoundRepechage,
      firstRoundRepechageSlots:
      firstRoundRepechageSlots ?? this.firstRoundRepechageSlots,
      repechageRule: repechageRule ?? this.repechageRule,
    );
  }
}