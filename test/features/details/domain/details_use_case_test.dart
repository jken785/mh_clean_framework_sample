import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/features/details/domain/details_entity.dart';
import 'package:mh_clean_framework_sample/features/details/domain/details_ui_output.dart';
import 'package:mh_clean_framework_sample/features/details/domain/details_use_case.dart';
import 'package:mh_clean_framework_sample/features/details/external_interface/book_details_gateway.dart';
import 'package:mh_clean_framework_sample/features/details/external_interface/book_ratings_gateway.dart';
import 'package:mh_clean_framework_sample/features/details/models/book_details_model.dart';
import 'package:mh_clean_framework_sample/features/details/models/book_ratings_model.dart';
import 'package:mh_clean_framework_sample/providers.dart';
import '../../../test_constants.dart';

void main() {
  group('DetailsUseCase tests |', () {
    useCaseTest<DetailsUseCase, DetailsEntity, DetailsUIOutput>(
      'fetches book details',
      provider: detailsUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase);

        useCase.fetchBookDetails(testBooks.first.key);
      },
      expect: () => const [
        DetailsUIOutput(
          details: kTestBookDetails,
          ratings: BookRatingsModel.empty(),
          status: DetailsStatus.loading,
        ),
        DetailsUIOutput(
          details: kTestBookDetails,
          ratings: kTestBookRatings,
          status: DetailsStatus.loaded,
        ),
      ],
      verify: (useCase) {
        expect(
          useCase.entity,
          const DetailsEntity(
            details: kTestBookDetails,
            ratings: kTestBookRatings,
            detailsStatus: DetailsStatus.loaded,
            ratingsStatus: DetailsStatus.loaded,
          ),
        );
      },
    );

    useCaseTest<DetailsUseCase, DetailsEntity, DetailsUIOutput>(
      'fetches book details; details failure',
      provider: detailsUseCaseProvider,
      execute: (useCase) {
        _mockDetailsFailure(useCase);

        useCase.fetchBookDetails(testBooks.first.key);
      },
      expect: () => const [
        DetailsUIOutput(
          details: BookDetailsModel.empty(),
          ratings: BookRatingsModel.empty(),
          status: DetailsStatus.failed,
        ),
        DetailsUIOutput(
          details: BookDetailsModel.empty(),
          ratings: kTestBookRatings,
          status: DetailsStatus.failed,
        ),
      ],
      verify: (useCase) {
        expect(
          useCase.entity,
          const DetailsEntity(
            details: BookDetailsModel.empty(),
            ratings: kTestBookRatings,
            detailsStatus: DetailsStatus.failed,
            ratingsStatus: DetailsStatus.loaded,
          ),
        );
      },
    );

    useCaseTest<DetailsUseCase, DetailsEntity, DetailsUIOutput>(
      'fetches book details; ratings failure',
      provider: detailsUseCaseProvider,
      execute: (useCase) {
        _mockRatingsFailure(useCase);

        useCase.fetchBookDetails(testBooks.first.key);
      },
      expect: () => const [
        DetailsUIOutput(
          details: kTestBookDetails,
          ratings: BookRatingsModel.empty(),
          status: DetailsStatus.loading,
        ),
        DetailsUIOutput(
          details: kTestBookDetails,
          ratings: BookRatingsModel.empty(),
          status: DetailsStatus.failed,
        ),
      ],
      verify: (useCase) {
        expect(
          useCase.entity,
          const DetailsEntity(
            details: kTestBookDetails,
            ratings: BookRatingsModel.empty(),
            detailsStatus: DetailsStatus.loaded,
            ratingsStatus: DetailsStatus.failed,
          ),
        );
      },
    );

    useCaseTest<DetailsUseCase, DetailsEntity, DetailsUIOutput>(
      'fetches book details; details and ratings failures',
      provider: detailsUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        useCase.fetchBookDetails(testBooks.first.key);
      },
      expect: () => const [
        DetailsUIOutput(
          details: BookDetailsModel.empty(),
          ratings: BookRatingsModel.empty(),
          status: DetailsStatus.failed,
        ),
        DetailsUIOutput(
          details: BookDetailsModel.empty(),
          ratings: BookRatingsModel.empty(),
          status: DetailsStatus.failed,
        ),
      ],
      verify: (useCase) {
        expect(
          useCase.entity,
          const DetailsEntity(
            details: BookDetailsModel.empty(),
            ratings: BookRatingsModel.empty(),
            detailsStatus: DetailsStatus.failed,
            ratingsStatus: DetailsStatus.failed,
          ),
        );
      },
    );
  });
}

void _mockSuccess(DetailsUseCase useCase) {
  __detailsSuccess(useCase);

  __ratingsSuccess(useCase);
}

void _mockFailure(DetailsUseCase useCase) {
  __detailsFailure(useCase);

  __ratingsFailure(useCase);
}

void _mockDetailsFailure(DetailsUseCase useCase) {
  __detailsFailure(useCase);

  __ratingsSuccess(useCase);
}

void _mockRatingsFailure(DetailsUseCase useCase) {
  __detailsSuccess(useCase);

  __ratingsFailure(useCase);
}

void __detailsSuccess(DetailsUseCase useCase) {
  useCase.subscribe<BookDetailsGatewayOutput, BookDetailsSuccessInput>(
    (output) {
      return const Either.right(
        BookDetailsSuccessInput(details: kTestBookDetails),
      );
    },
  );
}

void __ratingsSuccess(DetailsUseCase useCase) {
  useCase.subscribe<BookRatingsGatewayOutput, BookRatingsSuccessInput>(
    (output) {
      return const Either.right(
        BookRatingsSuccessInput(ratings: kTestBookRatings),
      );
    },
  );
}

void __detailsFailure(DetailsUseCase useCase) {
  useCase.subscribe<BookDetailsGatewayOutput, BookDetailsSuccessInput>(
    (_) async {
      return const Either.left(FailureInput(message: 'No Internet'));
    },
  );
}

void __ratingsFailure(DetailsUseCase useCase) {
  useCase.subscribe<BookRatingsGatewayOutput, BookRatingsSuccessInput>(
    (_) async {
      return const Either.left(FailureInput(message: 'No Internet'));
    },
  );
}
