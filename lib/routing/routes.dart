import 'package:clean_framework_router/clean_framework_router.dart';

import '../features/details/presentation/details_ui.dart';
import '../features/home/presentation/home_ui.dart';

enum Routes with RoutesMixin {
  home('/'),
  details(':book_key');

  const Routes(this.path);

  @override
  final String path;
}

class BooksRouter extends AppRouter<Routes> {
  @override
  RouterConfiguration configureRouter() {
    return RouterConfiguration(
      routes: [
        AppRoute(
          route: Routes.home,
          builder: (_, __) => HomeUI(),
          routes: [
            AppRoute(
              route: Routes.details,
              builder: (_, state) {
                return DetailsUI(
                  bookKey: state.params['book_key'] ?? '',
                  bookCoverId: state.queryParams['book_cover_id'] ?? '',
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
