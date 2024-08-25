import 'package:flix_id/data/repositories/movie_repository.dart';
import 'package:flix_id/domain/entities/actor/actor.dart';
import 'package:flix_id/domain/entities/movie/detail/movie_detail.dart';
import 'package:flix_id/domain/entities/movie/movie.dart';
import 'package:flix_id/domain/entities/result/result.dart';
import 'package:dio/dio.dart';

class TmdbMovieRepository implements MovieRepository {
  final Dio? _dio;
  final String _accessToken =
      "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjlkODUxNTk4ZDE0YTgwYzVjNDViN2YzNTdiNjZiNyIsIm5iZiI6MTcyMTM3MjQ2MS4zNDUxNCwic3ViIjoiNjQxYTlmNzdhM2U0YmEwMDgzMGFkYzg2Iiwic2NvcGVzIjpbImFwaV9yZWFkIl0sInZlcnNpb24iOjF9.1H4Nxt-85NfFdTL_uZ7_CNmqNC9yuVjIYdhwIkYCJbA";
  late final options = Options(headers: {
    "Authorization": "Bearer $_accessToken",
    "accept": "application/json",
  });
  TmdbMovieRepository({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<Result<List<Actor>>> getActors({required int id}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$id/credits?language=en-US',
        options: options,
      );
      final results = List<Map<String, dynamic>>.from(response.data['cast']);

      return Result.success(results.map((e) => Actor.fromJSON(e)).toList());
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }

  @override
  Future<Result<MovieDetail>> getDetail({required int id}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$id?language=en-US',
        options: options,
      );
      return Result.success(MovieDetail.fromJSON(response.data));
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }

  @override
  Future<Result<List<Movie>>> getMovies({int page = 1}) {
    // TODO: implement getMovies
    throw UnimplementedError();
  }

  @override
  Future<Result<List<Movie>>> getUpcoming({int page = 1}) async =>
      _getMovies(_MovieCategory.upcoming.toString(), page: page);

  @override
  Future<Result<List<Movie>>> getNowPlaying({int page = 1}) =>
      _getMovies(_MovieCategory.nowPlaying.toString(), page: page);

  Future<Result<List<Movie>>> _getMovies(String category,
      {int page = 1}) async {
    try {
      final response = await _dio!.get(
        'https://api.themoviedb.org/3/movie/$category?language=en-US&page=$page',
        options: options,
      );
      final results = List<Map<String, dynamic>>.from(response.data['results']);

      return Result.success(results.map((e) => Movie.fromJSON(e)).toList());
    } on DioException catch (e) {
      return Result.failed("${e.message}");
    }
  }
}

enum _MovieCategory {
  nowPlaying('now_playing'),
  upcoming('upcoming');

  final String _instring;
  const _MovieCategory(String inString) : _instring = inString;

  @override
  String toString() => _instring;
}
