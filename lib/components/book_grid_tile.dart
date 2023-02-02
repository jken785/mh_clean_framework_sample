import 'package:flutter/material.dart';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:clean_framework_router/clean_framework_router.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../features/home/models/book_model.dart';
import '../routing/routes.dart';

class BookGridTile extends StatelessWidget {
  const BookGridTile({
    super.key,
    required this.book,
  });

  final BookModel book;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final textTheme = Theme.of(context).textTheme;

    return Material(
      elevation: 4,
      child: InkWell(
        onTap: () => context.router.go(
          Routes.details,
          params: {
            'book_key': book.key,
          },
          queryParams: {
            'book_cover_id': book.coverId.toString(),
          },
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 2,
              child: Hero(
                tag: book.key,
                child: Image.network(
                  'https://covers.openlibrary.org/b/id/${book.coverId}-L.jpg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: AutoSizeText(
                        book.title,
                        style: textTheme.titleMedium,
                        maxLines: 2,
                        minFontSize: textTheme.bodyMedium!.fontSize!,
                      ),
                    ),
                    AutoSizeText(
                      localizations?.byAuthor(book.authorsString) ??
                          'by ${book.authorsString}',
                      style: textTheme.bodySmall,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
