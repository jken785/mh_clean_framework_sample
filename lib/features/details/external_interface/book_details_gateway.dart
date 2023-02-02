import 'package:clean_framework/clean_framework.dart';

import '../../../core/book/book_request.dart';
import '../../../core/book/book_success_response.dart';
import '../models/book_details_model.dart';

class BookDetailsGateway extends Gateway<BookDetailsGatewayOutput,
    BookDetailsRequest, BookSuccessResponse, BookDetailsSuccessInput> {
  @override
  BookDetailsRequest buildRequest(BookDetailsGatewayOutput output) {
    return BookDetailsRequest(bookId: output.bookId);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  BookDetailsSuccessInput onSuccess(BookSuccessResponse response) {
    return BookDetailsSuccessInput(
      details: BookDetailsModel.fromJson(response.data),
    );
  }
}

class BookDetailsGatewayOutput extends Output {
  const BookDetailsGatewayOutput({required this.bookId});

  final String bookId;

  @override
  List<Object?> get props => [bookId];
}

class BookDetailsSuccessInput extends SuccessInput {
  const BookDetailsSuccessInput({required this.details});

  final BookDetailsModel details;
}

class BookDetailsRequest extends GetBookRequest {
  BookDetailsRequest({required this.bookId});

  final String bookId;

  @override
  String get resource => '$bookId.json';
}
