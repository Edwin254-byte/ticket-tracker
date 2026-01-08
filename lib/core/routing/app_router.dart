import 'package:go_router/go_router.dart';
import '../../data/repositories/auth_repository.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/tickets/pages/tickets_list_page.dart';
import '../../features/tickets/pages/ticket_details_page.dart';
import '../../features/profile/pages/profile_page.dart';
import '../../features/navigation/main_navigation_wrapper.dart';

class AppRouter {
  final AuthRepository authRepository;

  AppRouter({required this.authRepository});

  late final GoRouter router = GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggedIn = authRepository.isLoggedIn();
      final isLoginRoute = state.matchedLocation == '/login';

      if (!isLoggedIn && !isLoginRoute) {
        return '/login';
      }

      if (isLoggedIn && isLoginRoute) {
        return '/tickets';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainNavigationWrapper(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/tickets',
                builder: (context, state) => const TicketsListPage(),
                routes: [
                  GoRoute(
                    path: ':id',
                    builder: (context, state) {
                      final id = int.parse(state.pathParameters['id']!);
                      return TicketDetailsPage(ticketId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}
