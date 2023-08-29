import 'package:din/router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Map<String, String> UNIT_ID = kReleaseMode
    ? {
        'ios': 'ca-app-pub-8268099499009870~6548359452',
        'android': '[YOUR ANDROID AD UNIT ID]',
      }
    : {
        'ios': 'ca-app-pub-8268099499009870/1356614665',
        'android': 'ca-app-pub-3940256099942544/6300978111',
      };

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(MyApp());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarBrightness: Brightness.light,
    ),
  );
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        if (snapshot.connectionState == ConnectionState.done) {
          FlutterNativeSplash.remove();
          return const ProviderScope(child: DinApp());
        }

        return LoadingScreen();
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}

class DinApp extends ConsumerWidget {
  const DinApp({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(routerProvider),
      debugShowCheckedModeBanner: false,
      title: 'DIN',
      theme: ThemeData(
        fontFamily: 'NotoSans',
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarBrightness: Brightness.light,
          ),
        ),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: Colors.black,
          selectionColor: Colors.grey.shade200,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.white,
          elevation: 0,
        ),
        splashColor: Colors.transparent,
        useMaterial3: true,
      ),
    );
  }
}
