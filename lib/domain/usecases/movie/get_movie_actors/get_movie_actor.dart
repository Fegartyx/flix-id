import 'package:flix_id/domain/entities/actor/actor.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/usecases/movie/get_movie_actors/get_movie_actor_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

import '../../../../data/repositories/movie_repository.dart';

class GetMovieActor
    implements UseCase<Result<List<Actor>>, GetMovieActorParam> {
  final MovieRepository _movieRepository;

  GetMovieActor({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;
  @override
  Future<Result<List<Actor>>> call(GetMovieActorParam params) async {
    final movieActorResult =
        await _movieRepository.getActors(id: params.movieId);

    return switch (movieActorResult) {
      Success(value: final movieActor) => Result.success(movieActor),
      Failed(:final message) => Result.failed(message),
    };
  }
}
