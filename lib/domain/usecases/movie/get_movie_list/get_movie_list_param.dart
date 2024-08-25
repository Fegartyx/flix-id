enum MovieListCategories { nowPlaying, upcoming }

class GetMovieListParam {
  final MovieListCategories category;
  final int page;

  GetMovieListParam({required this.category, this.page = 1});
}
