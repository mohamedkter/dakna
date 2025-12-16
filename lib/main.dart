import 'package:dakna/core/cache/cache_helper.dart';
import 'package:dakna/core/in/injection_container.dart' as di;
import 'package:dakna/core/localization/app_localizations.dart';
import 'package:dakna/core/localization/locale_provider.dart';
import 'package:dakna/core/router/app_router.dart';
import 'package:dakna/core/theme/app_theme.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_event.dart';
import 'package:dakna/features/location/presentation/cubit/location_cubit.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
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
  await CacheHelper.init();

  // Initialize Dependency Injection
  await di.init(); // initialize GetIt

  // Run the app
  runApp(
    DevicePreview(
      enabled: true,
      builder: (context) => ChangeNotifierProvider(
        create: (_) => LocaleProvider(),
        child: const DaknaApp(),
      ),
    ),
  );
}

class DaknaApp extends StatelessWidget {
  const DaknaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, __) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<AuthBloc>(
              create: (_) => di.sl<AuthBloc>()..add(AppStarted()),
            ),
            BlocProvider(create: (context) => LocationCubit()),
          ],
          child: Builder(
            builder: (context) {
              final authBloc = context.read<AuthBloc>();
              return MaterialApp.router(
                debugShowCheckedModeBanner: false,
                title: 'Dakna',
                theme: AppTheme.lightTheme,
                locale: localeProvider.locale,
                supportedLocales: const [Locale('en'), Locale('ar')],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                routerConfig: AppRouter(authBloc: authBloc).router,
              );
            },
          ),
        );
      },
    );
  }
}

