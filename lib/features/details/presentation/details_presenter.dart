import 'package:flutter/material.dart';

import 'package:clean_framework/clean_framework.dart';

import '../../../providers.dart';
import '../domain/details_entity.dart';
import '../domain/details_ui_output.dart';
import '../domain/details_use_case.dart';
import 'details_view_model.dart';

class DetailsPresenter
    extends Presenter<DetailsViewModel, DetailsUIOutput, DetailsUseCase> {
  DetailsPresenter({
    super.key,
    required super.builder,
    required this.bookId,
  }) : super(provider: detailsUseCaseProvider);

  final String bookId;

  @override
  void onLayoutReady(BuildContext context, DetailsUseCase useCase) {
    useCase.fetchBookDetails(bookId);
  }

  @override
  DetailsViewModel createViewModel(
    DetailsUseCase useCase,
    DetailsUIOutput output,
  ) {
    return DetailsViewModel(
      title: output.details.title,
      subtitle: output.details.subtitle,
      description: output.details.description,
      ratingAverage: output.ratings.averageRating,
      ratingCount: output.ratings.count,
      starsToRatingCount: output.ratings.starsToRatingCount,
      isLoading: output.status == DetailsStatus.loading,
      hasFailedLoading: output.status == DetailsStatus.failed,
      onRetry: () => useCase.fetchBookDetails(bookId),
    );
  }
}
