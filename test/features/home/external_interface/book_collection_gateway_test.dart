import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/features/home/external_interface/book_collection_gateway.dart';
import 'package:mh_clean_framework_sample/features/home/models/book_model.dart';
import '../../../test_constants.dart';

void main() {
  group('BookCollectionGateway tests |', () {
    test('verify request', () async {
      final gateway = BookCollectionGateway();
      final gatewayOutput = BookCollectionGatewayOutput();

      final request = gateway.buildRequest(gatewayOutput);

      expect(request.resource, equals('trending/yearly.json'));
      expect(request.queryParams, equals({'limit': 25}));

      expect(gatewayOutput, BookCollectionGatewayOutput());
    });

    test('success', () async {
      final gateway = BookCollectionGateway()
        ..feedResponse(
          (request) async =>
              const Either.right(kTestBookCollectionSuccessResponse),
        );

      final input = await gateway.buildInput(BookCollectionGatewayOutput());

      expect(input.isRight, isTrue);

      final bookModels = input.right.books;

      expect(bookModels.first.key, equals('/works/OL45804W'));
      expect(bookModels.first.title, equals('Fantastic Mr. Fox'));
      expect(bookModels.first.coverId, equals(10222599));
      expect(
        bookModels.first.authors.first,
        equals(const AuthorModel(key: 'OL34184A', name: 'Roald Dahl')),
      );

      expect(bookModels.last.key, equals('/works/OL103123W'));
      expect(bookModels.last.title, equals('Fahrenheit 451'));
      expect(bookModels.last.coverId, equals(12817098));
      expect(
        bookModels.last.authors.first,
        equals(const AuthorModel(key: 'OL24137A', name: 'Ray Bradbury')),
      );
    });

    test('failure', () async {
      final gateway = BookCollectionGateway()
        ..feedResponse(
          (request) async => Either.left(
            UnknownFailureResponse('No Internet'),
          ),
        );

      final input = await gateway.buildInput(BookCollectionGatewayOutput());

      expect(input.isLeft, isTrue);

      expect(input.left.message, equals('No Internet'));
    });
  });
}
