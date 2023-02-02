import 'package:clean_framework/clean_framework.dart';

import '../external_interface/book_details_gateway.dart';
import '../external_interface/book_ratings_gateway.dart';
import 'details_entity.dart';
import 'details_ui_output.dart';

class DetailsUseCase extends UseCase<DetailsEntity> {
  DetailsUseCase()
      : super(
          entity: const DetailsEntity(),
          transformers: [DetailsUIOutputTransformer()],
        );

  void fetchBookDetails(String bookId) {
    request<BookDetailsGatewayOutput, BookDetailsSuccessInput>(
      BookDetailsGatewayOutput(bookId: bookId),
      onSuccess: (success) {
        return entity.copyWith(
          details: success.details,
          detailsStatus: DetailsStatus.loaded,
        );
      },
      onFailure: (failure) =>
          entity.copyWith(detailsStatus: DetailsStatus.failed),
    );

    request<BookRatingsGatewayOutput, BookRatingsSuccessInput>(
      BookRatingsGatewayOutput(bookId: bookId),
      onSuccess: (success) {
        return entity.copyWith(
          ratings: success.ratings,
          ratingsStatus: DetailsStatus.loaded,
        );
      },
      onFailure: (failure) =>
          entity.copyWith(ratingsStatus: DetailsStatus.failed),
    );
  }
}

class DetailsUIOutputTransformer
    extends OutputTransformer<DetailsEntity, DetailsUIOutput> {
  @override
  DetailsUIOutput transform(DetailsEntity entity) {
    final status =
        DetailsStatus.merge(entity.detailsStatus, entity.ratingsStatus);

    return DetailsUIOutput(
      details: entity.details,
      ratings: entity.ratings,
      status: status,
    );
  }
}
