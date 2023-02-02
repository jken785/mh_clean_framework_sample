import 'package:flutter/material.dart';

import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mh_clean_framework_sample/components/book_grid_tile.dart';
import 'package:mh_clean_framework_sample/components/loading_failed_message.dart';
import 'package:mh_clean_framework_sample/features/home/presentation/home_ui.dart';
import 'package:mh_clean_framework_sample/features/home/presentation/home_view_model.dart';
import 'package:mh_clean_framework_sample/routing/routes.dart';
import '../../../test_constants.dart';
import '../../../test_helpers.dart';

void main() {
  group('HomeUI tests |', () {
    uiTestWithMockedNetworkImages(
      'shows book list correctly',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        books: testBooks,
        isLoading: false,
        hasFailedLoading: false,
        onRetry: () {},
        onRefresh: () async {},
      ),
      verify: (tester) async {
        expect(find.text('Fantastic Mr. Fox'), findsOneWidget);
        expect(find.text('by Roald Dahl'), findsOneWidget);

        expect(find.text('Fahrenheit 451'), findsOneWidget);
        expect(find.text('by Ray Bradbury'), findsOneWidget);
      },
    );

    uiTest(
      'shows loading indicator if loading data',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        books: const [],
        isLoading: true,
        hasFailedLoading: false,
        onRetry: () {},
        onRefresh: () async {},
      ),
      verify: (tester) async {
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
      },
    );

    uiTest(
      'shows loading failed widget if data failed loading',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        books: const [],
        isLoading: false,
        hasFailedLoading: true,
        onRetry: () {},
        onRefresh: () async {},
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

    uiTestWithMockedNetworkImages(
      'tapping on book navigates to detail page',
      ui: HomeUI(),
      viewModel: HomeViewModel(
        books: testBooks,
        isLoading: false,
        hasFailedLoading: false,
        onRetry: () {},
        onRefresh: () async {},
      ),
      verify: (tester) async {
        for (int i = 0; i < 10; i++) {
          await tester.pumpAndSettle();
        }

        final bookTileFinder = find.descendant(
          of: find.byType(BookGridTile),
          matching: find.text('Fantastic Mr. Fox'),
        );

        expect(bookTileFinder, findsOneWidget);

        await tester.tap(bookTileFinder);
        await tester.pumpAndSettle();

        final routeData = tester.routeData!;
        expect(routeData.route, Routes.details);
        expect(routeData.params, equals({'book_key': testBooks.first.key}));
        expect(
          routeData.queryParams,
          equals({'book_cover_id': testBooks.first.coverId.toString()}),
        );
      },
    );
  });
}
