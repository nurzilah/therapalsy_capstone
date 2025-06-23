class Article {
  final String id;
  final String title;
  final String definisi;

  Article({
    required this.id,
    required this.title,
    required this.definisi,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['_id']?['\$oid'] ?? '', // karena dari MongoDB
      title: json['title'] ?? '',
      definisi: json['definisi'] ?? '',
    );
  }
}
