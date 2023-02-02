import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/features/home/domain/home_entity.dart';
import 'package:mh_clean_framework_sample/features/home/domain/home_ui_output.dart';
import 'package:mh_clean_framework_sample/features/home/domain/home_use_case.dart';
import 'package:mh_clean_framework_sample/features/home/external_interface/book_collection_gateway.dart';
import 'package:mh_clean_framework_sample/features/home/models/book_model.dart';
import 'package:mh_clean_framework_sample/providers.dart';

void main() {
  const books = [
    BookModel(
      key: 'OL45804W',
      title: 'Fantastic Mr. Fox',
      authors: [
        AuthorModel(key: 'OL34184A', name: 'Roald Dahl'),
      ],
      coverId: 10222599,
    ),
    BookModel(
      key: 'OL103123W',
      title: 'Fahrenheit 451',
      authors: [
        AuthorModel(key: 'OL24137A', name: 'Ray Bradbury'),
      ],
      coverId: 12817098,
    ),
  ];

  group('HomeUseCase test |', () {
    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'fetch Books; success',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase, books);

        return useCase.fetchBooks();
      },
      expect: () => const [
        HomeUIOutput(
          books: [],
          status: HomeStatus.loading,
          isRefresh: false,
        ),
        HomeUIOutput(
          books: books,
          status: HomeStatus.loaded,
          isRefresh: false,
        ),
      ],
      verify: (useCase) {
        expect(
          useCase.entity,
          const HomeEntity(
            books: books,
            status: HomeStatus.loaded,
            isRefresh: false,
          ),
        );
      },
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'refresh Books; success',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockSuccess(useCase, books);

        return useCase.fetchBooks(isRefresh: true);
      },
      expect: () {
        return const [
          HomeUIOutput(
            books: books,
            status: HomeStatus.loaded,
            isRefresh: true,
          ),
          HomeUIOutput(
            books: books,
            status: HomeStatus.loaded,
            isRefresh: false,
          ),
        ];
      },
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'fetch Books; failure',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        return useCase.fetchBooks();
      },
      expect: () => const [
        HomeUIOutput(
          books: [],
          status: HomeStatus.loading,
          isRefresh: false,
        ),
        HomeUIOutput(
          books: [],
          status: HomeStatus.failed,
          isRefresh: false,
        ),
      ],
    );

    useCaseTest<HomeUseCase, HomeEntity, HomeUIOutput>(
      'refresh Books; failure',
      provider: homeUseCaseProvider,
      execute: (useCase) {
        _mockFailure(useCase);

        return useCase.fetchBooks(isRefresh: true);
      },
      expect: () => const [
        HomeUIOutput(
          books: [],
          status: HomeStatus.failed,
          isRefresh: true,
        ),
        HomeUIOutput(
          books: [],
          status: HomeStatus.loaded,
          isRefresh: false,
        ),
      ],
    );
  });
}

void _mockSuccess(HomeUseCase useCase, List<BookModel> books) {
  useCase.subscribe<BookCollectionGatewayOutput, BookCollectionSuccessInput>(
    (_) async {
      return Either.right(BookCollectionSuccessInput(books: books));
    },
  );
}

void _mockFailure(HomeUseCase useCase) {
  useCase.subscribe<BookCollectionGatewayOutput, BookCollectionSuccessInput>(
    (_) async {
      return const Either.left(FailureInput(message: 'No Internet'));
    },
  );
}
