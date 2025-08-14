import 'package:flutter/material.dart';
import 'dependencyInjection/service_locator.dart';
import 'core/router/app_router.dart';
import 'presentation/theme/theme_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = getIt<AppRouter>();
    return MaterialApp.router(
      title: 'Hallogen Expenses Tracker',
      theme: AppTheme.mainTheme,
      routerConfig: appRouter.config(),
      debugShowCheckedModeBanner: false,
    );
  }
}
