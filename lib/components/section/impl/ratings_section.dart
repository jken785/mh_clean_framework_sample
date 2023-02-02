import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import '../../../features/details/models/book_ratings_model.dart';
import '../section.dart';

class RatingsSection extends StatelessWidget {
  const RatingsSection({
    super.key,
    required this.ratingAverage,
    required this.ratingCount,
    required this.starsToRatingCount,
  });

  final double ratingAverage;
  final int ratingCount;
  final StarsToRatingCount starsToRatingCount;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    final textTheme = Theme.of(context).textTheme;

    return Section(
      header: localizations?.ratingsHeader ?? 'Ratings',
      children: [
        RatingStars(
          value: ratingAverage,
        ),
        const SizedBox(height: 8),
        for (final ratingStar in RatingStar.values.reversed)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              RatingStars(
                starSpacing: 0,
                starSize: 15,
                value: ratingStar.value.toDouble(),
                valueLabelVisibility: false,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Builder(
                  builder: (context) {
                    final count = starsToRatingCount[ratingStar]!;
                    final percent = count / ratingCount;

                    return LinearPercentIndicator(
                      lineHeight: 8.0,
                      percent: percent,
                      progressColor: Colors.yellow,
                      backgroundColor:
                          const Color(0xffe7e8ea), // from RatingStars default
                      barRadius: const Radius.circular(100),
                      trailing: SizedBox(
                        width: 50,
                        child: Text(
                          count.toString(),
                          style: textTheme.bodySmall,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
      ],
    );
  }
}
