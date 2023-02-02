import 'package:clean_framework/clean_framework.dart';

typedef StarsToRatingCount = Map<RatingStar, int>;

enum RatingStar {
  one(1),
  two(2),
  three(3),
  four(4),
  five(5);

  const RatingStar(this.value);

  final int value;
}

class BookRatingsModel {
  final double averageRating;
  final int count;
  final StarsToRatingCount starsToRatingCount;

  final bool isEmpty;

  const BookRatingsModel({
    required this.averageRating,
    required this.count,
    required this.starsToRatingCount,
    this.isEmpty = false,
  });

  const BookRatingsModel.empty()
      : averageRating = 0,
        count = 0,
        starsToRatingCount = const {},
        isEmpty = true;

  factory BookRatingsModel.fromJson(Map<String, dynamic> json) {
    final deserializer = Deserializer(json);

    final summaryDeserializer = Deserializer(deserializer.getMap('summary'));
    final countsDeserializer = Deserializer(deserializer.getMap('counts'));

    final StarsToRatingCount starsToRatingCount = {
      for (final ratingStar in RatingStar.values)
        ratingStar: countsDeserializer.getInt(ratingStar.value.toString())
    };

    return BookRatingsModel(
      averageRating: summaryDeserializer.getDouble('average'),
      count: summaryDeserializer.getInt('count'),
      starsToRatingCount: starsToRatingCount,
    );
  }

  @override
  String toString() =>
      'BookRatingsModel(averageRating: $averageRating, count: $count, starsToRatingCount: $starsToRatingCount)';

  @override
  bool operator ==(covariant BookRatingsModel other) =>
      identical(this, other) ||
      runtimeType == other.runtimeType &&
          other.averageRating == averageRating &&
          other.count == count &&
          other.starsToRatingCount == starsToRatingCount &&
          other.isEmpty == isEmpty;

  @override
  int get hashCode =>
      Object.hash(averageRating, count, starsToRatingCount, isEmpty);
}
