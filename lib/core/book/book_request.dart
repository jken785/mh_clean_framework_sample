import 'package:clean_framework/clean_framework.dart';

abstract class BookRequest extends Request {
  Map<String, dynamic> get queryParams => {};
}

abstract class GetBookRequest extends BookRequest {
  String get resource;
}
