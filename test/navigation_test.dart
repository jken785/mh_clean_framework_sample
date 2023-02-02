import 'package:flutter/material.dart';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';

import 'package:mh_clean_framework_sample/core/book/book_external_interface.dart';
import 'package:mh_clean_framework_sample/core/book/book_request.dart';
import 'package:mh_clean_framework_sample/core/book/book_success_response.dart';
import 'package:mh_clean_framework_sample/features/details/external_interface/book_details_gateway.dart';
import 'package:mh_clean_framework_sample/features/details/external_interface/book_ratings_gateway.dart';
import 'package:mh_clean_framework_sample/features/details/presentation/details_ui.dart';
import 'package:mh_clean_framework_sample/features/home/external_interface/book_collection_gateway.dart';
import 'package:mh_clean_framework_sample/features/home/presentation/home_ui.dart';
import 'package:mh_clean_framework_sample/providers.dart';
import 'package:mh_clean_framework_sample/routing/routes.dart';
import 'test_constants.dart';

void main() {
  testWidgets('Navigation Test', (tester) async {
    await mockNetworkImages(() async {
      final widget = AppProviderScope(
        externalInterfaceProviders: [bookExternalInterfaceProvider],
        overrides: [
          bookExternalInterfaceProvider.overrideWith(
            BookExternalInterfaceMock(),
          ),
        ],
        child: AppRouterScope(
          create: BooksRouter.new,
          builder: (context) {
            return MaterialApp.router(
              routerConfig: context.router.config,
              localizationsDelegates: const [
                AppLocalizations.delegate,
              ],
              supportedLocales: const [
                Locale('en', ''),
              ],
            );
          },
        ),
      );

      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();

      expect(find.byType(HomeUI), findsOneWidget);

      for (final book in testBooks) {
        expect(find.text(book.title), findsOneWidget);
      }

      await tester.tap(find.text(testBooks.first.title));
      await tester.pumpAndSettle();

      expect(find.byType(DetailsUI), findsOneWidget);

      expect(find.byTooltip('Back'), findsOneWidget);

      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();

      expect(find.byType(HomeUI), findsOneWidget);
    });
  });
}

class BookExternalInterfaceMock extends BookExternalInterface {
  @override
  void handleRequest() {
    on<GetBookRequest>(
      (request, send) async {
        final type = request.runtimeType;

        BookSuccessResponse response;

        switch (type) {
          case BookCollectionRequest:
            response = kTestBookCollectionSuccessResponse;
            break;
          case BookDetailsRequest:
            response = kTestDetailsSuccessResponse;
            break;
          case BookRatingsRequest:
            response = kTestRatingsSuccessResponse;
            break;
          default:
            throw ArgumentError(
              'Cannot mock response for GetBookRequest of type $type',
              'request',
            );
        }

        send(response);
      },
    );
  }
}
