import 'package:clean_framework/clean_framework.dart';

import '../external_interface/book_collection_gateway.dart';
import 'home_entity.dart';
import 'home_ui_output.dart';

class HomeUseCase extends UseCase<HomeEntity> {
  HomeUseCase()
      : super(
          entity: const HomeEntity(),
          transformers: [
            HomeUIOutputTransformer(),
          ],
        );

  Future<void> fetchBooks({bool isRefresh = false}) async {
    if (!isRefresh) {
      entity = entity.copyWith(status: HomeStatus.loading);
    }

    await request<BookCollectionGatewayOutput, BookCollectionSuccessInput>(
      BookCollectionGatewayOutput(),
      onSuccess: (success) {
        return entity.copyWith(
          books: success.books,
          status: HomeStatus.loaded,
          isRefresh: isRefresh,
        );
      },
      onFailure: (failure) {
        return entity.copyWith(
          status: HomeStatus.failed,
          isRefresh: isRefresh,
        );
      },
    );

    if (isRefresh) {
      entity = entity.copyWith(isRefresh: false, status: HomeStatus.loaded);
    }
  }
}

class BookSearchInput extends Input {
  const BookSearchInput({required this.query});

  final String query;
}

class HomeUIOutputTransformer
    extends OutputTransformer<HomeEntity, HomeUIOutput> {
  @override
  HomeUIOutput transform(HomeEntity entity) {
    return HomeUIOutput(
      books: entity.books,
      status: entity.status,
      isRefresh: entity.isRefresh,
    );
  }
}
