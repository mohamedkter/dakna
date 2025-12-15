
import 'package:dakna/core/in/injection_container.dart' as di;
import 'package:dakna/core/router/app_router.dart';
import 'package:dakna/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

// Load environment variables
  await dotenv.load(fileName: ".env");

// Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
  );

// Initialize Dependency Injection
  await di.init(); // initialize GetIt

// Run the app
  runApp(DaknaApp());
}

class DaknaApp extends StatelessWidget {
  const DaknaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Dakna',
       theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      
    );
  }
}
