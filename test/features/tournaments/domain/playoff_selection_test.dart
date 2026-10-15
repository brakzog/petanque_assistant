import 'package:flutter_test/flutter_test.dart';
import 'package:tournoi_de_petanque/features/tournaments/domain/playoff_selection.dart';

void main() {
  const empty = PlayoffSelection(slots: 2);

  test('selects up to the number of slots', () {
    final two = empty.toggle('a')!.toggle('b')!;

    expect(two.isValid, isTrue);
    expect(two.toggle('c'), isNull);
  });

  test('unselects a selected team even when full', () {
    final two = empty.toggle('a')!.toggle('b')!;
    final one = two.toggle('a')!;

    expect(one.isSelected('a'), isFalse);
    expect(one.isValid, isFalse);
  });

  test('does not mutate the previous selection', () {
    final one = empty.toggle('a')!;

    expect(empty.selectedTeamIds, isEmpty);
    expect(one.selectedTeamIds, {'a'});
  });
}
