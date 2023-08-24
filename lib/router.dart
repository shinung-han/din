import 'package:din/features/authentication/log_in_screen.dart';
import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:din/features/projects/edit_project_screen.dart';
import 'package:din/features/projects/list_of_goals_screen.dart';
import 'package:din/features/projects/set_date_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authState);

  return GoRouter(
    // initialLocation: LoginScreen.routeURL,
    // initialLocation: SplashScreen.routeURL,
    initialLocation: '/home',
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != LoginScreen.routeURL) {
          return LoginScreen.routeURL;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: LoginScreen.routeURL,
        name: LoginScreen.routeName,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/:tab(home|list|chart|profile)',
        name: MainNavigationScreen.routeName,
        builder: (context, state) {
          final tab = state.pathParameters['tab'];
          return MainNavigationScreen(
            tab: tab!,
          );
        },
        routes: [
          GoRoute(
            path: SetDateScreen.routeURL,
            name: SetDateScreen.routeName,
            builder: (context, state) => const SetDateScreen(),
            routes: [
              GoRoute(
                path: ListOfGoalsScreen.routeURL,
                name: ListOfGoalsScreen.routeName,
                builder: (context, state) => const ListOfGoalsScreen(),
              ),
            ],
          ),
          GoRoute(
            path: EditProjectScreen.routeURL,
            name: EditProjectScreen.routeName,
            builder: (context, state) => const EditProjectScreen(),
          ),
        ],
      ),
      GoRoute(
        path: TutorialScreen.routeURL,
        name: TutorialScreen.routeName,
        builder: (context, state) => const TutorialScreen(),
      ),
    ],
  );
});
