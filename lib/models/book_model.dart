class Book {
  final String id;
  final String title;
  final String author;
  final String published;
  final String genre;
  final String format;
  final String isbn;
  final String description;
  final String bookImageUrl;
  final double ratingTotal;
  final int ratingCount;

  Book({
    this.id = '',
    this.title = '',
    this.published = '',
    this.author = '',
    this.genre = '',
    this.format = '',
    this.isbn = '',
    this.description = '',
    this.bookImageUrl = '',
    this.ratingTotal = 0.0,
    this.ratingCount = 0,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        id: json['id'] ?? '',
        title: json['title'] ?? '',
        author: json['author'] ?? '',
        published: json['published'] ?? '',
        genre: json['genre'] ?? '',
        format: json['format'] ?? '',
        isbn: json['isbn'] ?? '',
        description: json['description'] ?? '',
        bookImageUrl: json['bookImageUrl'] ?? '',
        ratingTotal: (json['ratingTotal'] ?? 0.0).toDouble(),
        ratingCount: json['ratingCount'] ?? 0,
      );
}
