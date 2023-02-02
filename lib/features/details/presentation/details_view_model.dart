import 'dart:ui';

import 'package:clean_framework/clean_framework.dart';

import '../models/book_ratings_model.dart';

class DetailsViewModel extends ViewModel {
  const DetailsViewModel({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.ratingAverage,
    required this.ratingCount,
    required this.starsToRatingCount,
    required this.isLoading,
    required this.hasFailedLoading,
    required this.onRetry,
  });

  final String title;
  final String subtitle;
  final String description;

  final double ratingAverage;
  final int ratingCount;
  final StarsToRatingCount starsToRatingCount;

  final bool isLoading;
  final bool hasFailedLoading;
  final VoidCallback onRetry;

  @override
  List<Object?> get props {
    return [
      title,
      subtitle,
      description,
      ratingAverage,
      ratingCount,
      starsToRatingCount
    ];
  }
}
