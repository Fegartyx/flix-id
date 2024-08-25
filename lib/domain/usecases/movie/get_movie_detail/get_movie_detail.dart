import 'package:flix_id/domain/entities/movie/detail/movie_detail.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:flix_id/domain/usecases/movie/get_movie_detail/get_movie_detail_param.dart';
import 'package:flix_id/domain/usecases/usecase.dart';

import '../../../../data/repositories/movie_repository.dart';

class GetMovieDetail
    implements UseCase<Result<MovieDetail>, GetMovieDetailParam> {
  final MovieRepository _movieRepository;

  GetMovieDetail({required MovieRepository movieRepository})
      : _movieRepository = movieRepository;
  @override
  Future<Result<MovieDetail>> call(GetMovieDetailParam params) async {
    final movieDetailResult =
        await _movieRepository.getDetail(id: params.movie.id);

    return switch (movieDetailResult) {
      Success(value: final movieDetail) => Result.success(movieDetail),
      Failed(:final message) => Result.failed(message),
    };
  }
}
