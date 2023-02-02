import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:mh_clean_framework_sample/core/book/book_external_interface.dart';
import 'package:mh_clean_framework_sample/core/book/book_request.dart';

void main() {
  var interface = BookExternalInterface();

  group('BookExternalInterface tests |', () {
    test('get request success', () async {
      final dio = DioMock();

      when(
        () => dio.get<Map<String, dynamic>>(
          'books',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'title': 'Fantastic Mr. Fox'},
          requestOptions: RequestOptions(path: 'books'),
        ),
      );

      interface = BookExternalInterface(dio: dio);

      final result = await interface.request(TestBookRequest());

      expect(result.isRight, isTrue);
      expect(result.right.data, equals({'title': 'Fantastic Mr. Fox'}));
    });

    test('get request failure', () async {
      final dio = DioMock();

      when(
        () => dio.get<Map<String, dynamic>>(
          'books',
          queryParameters: any(named: 'queryParameters'),
        ),
      ).thenThrow(const HttpException('No Internet'));

      interface = BookExternalInterface(dio: dio);

      final result = await interface.request(TestBookRequest());

      expect(result.isLeft, isTrue);
      expect(
        result.left.message,
        equals(const HttpException('No Internet').toString()),
      );
    });
  });
}

class TestBookRequest extends GetBookRequest {
  @override
  String get resource => 'books';
}

class DioMock extends Mock implements Dio {}
