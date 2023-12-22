class Movie {
  final String title;
  final Map<String, int> duration;
  final int year;
  final List<String> category;
  final List<String> production;
  final List<String> cast;
  final String description;
  final String picture;
  final String poster;
  final String scene;
  final String rating;

  Movie({
    required this.title,
    required this.duration,
    required this.year,
    required this.category,
    required this.production,
    required this.cast,
    required this.description,
    required this.picture,
    required this.poster,
    required this.scene,
    required this.rating,
  });

  static List<Movie> fromJsonList(List list) {
    return list.map((e) => Movie.fromJson(e)).toList();
  }

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['movie'],
      duration: Map<String, int>.from(json['duration']),
      year: json['year'],
      category: List<String>.from(json['category']),
      production: List<String>.from(json['prodution']),
      cast: List<String>.from(json['elenco']),
      description: json['description'],
      picture: json['picture'],
      poster: json['poster'],
      scene: json['sene'],
      rating: json['seal'],
    );
  }
}
