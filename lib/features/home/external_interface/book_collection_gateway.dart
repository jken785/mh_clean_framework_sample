// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:clean_framework/clean_framework.dart';

import '../../../core/book/book_request.dart';
import '../../../core/book/book_success_response.dart';
import '../models/book_model.dart';

class BookCollectionGateway extends Gateway<BookCollectionGatewayOutput,
    BookCollectionRequest, BookSuccessResponse, BookCollectionSuccessInput> {
  @override
  BookCollectionRequest buildRequest(BookCollectionGatewayOutput output) {
    return BookCollectionRequest();
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  BookCollectionSuccessInput onSuccess(BookSuccessResponse response) {
    final deserializer = Deserializer(response.data);

    return BookCollectionSuccessInput(
      books: deserializer.getList(
        'works',
        converter: BookModel.fromJson,
      ),
    );
  }
}

class BookCollectionGatewayOutput extends Output {
  @override
  List<Object?> get props => [];
}

class BookCollectionSuccessInput extends SuccessInput {
  const BookCollectionSuccessInput({required this.books});

  final List<BookModel> books;
}

class BookCollectionRequest extends GetBookRequest {
  @override
  String get resource => 'trending/yearly.json';

  @override
  Map<String, dynamic> get queryParams => {'limit': 25};
}
