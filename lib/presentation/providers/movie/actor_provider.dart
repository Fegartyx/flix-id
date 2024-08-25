import 'package:flix_id/domain/entities/actor/actor.dart';
import 'package:flix_id/domain/usecases/movie/get_movie_actors/get_movie_actor.dart';
import 'package:flix_id/domain/usecases/movie/get_movie_actors/get_movie_actor_param.dart';
import 'package:flix_id/presentation/providers/usecases/movie/get_actors_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/result/result.dart';

part 'actor_provider.g.dart';

@riverpod
Future<List<Actor>> actors(ActorsRef ref, {required int movieId}) async {
  GetMovieActor getActors = ref.read(getMovieActorProvider);

  final actorsResult = await getActors(GetMovieActorParam(movieId));

  return switch (actorsResult) {
    Success(value: final actors) => actors,
    Failed(message: _) => const [],
  };
}
