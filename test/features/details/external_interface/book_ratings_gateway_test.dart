import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/features/details/external_interface/book_ratings_gateway.dart';
import 'package:mh_clean_framework_sample/features/details/models/book_ratings_model.dart';
import '../../../test_constants.dart';

void main() {
  group('BookRatingsGateway tests |', () {
    test('verify request', () async {
      final bookId = testBooks.first.key;

      final gateway = BookRatingsGateway();
      final gatewayOutput = BookRatingsGatewayOutput(bookId: bookId);

      final request = gateway.buildRequest(gatewayOutput);

      expect(request.resource, equals('$bookId/ratings.json'));
      expect(gatewayOutput, BookRatingsGatewayOutput(bookId: bookId));
    });

    test('success', () async {
      final gateway = BookRatingsGateway()
        ..feedResponse(
          (request) async => const Either.right(kTestRatingsSuccessResponse),
        );

      final input = await gateway.buildInput(
        BookRatingsGatewayOutput(bookId: testBooks.first.key),
      );

      expect(input.isRight, isTrue);

      final ratings = input.right.ratings;

      expect(ratings.averageRating, equals(3.8));
      expect(ratings.count, equals(85));
      expect(
        ratings.starsToRatingCount,
        equals({
          RatingStar.one: 8,
          RatingStar.two: 6,
          RatingStar.three: 17,
          RatingStar.four: 18,
          RatingStar.five: 36
        }),
      );
    });

    test('failure', () async {
      final gateway = BookRatingsGateway()
        ..feedResponse(
          (request) async => Either.left(
            UnknownFailureResponse('No Internet'),
          ),
        );

      final input = await gateway.buildInput(
        BookRatingsGatewayOutput(bookId: testBooks.first.key),
      );

      expect(input.isLeft, isTrue);

      expect(input.left.message, equals('No Internet'));
    });
  });
}
