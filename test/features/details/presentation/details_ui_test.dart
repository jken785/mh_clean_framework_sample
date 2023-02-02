import 'package:flutter/material.dart';

import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:mh_clean_framework_sample/components/loading_failed_message.dart';
import 'package:mh_clean_framework_sample/features/details/models/book_ratings_model.dart';
import 'package:mh_clean_framework_sample/features/details/presentation/details_ui.dart';
import 'package:mh_clean_framework_sample/features/details/presentation/details_view_model.dart';
import '../../../test_constants.dart';
import '../../../test_helpers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DetailsUI tests |', () {
    final mrFox = testBooks.first;

    final ui = DetailsUI(
      bookKey: testBooks.first.key,
      bookCoverId: testBooks.first.coverId.toString(),
    );

    uiTestWithMockedNetworkImages(
      'shows book details correctly',
      ui: ui,
      viewModel: DetailsViewModel(
        title: mrFox.title,
        subtitle: '',
        description: kTestBookDetails.description,
        isLoading: false,
        hasFailedLoading: false,
        ratingAverage: kTestBookRatings.averageRating,
        ratingCount: kTestBookRatings.count,
        starsToRatingCount: kTestBookRatings.starsToRatingCount,
        onRetry: () {},
      ),
      verify: (tester) async {
        await tester.pumpAndSettle();

        expect(find.text(mrFox.title), findsOneWidget);

        _expectRatingStarsWith(value: kTestBookRatings.averageRating);

        for (final ratingStar in RatingStar.values) {
          final count = kTestBookRatings.starsToRatingCount[ratingStar]!;
          final percent = count / kTestBookRatings.count;

          _expectRatingStarsWith(value: ratingStar.value);
          _expectLinearPercentIndicatorWith(percent: percent, count: count);
        }

        expect(find.text(kTestBookDetails.description), findsOneWidget);
      },
    );

    uiTest(
      'shows loading indicator if loading data',
      ui: ui,
      viewModel: DetailsViewModel(
        title: '',
        subtitle: '',
        description: '',
        isLoading: true,
        hasFailedLoading: false,
        ratingAverage: 0,
        ratingCount: 0,
        starsToRatingCount: const {},
        onRetry: () {},
      ),
      verify: (tester) async {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    uiTest(
      'shows loading indicator if loading data',
      ui: ui,
      viewModel: DetailsViewModel(
        title: '',
        subtitle: '',
        description: '',
        isLoading: true,
        hasFailedLoading: false,
        ratingAverage: 0,
        ratingCount: 0,
        starsToRatingCount: const {},
        onRetry: () {},
      ),
      verify: (tester) async {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    uiTest(
      'shows loading failed widget if data failed loading',
      ui: ui,
      viewModel: DetailsViewModel(
        title: '',
        subtitle: '',
        description: '',
        isLoading: false,
        hasFailedLoading: true,
        ratingAverage: 0,
        ratingCount: 0,
        starsToRatingCount: const {},
        onRetry: () {},
      ),
      verify: (tester) async {
        expect(find.byType(LoadingFailedMessage), findsOneWidget);
        expect(
          find.text("Oops, we couldn't connect to the network!"),
          findsOneWidget,
        );
        expect(find.byType(OutlinedButton), findsOneWidget);
        expect(find.text('Try Again'), findsOneWidget);
      },
    );
  });
}

void _expectRatingStarsWith({required num value}) {
  expect(
    find.byWidgetPredicate(
      (widget) => widget is RatingStars && widget.value == value,
    ),
    findsOneWidget,
  );
}

void _expectLinearPercentIndicatorWith({
  required num percent,
  required int count,
}) {
  expect(find.text(count.toString()), findsOneWidget);
  expect(
    find.byWidgetPredicate(
      (widget) => widget is LinearPercentIndicator && widget.percent == percent,
    ),
    findsOneWidget,
  );
}
