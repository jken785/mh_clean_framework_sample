import 'package:clean_framework/clean_framework.dart';

import 'core/book/book_external_interface.dart';
import 'features/details/domain/details_use_case.dart';
import 'features/details/external_interface/book_details_gateway.dart';
import 'features/details/external_interface/book_ratings_gateway.dart';
import 'features/home/domain/home_use_case.dart';
import 'features/home/external_interface/book_collection_gateway.dart';

final homeUseCaseProvider = UseCaseProvider(
  HomeUseCase.new,
);

final detailsUseCaseProvider = UseCaseProvider.autoDispose(
  DetailsUseCase.new,
);

final bookExternalInterfaceProvider = ExternalInterfaceProvider(
  BookExternalInterface.new,
  gateways: [
    bookCollectionGateway,
    detailsGateway,
    ratingsGateway,
  ],
);

final bookCollectionGateway = GatewayProvider(
  BookCollectionGateway.new,
  useCases: [homeUseCaseProvider],
);

final detailsGateway =
    GatewayProvider(BookDetailsGateway.new, useCases: [detailsUseCaseProvider]);

final ratingsGateway =
    GatewayProvider(BookRatingsGateway.new, useCases: [detailsUseCaseProvider]);
