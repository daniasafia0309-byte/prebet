import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'common/theme.dart';
import 'screens/auth/auth_gate.dart';
import 'controller/driver_controller.dart';
import 'controller/booking_controller.dart';
import 'screens/profile/edit_profile.dart';
import 'data/user_model.dart';

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ),
  );

  runZonedGuarded(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    debugPrint('🔥 Firebase initialized successfully');

    runApp(const MyApp());
  }, (error, stack) {
    debugPrint('❌ Uncaught error: $error');
    debugPrintStack(stackTrace: stack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DriverController()),
        ChangeNotifierProvider(create: (_) => BookingController()),
      ],
      child: MaterialApp(
        navigatorKey: navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,

        home: const AuthGate(),

        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/edit-profile':
              final user = settings.arguments as AppUser;
              return MaterialPageRoute(
                builder: (_) => EditProfilePage(user: user),
              );

            default:
              return MaterialPageRoute(
                builder: (_) => const AuthGate(),
              );
          }
        },
      ),
    );
  }
}
