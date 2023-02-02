import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_framework/clean_framework.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../components/loading_failed_message.dart';
import '../../../components/section/impl/description_section.dart';
import '../../../components/section/impl/ratings_section.dart';
import 'details_presenter.dart';
import 'details_view_model.dart';

class DetailsUI extends UI<DetailsViewModel> {
  DetailsUI({
    super.key,
    required this.bookKey,
    required this.bookCoverId,
  });

  final String bookKey;
  final String bookCoverId;

  @override
  DetailsPresenter create(WidgetBuilder builder) {
    return DetailsPresenter(builder: builder, bookId: bookKey);
  }

  @override
  Widget build(BuildContext context, DetailsViewModel viewModel) {
    final localization = AppLocalizations.of(context);

    final size = MediaQuery.of(context).size;

    final textTheme = Theme.of(context).textTheme;

    final bookCoverUrl =
        'https://covers.openlibrary.org/b/id/$bookCoverId-L.jpg';

    Widget child;
    if (viewModel.isLoading) {
      child = const Center(child: CircularProgressIndicator());
    } else if (viewModel.hasFailedLoading) {
      child = LoadingFailedMessage(
        onRetry: viewModel.onRetry,
      );
    } else {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AutoSizeText(
            viewModel.title,
            style: textTheme.titleLarge,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          RatingsSection(
            ratingAverage: viewModel.ratingAverage,
            ratingCount: viewModel.ratingCount,
            starsToRatingCount: viewModel.starsToRatingCount,
          ),
          const SizedBox(height: 16),
          DescriptionSection(description: viewModel.description),
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(localization?.detailsTitle ?? 'Book Details'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(bookCoverUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                ),
                padding: const EdgeInsets.all(16),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Hero(
                      tag: bookKey,
                      child: Image.network(
                        bookCoverUrl,
                        fit: BoxFit.contain,
                        alignment: Alignment.topCenter,
                        width: size.width * 0.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
