import 'package:clean_framework/clean_framework.dart';

import '../models/book_model.dart';
import 'home_entity.dart';

class HomeUIOutput extends Output {
  const HomeUIOutput({
    required this.books,
    required this.status,
    required this.isRefresh,
  });

  final List<BookModel> books;
  final HomeStatus status;
  final bool isRefresh;

  @override
  List<Object?> get props => [books, status, isRefresh];
}
