import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mh_clean_framework_sample/features/home/domain/home_entity.dart';
import 'package:mh_clean_framework_sample/features/home/domain/home_ui_output.dart';
import 'package:mh_clean_framework_sample/features/home/domain/home_use_case.dart';
import 'package:mh_clean_framework_sample/features/home/presentation/home_presenter.dart';
import 'package:mh_clean_framework_sample/features/home/presentation/home_view_model.dart';
import 'package:mh_clean_framework_sample/providers.dart';
import '../../../test_constants.dart';

void main() {
  group('HomePresenter tests |', () {
    presenterTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'creates proper view model',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          books: testBooks,
        );
      },
      expect: () => [
        isA<HomeViewModel>().having((vm) => vm.books, 'books', []),
        isA<HomeViewModel>().having(
          (vm) => vm.books.map((p) => p.title),
          'book titles',
          ['Fantastic Mr. Fox', 'Fahrenheit 451'],
        ),
      ],
    );

    presenterTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'shows success snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          isRefresh: true,
          status: HomeStatus.loaded,
        );
      },
      verify: (tester) {
        expect(
          find.text('Refreshed trending books successfully!'),
          findsOneWidget,
        );
      },
    );

    presenterTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'shows failure snack bar if refreshing fails',
      create: (builder) => HomePresenter(builder: builder),
      overrides: [
        homeUseCaseProvider.overrideWith(HomeUseCaseFake()),
      ],
      setup: (useCase) {
        useCase.entity = useCase.entity.copyWith(
          isRefresh: true,
          status: HomeStatus.failed,
        );
      },
      verify: (tester) {
        expect(
          find.text("Sorry, we couldn't refresh trending books."),
          findsOneWidget,
        );
      },
    );

    presenterCallbackTest<HomeViewModel, HomeUIOutput, HomeUseCase>(
      'calls refresh books in use case',
      useCase: HomeUseCaseMock(),
      create: (builder) => HomePresenter(builder: builder),
      setup: (useCase) {
        when(() => useCase.fetchBooks(isRefresh: true))
            .thenAnswer((_) async {});
      },
      verify: (useCase, vm) {
        vm.onRefresh();

        verify(() => useCase.fetchBooks(isRefresh: true));
      },
    );
  });
}

class HomeUseCaseFake extends HomeUseCase {
  @override
  Future<void> fetchBooks({bool isRefresh = false}) async {}
}

class HomeUseCaseMock extends UseCaseMock<HomeEntity> implements HomeUseCase {
  HomeUseCaseMock()
      : super(
          entity: const HomeEntity(),
          transformers: [HomeUIOutputTransformer()],
        );
}
