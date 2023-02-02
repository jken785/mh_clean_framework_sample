import 'package:clean_framework/clean_framework.dart';

import '../models/book_model.dart';

enum HomeStatus { initial, loading, loaded, failed }

class HomeEntity extends Entity {
  const HomeEntity({
    this.books = const [],
    this.status = HomeStatus.initial,
    this.isRefresh = false,
  });

  final List<BookModel> books;

  final HomeStatus status;
  final bool isRefresh;

  @override
  List<Object?> get props {
    return [books, status, isRefresh];
  }

  @override
  HomeEntity copyWith({
    List<BookModel>? books,
    HomeStatus? status,
    bool? isRefresh,
  }) {
    return HomeEntity(
      books: books ?? this.books,
      status: status ?? this.status,
      isRefresh: isRefresh ?? this.isRefresh,
    );
  }
}
