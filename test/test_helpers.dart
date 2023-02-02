import 'dart:async';

import 'package:flutter/material.dart';

import 'package:clean_framework/clean_framework.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:clean_framework_test/clean_framework_test.dart';
import 'package:clean_framework_test/src/ui_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart' show isTest;
import 'package:meta/meta.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:riverpod/riverpod.dart' show Override;
import 'package:riverpod/riverpod.dart';

@isTest
void uiTestWithMockedNetworkImages<V extends ViewModel>(
  String description, {
  required UI ui,
  required V viewModel,
  required FutureOr<void> Function(WidgetTester) verify,
  List<Override> overrides = const [],
  Widget Function(BuildContext, Widget)? builder,
}) {
  testWidgets(description, (tester) async {
    await mockNetworkImages(
      () async {
        await tester.pumpWidget(
          AppProviderScope(
            overrides: overrides,
            child: AppRouterScope(
              create: UITestRouter.new,
              builder: (context) {
                final child = MaterialApp(
                  home: ViewModelScope(
                    viewModel: viewModel,
                    child: ui,
                  ),
                );

                return builder?.call(context, child) ?? child;
              },
            ),
          ),
        );

        await verify(tester);
      },
    );
  });
}
