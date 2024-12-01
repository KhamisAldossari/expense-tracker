// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'navigation/router.dart';
import 'utils/logger.dart';
import 'services/api_service.dart';
import 'models/expense.dart';
import 'models/category.dart';
import 'models/user.dart';
import 'utils/logger.dart';
import 'utils/exceptions.dart';
import 'utils/error_handler.dart';
import 'services/api_service.dart';
import 'providers/auth_state.dart';
import 'providers/providers.dart';
import 'providers/expense_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  final logger = Logger();
  
  // Set up error handling for async errors
  FlutterError.onError = (details) {
    logger.error('Flutter error', error: details.exception, stackTrace: details.stack);
  };

  runApp(
    ProviderScope(
      observers: [
        // Logger for Riverpod state changes
        RiverpodLogger(),
        ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      title: 'Expense Tracker',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.interTextTheme(),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        snackBarTheme: const SnackBarThemeData(
          behavior: SnackBarBehavior.floating,
        ),
      ),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// Riverpod logger for debugging
class RiverpodLogger extends ProviderObserver {
  final _logger = Logger();

  @override
  void didUpdateProvider(
    ProviderBase provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _logger.debug('''
    {
      "provider": "${provider.name ?? provider.runtimeType}",
      "newValue": "$newValue"
    }''');
  }
}