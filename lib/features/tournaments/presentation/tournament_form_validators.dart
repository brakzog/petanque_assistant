/// Validators of the tournament creation form. Each returns the error to
/// display, or null when the value is valid.
abstract final class TournamentFormValidators {
  static String? name(String? value) {
    if (value == null || value.trim().isEmpty) return 'Saisissez un nom';
    return null;
  }

  static String? targetScore(String? value) {
    final score = int.tryParse(value ?? '');
    if (score == null || score <= 0) return 'Saisissez un score valide';
    return null;
  }

  static String? repechageSlots(String? value) {
    final slots = int.tryParse(value ?? '');
    if (slots == null || slots <= 0) return 'Saisissez un nombre valide';
    return null;
  }
}

/// dd/mm/yyyy
String formatDate(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '$day/$month/${date.year}';
}
