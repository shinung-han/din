import 'package:din/authentication/log_in_screen.dart';
import 'package:din/authentication/sign_up_screen.dart';
import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/repos/authentication_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  ref.watch(authStateStream);

  return GoRouter(
    initialLocation: LoginScreen.routeURL,
    redirect: (context, state) {
      final isLoggedIn = ref.read(authRepo).isLoggedIn;
      if (!isLoggedIn) {
        if (state.matchedLocation != SignUpScreen.routeURL &&
            state.matchedLocation != LoginScreen.routeURL) {
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
        path: SignUpScreen.routeURL,
        name: SignUpScreen.routeName,
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: '/:tab(home|list|profile)',
        name: MainNavigationScreen.routeName,
        builder: (context, state) {
          final tab = state.pathParameters['tab'];
          return MainNavigationScreen(
            tab: tab!,
          );
        },
      ),
    ],
  );
});
