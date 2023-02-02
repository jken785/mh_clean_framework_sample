import 'package:flutter/material.dart';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../providers.dart';
import '../domain/home_entity.dart';
import '../domain/home_ui_output.dart';
import '../domain/home_use_case.dart';
import 'home_view_model.dart';

class HomePresenter
    extends Presenter<HomeViewModel, HomeUIOutput, HomeUseCase> {
  HomePresenter({
    super.key,
    required super.builder,
  }) : super(provider: homeUseCaseProvider);

  @override
  void onLayoutReady(BuildContext context, HomeUseCase useCase) {
    useCase.fetchBooks();
  }

  @override
  HomeViewModel createViewModel(HomeUseCase useCase, HomeUIOutput output) {
    return HomeViewModel(
      books: output.books,
      onRefresh: () => useCase.fetchBooks(isRefresh: true),
      onRetry: useCase.fetchBooks,
      isLoading: output.status == HomeStatus.loading,
      hasFailedLoading: output.status == HomeStatus.failed,
    );
  }

  @override
  void onOutputUpdate(BuildContext context, HomeUIOutput output) {
    if (output.isRefresh) {
      final localizations = AppLocalizations.of(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            output.status == HomeStatus.failed
                ? localizations?.snackbarRefreshFailed ??
                    "Sorry, we couldn't refresh trending books."
                : localizations?.snackbarRefreshSucceeded ??
                    'Refreshed trending books successfully!',
          ),
        ),
      );
    }
  }
}
