class Movie {
  final int id;
  final String title;
  final double voteAverage;
  final String releaseDate;
  final String overview;
  final String posterPath;

  Movie({
    required this.id,
    required this.title,
    required this.voteAverage,
    required this.releaseDate,
    required this.overview,
    required this.posterPath,
  });

  factory Movie.fromJson(Map<String, dynamic> parsedJson) {
    return Movie(
      id: parsedJson['id'],
      title: parsedJson['title'],
      voteAverage: parsedJson['vote_average'] * 1.0,
      releaseDate: parsedJson['release_date'],
      overview: parsedJson['overview'],
      posterPath: parsedJson['poster_path'],
    );
  }
}
