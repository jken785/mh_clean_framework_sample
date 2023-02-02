import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../section.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({super.key, required this.description});

  final String description;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final textTheme = Theme.of(context).textTheme;

    return Section(
      header: localizations?.descriptionHeader ?? 'Description',
      children: [
        const SizedBox(height: 8),
        Text(
          description.isEmpty
              ? localizations?.descriptionNotFoundWarning ??
                  'No description found'
              : description,
          style: textTheme.bodyMedium,
        ),
      ],
    );
  }
}
