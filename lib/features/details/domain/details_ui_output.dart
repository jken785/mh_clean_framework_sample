import 'package:clean_framework/clean_framework.dart';

import '../models/book_details_model.dart';
import '../models/book_ratings_model.dart';
import 'details_entity.dart';

class DetailsUIOutput extends Output {
  const DetailsUIOutput({
    required this.details,
    required this.ratings,
    required this.status,
  });

  final BookDetailsModel details;
  final BookRatingsModel ratings;
  final DetailsStatus status;

  @override
  List<Object?> get props => [details, ratings, status];
}
