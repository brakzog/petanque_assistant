import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/database_providers.dart';
import '../domain/match_scorer.dart';
import 'bracket_generator.dart';
import 'bracket_loader.dart';
import 'end_repository.dart';
import 'match_end_recorder.dart';
import 'match_repository.dart';
import 'petanque_ball_photo_repository.dart';
import 'petanque_ball_repository.dart';
import 'player_repository.dart';
import 'predefined_teams_service.dart';
import 'repechage_playoff_repository.dart';
import 'repechage_service.dart';
import 'roster_service.dart';
import 'team_generator.dart';
import 'team_repository.dart';
import 'tournament_progression_service.dart';
import 'tournament_repository.dart';

final tournamentRepositoryProvider = Provider<TournamentRepository>(
  (ref) => TournamentRepository(ref.watch(appDatabaseProvider)),
);

final playerRepositoryProvider = Provider<PlayerRepository>(
  (ref) => PlayerRepository(ref.watch(appDatabaseProvider)),
);

final teamRepositoryProvider = Provider<TeamRepository>(
  (ref) => TeamRepository(ref.watch(appDatabaseProvider)),
);

final matchRepositoryProvider = Provider<MatchRepository>(
  (ref) => MatchRepository(ref.watch(appDatabaseProvider)),
);

final endRepositoryProvider = Provider<EndRepository>(
  (ref) => EndRepository(ref.watch(appDatabaseProvider)),
);

final repechagePlayoffRepositoryProvider = Provider<RepechagePlayoffRepository>(
  (ref) => RepechagePlayoffRepository(ref.watch(appDatabaseProvider)),
);

final petanqueBallRepositoryProvider = Provider<PetanqueBallRepository>(
  (ref) => PetanqueBallRepository(ref.watch(appDatabaseProvider)),
);

final petanqueBallPhotoRepositoryProvider =
    Provider<PetanqueBallPhotoRepository>(
      (ref) => PetanqueBallPhotoRepository(ref.watch(appDatabaseProvider)),
    );

final bracketGeneratorProvider = Provider<BracketGenerator>(
  (ref) => const BracketGenerator(),
);

final teamGeneratorProvider = Provider<TeamGenerator>(
  (ref) => const TeamGenerator(),
);

final repechageServiceProvider = Provider<RepechageService>(
  (ref) => const RepechageService(),
);

final tournamentProgressionServiceProvider =
    Provider<TournamentProgressionService>(
      (ref) => TournamentProgressionService(
        matchRepository: ref.watch(matchRepositoryProvider),
        playoffRepository: ref.watch(repechagePlayoffRepositoryProvider),
        repechageService: ref.watch(repechageServiceProvider),
      ),
    );

final matchScorerProvider = Provider<MatchScorer>((ref) => const MatchScorer());

final matchEndRecorderProvider = Provider<MatchEndRecorder>(
  (ref) => MatchEndRecorder(
    transactions: ref.watch(transactionRunnerProvider),
    matchRepository: ref.watch(matchRepositoryProvider),
    endRepository: ref.watch(endRepositoryProvider),
    scorer: ref.watch(matchScorerProvider),
    newId: const Uuid().v4,
    now: DateTime.now,
  ),
);

final bracketLoaderProvider = Provider<BracketLoader>(
  (ref) => BracketLoader(
    teamRepository: ref.watch(teamRepositoryProvider),
    matchRepository: ref.watch(matchRepositoryProvider),
    playoffRepository: ref.watch(repechagePlayoffRepositoryProvider),
    progressionService: ref.watch(tournamentProgressionServiceProvider),
    bracketGenerator: ref.watch(bracketGeneratorProvider),
  ),
);

final rosterServiceProvider = Provider<RosterService>(
  (ref) => RosterService(
    playerRepository: ref.watch(playerRepositoryProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
    ballRepository: ref.watch(petanqueBallRepositoryProvider),
    teamGenerator: ref.watch(teamGeneratorProvider),
    newId: const Uuid().v4,
  ),
);

final predefinedTeamsServiceProvider = Provider<PredefinedTeamsService>(
  (ref) => PredefinedTeamsService(
    transactions: ref.watch(transactionRunnerProvider),
    playerRepository: ref.watch(playerRepositoryProvider),
    teamRepository: ref.watch(teamRepositoryProvider),
    newId: const Uuid().v4,
  ),
);
