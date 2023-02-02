import 'package:flutter/material.dart';

import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/book_grid_tile.dart';
import '../../../components/loading_failed_message.dart';
import 'home_presenter.dart';
import 'home_view_model.dart';

class HomeUI extends UI<HomeViewModel> {
  HomeUI({super.key});

  static const routeName = '/';

  @override
  HomePresenter create(WidgetBuilder builder) {
    return HomePresenter(builder: builder);
  }

  @override
  Widget build(BuildContext context, HomeViewModel viewModel) {
    Widget child;
    if (viewModel.isLoading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (viewModel.hasFailedLoading) {
      child = LoadingFailedMessage(onRetry: viewModel.onRetry);
    } else {
      child = RefreshIndicator(
        onRefresh: viewModel.onRefresh,
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 300,
            childAspectRatio: 4 / 7,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: viewModel.books.length,
          itemBuilder: (context, index) {
            final book = viewModel.books[index];

            return BookGridTile(book: book);
          },
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)?.homeTitle ?? 'Jake Kendrick: MH Sample',
        ),
      ),
      body: child,
    );
  }
}
