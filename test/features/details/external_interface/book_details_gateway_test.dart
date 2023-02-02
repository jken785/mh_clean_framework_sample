import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/core/book/book_success_response.dart';
import 'package:mh_clean_framework_sample/features/details/external_interface/book_details_gateway.dart';
import '../../../test_constants.dart';

void main() {
  group('BookDetailsGateway tests |', () {
    test('verify request', () async {
      final bookId = testBooks.first.key;

      final gateway = BookDetailsGateway();
      final gatewayOutput = BookDetailsGatewayOutput(bookId: bookId);

      final request = gateway.buildRequest(gatewayOutput);

      expect(request.resource, equals('$bookId.json'));
      expect(gatewayOutput, BookDetailsGatewayOutput(bookId: bookId));
    });

    test('success', () async {
      final gateway = BookDetailsGateway()
        ..feedResponse(
          (request) async => const Either.right(
            BookSuccessResponse(
              data: {
                'title': 'Fantastic Mr. Fox',
                'key': '/works/OL45804W',
                'authors': [
                  {
                    'author': {'key': '/authors/OL34184A'},
                    'type': {'key': '/type/author_role'}
                  }
                ],
                'description':
                    'The main character of Fantastic Mr. Fox is an extremely clever anthropomorphized fox named Mr. Fox.',
              },
            ),
          ),
        );

      final input = await gateway.buildInput(
        BookDetailsGatewayOutput(bookId: testBooks.first.key),
      );

      expect(input.isRight, isTrue);

      final details = input.right.details;

      expect(details.title, equals('Fantastic Mr. Fox'));
      expect(details.subtitle, equals(''));
      expect(
        details.description,
        equals(
          'The main character of Fantastic Mr. Fox is an extremely clever anthropomorphized fox named Mr. Fox.',
        ),
      );
    });

    test('success with alternate description', () async {
      final gateway = BookDetailsGateway()
        ..feedResponse(
          (request) async => const Either.right(
            BookSuccessResponse(
              data: {
                'title': 'Fantastic Mr. Fox',
                'key': '/works/OL45804W',
                'authors': [
                  {
                    'author': {'key': '/authors/OL34184A'},
                    'type': {'key': '/type/author_role'}
                  }
                ],
                'description': {
                  'value':
                      'The main character of Fantastic Mr. Fox is an extremely clever anthropomorphized fox named Mr. Fox.'
                }
              },
            ),
          ),
        );

      final input = await gateway.buildInput(
        BookDetailsGatewayOutput(bookId: testBooks.first.key),
      );

      expect(input.isRight, isTrue);

      final details = input.right.details;

      expect(details.title, equals('Fantastic Mr. Fox'));
      expect(details.subtitle, equals(''));
      expect(
        details.description,
        equals(
          'The main character of Fantastic Mr. Fox is an extremely clever anthropomorphized fox named Mr. Fox.',
        ),
      );
    });

    test('success without description', () async {
      final gateway = BookDetailsGateway()
        ..feedResponse(
          (request) async => const Either.right(kTestDetailsSuccessResponse),
        );

      final input = await gateway.buildInput(
        BookDetailsGatewayOutput(bookId: testBooks.first.key),
      );

      expect(input.isRight, isTrue);

      final details = input.right.details;

      expect(details.title, equals('Fantastic Mr. Fox'));
      expect(details.subtitle, equals(''));
      expect(details.description, equals(''));
    });

    test('failure', () async {
      final gateway = BookDetailsGateway()
        ..feedResponse(
          (request) async => Either.left(
            UnknownFailureResponse('No Internet'),
          ),
        );

      final input = await gateway.buildInput(
        BookDetailsGatewayOutput(bookId: testBooks.first.key),
      );

      expect(input.isLeft, isTrue);

      expect(input.left.message, equals('No Internet'));
    });
  });
}
