class Book {
  int? id;
  String? name;
  String? author;
  String? cover_image;
  String? description;
  String? category;
  String? language;
  String? description_arabic;
  String? category_arabic;
  String? language_arabic;
  String? pdf;

  int? pages;

  Book({
    this.id,
    this.name,
    this.cover_image,
    this.description,
    this.category,
    this.author,
    this.language,
    this.description_arabic,
    this.category_arabic,
     this.language_arabic,
    this.pages,
    this.pdf,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'] as int?,
      name: json['name'] as String?,
      cover_image: json['cover_image'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      language: json['language'] as String?,
      description_arabic: json['description_arabic'] as String?,
      category_arabic: json['category_arabic'] as String?,
      language_arabic: json['language_arabic'] as String?,
      author: json['author'] as String?,
      pages: json['pages'] as int?,
      pdf: json['pdf'] as String?,
    );
  }
}
