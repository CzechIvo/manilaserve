import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'splash_screen.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'profile_settings.dart';
import 'office_services.dart';
import 'requirements_checklist.dart';
import 'maps.dart';
// Import admin screens
import 'admin_dashboard.dart';
import 'admin_office_services.dart';
import 'admin_profile.dart';
// Import forgot password screens
import 'forgot_password.dart';
import 'verify_reset_code.dart';
import 'reset_password.dart';

void main() {
  runApp(ManilaServeApp());
}

class ManilaServeApp extends StatelessWidget {
  // Updated GoRouter configuration with fixed routing
  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      // Splash screen
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Regular user routes
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignUpScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => HomeScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => ProfileSettingsScreen(),
      ),
      // Fixed office-services route to handle query parameters properly
      GoRoute(
        path: '/office-services',
        builder: (context, state) {
          final officeName = state.uri.queryParameters['office'] ?? 'Office Name';
          return OfficeServicesScreen(officeName: officeName);
        },
      ),
      GoRoute(
        path: '/requirements',
        builder: (context, state) => RequirementsChecklistScreen(),
      ),
      GoRoute(
        path: '/maps',
        builder: (context, state) => MapsScreen(),
      ),
      
      // Admin routes
      GoRoute(
        path: '/admin-dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin-office-services',
        builder: (context, state) {
          final officeName = state.extra as String? ?? 'Office Name';
          return AdminOfficeServicesScreen();
        },
      ),
      GoRoute(
        path: '/admin-profile',
        builder: (context, state) => AdminProfileScreen(),
      ),
      
      // Forgot password routes with proper argument handling
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify-reset-code',
        builder: (context, state) {
          final args = state.extra as Map<String, dynamic>? ?? {};
          return VerifyResetCodeScreen(
            email: args['email'] ?? '',
            resetCode: args['resetCode'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return ResetPasswordScreen(email: email);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ManilaServe',
      theme: ThemeData(
        primarySwatch: Colors.brown,
        scaffoldBackgroundColor: Color(0xFFF5E6D3),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFF5E6D3),
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}