import 'package:clean_framework/clean_framework.dart';

class BookModel {
  const BookModel({
    required this.key,
    required this.title,
    required this.authors,
    required this.coverId,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);

    final authorKeys = deserializer.getSimpleList<String>('author_key');
    final authorNames = deserializer.getSimpleList<String>('author_name');

    final List<AuthorModel> authors = [];
    authorKeys.asMap().forEach(
      (index, key) {
        final author = AuthorModel(key: key, name: authorNames[index]);

        authors.add(author);
      },
    );

    return BookModel(
      key: deserializer.getString('key'),
      title: deserializer.getString('title'),
      authors: authors,
      coverId: deserializer.getInt('cover_i'),
    );
  }

  final String key;
  final String title;
  final List<AuthorModel> authors;
  final int coverId;

  String get authorsString => authors.map((a) => a.name).join(', ');

  @override
  bool operator ==(covariant BookModel other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          key == other.key &&
          title == other.title &&
          authors == other.authors &&
          coverId == other.coverId;

  @override
  int get hashCode => Object.hash(key, title, authors, coverId);
}

class AuthorModel {
  const AuthorModel({
    required this.key,
    required this.name,
  });

  final String key;
  final String name;

  @override
  bool operator ==(covariant AuthorModel other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          key == other.key &&
          name == other.name;

  @override
  int get hashCode => Object.hash(key, name);
}
