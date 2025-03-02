import 'package:movie_app/services/url.dart' as url;


class MovieModel {
  final int id;
  final String title;
  final double voteAverage;
  final String overview;
  final String posterPath;

  MovieModel({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.overview,
    required this.posterPath,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'],
      title: json['title'],
      voteAverage: (json['voteAverage'] ?? 0.0).toDouble(), // Pastikan konversi ke double
      overview: json['overview'] ?? '',
      posterPath: json['posterpath'] ?? '',
    );
  }
}
