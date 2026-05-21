import 'package:go_router/go_router.dart';
import '../../presentation/screens/home_screen.dart';
import '../../presentation/screens/add_expense_screen.dart';
import '../../presentation/screens/stats_screen.dart';
import '../../presentation/screens/settings_screen.dart';

class AppRouter {
  late final GoRouter router;
  
  AppRouter() {
    router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          name: 'home',
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          name: 'add_expense',
          path: '/add-expense',
          builder: (context, state) => const AddExpenseScreen(),
        ),
        GoRoute(
          name: 'stats',
          path: '/stats',
          builder: (context, state) => const StatsScreen(),
        ),
        GoRoute(
          name: 'settings',
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    );
  }
}