import 'package:clean_framework/clean_framework.dart';

import '../../../core/book/book_request.dart';
import '../../../core/book/book_success_response.dart';
import '../models/book_ratings_model.dart';

class BookRatingsGateway extends Gateway<BookRatingsGatewayOutput,
    BookRatingsRequest, BookSuccessResponse, BookRatingsSuccessInput> {
  @override
  BookRatingsRequest buildRequest(BookRatingsGatewayOutput output) {
    return BookRatingsRequest(bookId: output.bookId);
  }

  @override
  FailureInput onFailure(FailureResponse failureResponse) {
    return FailureInput(message: failureResponse.message);
  }

  @override
  BookRatingsSuccessInput onSuccess(BookSuccessResponse response) {
    return BookRatingsSuccessInput(
      ratings: BookRatingsModel.fromJson(response.data),
    );
  }
}

class BookRatingsGatewayOutput extends Output {
  const BookRatingsGatewayOutput({required this.bookId});

  final String bookId;

  @override
  List<Object?> get props => [bookId];
}

class BookRatingsSuccessInput extends SuccessInput {
  const BookRatingsSuccessInput({required this.ratings});

  final BookRatingsModel ratings;
}

class BookRatingsRequest extends GetBookRequest {
  BookRatingsRequest({required this.bookId});

  final String bookId;

  @override
  String get resource => '$bookId/ratings.json';
}
