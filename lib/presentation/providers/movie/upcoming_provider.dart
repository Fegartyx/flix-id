import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../domain/entities/movie/movie.dart';
import '../../../domain/entities/result/result.dart';
import '../../../domain/usecases/movie/get_movie_list/get_movie_list.dart';
import '../../../domain/usecases/movie/get_movie_list/get_movie_list_param.dart';
import '../usecases/movie/get_movie_list_provider.dart';

part 'upcoming_provider.g.dart';

@Riverpod(keepAlive: true)
class Upcoming extends _$Upcoming {
  @override
  FutureOr<List<Movie>> build() => [];

  Future<void> getMovies({int page = 1}) async {
    state = const AsyncLoading();

    GetMovieList getMovieList = ref.read(getMovieListProvider);

    final result = await getMovieList(GetMovieListParam(
        page: page, category: MovieListCategories.upcoming));

    switch (result) {
      case Success(value: final movies):
        state = AsyncData(movies);
      case Failed(message: _):
        state = AsyncData(const []);
    }
  }
}
