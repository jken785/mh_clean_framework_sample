import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/features/details/domain/details_ui_output.dart';
import 'package:mh_clean_framework_sample/features/details/domain/details_use_case.dart';
import 'package:mh_clean_framework_sample/features/details/presentation/details_presenter.dart';
import 'package:mh_clean_framework_sample/features/details/presentation/details_view_model.dart';
import 'package:mh_clean_framework_sample/providers.dart';
import '../../../test_constants.dart';

void main() {
  group('DetailsPresenter tests |', () {
    presenterTest<DetailsViewModel, DetailsUIOutput, DetailsUseCase>(
      'creates proper view model',
      create: (builder) => DetailsPresenter(
        builder: builder,
        bookId: testBooks.first.key,
      ),
      overrides: [
        detailsUseCaseProvider.overrideWith(DetailsUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity
            .copyWith(details: kTestBookDetails, ratings: kTestBookRatings);
      },
      expect: () => [
        isA<DetailsViewModel>().having(
          (vm) => vm.description,
          'description',
          '',
        ),
        isA<DetailsViewModel>().having(
          (vm) => vm.description,
          'description',
          kTestBookDetails.description,
        ),
      ],
    );
  });
}

class DetailsUseCaseFake extends DetailsUseCase {
  @override
  Future<void> fetchBookDetails(String bookId) async {}
}
