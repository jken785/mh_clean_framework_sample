import 'package:clean_framework/clean_framework.dart';

class BookDetailsModel {
  final String title;
  final String subtitle;
  final String description;

  final bool isEmpty;

  const BookDetailsModel({
    required this.title,
    required this.subtitle,
    required this.description,
    this.isEmpty = false,
  });

  const BookDetailsModel.empty()
      : title = '',
        subtitle = '',
        description = '',
        isEmpty = true;

  factory BookDetailsModel.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);

    String description = deserializer.getString('description');
    if (description.isEmpty) {
      final descriptionDeserializer =
          Deserializer(deserializer.getMap('description'));

      description = descriptionDeserializer.getString('value');
    }

    return BookDetailsModel(
      title: deserializer.getString('title'),
      subtitle: deserializer.getString('subtitle'),
      description: description,
    );
  }

  @override
  String toString() =>
      'BookDetailsModel(title: $title, subtitle: $subtitle, description: $description)';

  @override
  bool operator ==(covariant BookDetailsModel other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other.title == title &&
          other.subtitle == subtitle &&
          other.description == description &&
          other.isEmpty == isEmpty;

  @override
  int get hashCode => Object.hash(title, subtitle, description, isEmpty);
}
