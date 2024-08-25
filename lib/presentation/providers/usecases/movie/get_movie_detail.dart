import 'package:flix_id/domain/usecases/movie/get_movie_detail/get_movie_detail.dart';
import 'package:flix_id/presentation/providers/repositories/movie_repository/movie_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'get_movie_detail.g.dart';

@riverpod
GetMovieDetail getMovieDetail(GetMovieDetailRef ref) {
  return GetMovieDetail(movieRepository: ref.watch(movieRepositoryProvider));
}
