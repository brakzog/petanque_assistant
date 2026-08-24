class PetanqueBall {
  final String id;
  final String playerId;

  final String? brand;
  final String? model;
  final int? diameter;
  final int? weight;

  const PetanqueBall({
    required this.id,
    required this.playerId,
    this.brand,
    this.model,
    this.diameter,
    this.weight,
  });

  PetanqueBall copyWith({
    String? id,
    String? playerId,
    String? brand,
    String? model,
    int? diameter,
    int? weight,
  }) {
    return PetanqueBall(
      id: id ?? this.id,
      playerId: playerId ?? this.playerId,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      diameter: diameter ?? this.diameter,
      weight: weight ?? this.weight,
    );
  }
}