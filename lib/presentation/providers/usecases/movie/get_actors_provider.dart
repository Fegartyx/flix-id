import 'package:flix_id/domain/usecases/movie/get_movie_actors/get_movie_actor.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../repositories/movie_repository/movie_repository_provider.dart';

part 'get_actors_provider.g.dart';

@riverpod
GetMovieActor getMovieActor(GetMovieActorRef ref) {
  return GetMovieActor(movieRepository: ref.watch(movieRepositoryProvider));
}
