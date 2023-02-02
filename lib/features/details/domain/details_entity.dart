import 'package:clean_framework/clean_framework.dart';

import '../models/book_details_model.dart';
import '../models/book_ratings_model.dart';

enum DetailsStatus {
  loading,
  loaded,
  failed;

  static DetailsStatus merge(DetailsStatus a, DetailsStatus b) {
    if (a == DetailsStatus.failed || b == DetailsStatus.failed) {
      return DetailsStatus.failed;
    }

    if (a == DetailsStatus.loading || b == DetailsStatus.loading) {
      return DetailsStatus.loading;
    }

    return DetailsStatus.loaded;
  }
}

class DetailsEntity extends Entity {
  const DetailsEntity({
    this.details = const BookDetailsModel.empty(),
    this.ratings = const BookRatingsModel.empty(),
    this.detailsStatus = DetailsStatus.loading,
    this.ratingsStatus = DetailsStatus.loading,
  });

  final BookDetailsModel details;
  final BookRatingsModel ratings;
  final DetailsStatus detailsStatus;
  final DetailsStatus ratingsStatus;

  @override
  List<Object?> get props => [details, ratings, detailsStatus, ratingsStatus];

  @override
  DetailsEntity copyWith({
    BookDetailsModel? details,
    BookRatingsModel? ratings,
    DetailsStatus? detailsStatus,
    DetailsStatus? ratingsStatus,
  }) {
    return DetailsEntity(
      details: details ?? this.details,
      ratings: ratings ?? this.ratings,
      detailsStatus: detailsStatus ?? this.detailsStatus,
      ratingsStatus: ratingsStatus ?? this.ratingsStatus,
    );
  }
}
