import 'package:clean_framework/clean_framework.dart';

class BookSuccessResponse extends SuccessResponse {
  const BookSuccessResponse({required this.data});

  final Map<String, dynamic> data;
}
