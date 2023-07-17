import 'package:din/features/authentication/log_in_screen.dart';
import 'package:din/features/authentication/repos/authentication_repo.dart';
import 'package:din/features/authentication/sign_up_screen.dart';
import 'package:din/common/widgets/main_navigation_screen.dart';
import 'package:din/features/onboarding/tutorial_screen.dart';
import 'package:din/splash_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider((ref) {
  // ref.watch(authStateStream);

  return GoRouter(
    // initialLocation: LoginScreen.routeURL,
    initialLocation: SplashScreen.routeURL,
    // initialLocation: '/home',
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
        path: SplashScreen.routeURL,
        name: SplashScreen.routeName,
        builder: (context, state) => const SplashScreen(),
      ),
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
      GoRoute(
        path: TutorialScreen.routeURL,
        name: TutorialScreen.routeName,
        builder: (context, state) => const TutorialScreen(),
      ),
    ],
  );
});
