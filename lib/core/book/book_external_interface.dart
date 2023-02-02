import 'package:clean_framework/clean_framework.dart';
import 'package:dio/dio.dart';

import 'book_request.dart';
import 'book_success_response.dart';

class BookExternalInterface
    extends ExternalInterface<BookRequest, BookSuccessResponse> {
  BookExternalInterface({
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(baseUrl: 'https://openlibrary.org/'));

  final Dio _dio;

  @override
  void handleRequest() {
    on<GetBookRequest>(
      (request, send) async {
        final response = await _dio.get<Map<String, dynamic>>(
          request.resource,
          queryParameters: request.queryParams,
        );

        final data = response.data!;

        send(BookSuccessResponse(data: data));
      },
    );
  }

  @override
  FailureResponse onError(Object error) {
    return UnknownFailureResponse(error);
  }
}
