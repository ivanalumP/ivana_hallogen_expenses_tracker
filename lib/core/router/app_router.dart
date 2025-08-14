import 'package:auto_route/auto_route.dart';
import '../../presentation/screens/main_screen.dart';
import '../../presentation/screens/add_expenses_screen.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          path: '/',
          page: MainRoute.page,
          initial: true,
        ),
        AutoRoute(
          path: '/add-expenses',
          page: AddExpensesRoute.page,
        ),
      ];
}
