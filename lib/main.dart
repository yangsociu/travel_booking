// main.dart
// File khởi chạy ứng dụng đặt vé máy bay (bỏ localizations)
import 'package:booking_app/routes/app_routes.dart';
import 'package:booking_app/services/flight_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:booking_app/blocs/auth/auth_bloc.dart';
import 'package:booking_app/services/auth_service.dart';
import 'package:booking_app/utils/app_theme.dart';
import 'package:booking_app/routes/app_router.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(authService: AuthService())),
        Provider<FlightService>(create: (_) => FlightService()),
      ],
      child: MaterialApp(
        title: 'Flight Booking App',
        theme: appTheme(),
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.generateRoute,
      ),
    );
  }
}
