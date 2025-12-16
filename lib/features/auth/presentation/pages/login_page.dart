import 'package:dakna/core/in/injection_container.dart';
import 'package:dakna/core/localization/app_localizations.dart';
import 'package:dakna/core/theme/app_icons.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_event.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final t = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is Authenticated) {
            // Navigate to home screen
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                Container(
                  height: height / 2.5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/images/auth_image.png"),
                    ),
                  ),
                ),
                Spacer(),
                Text(
                  t.translate('welcome'),
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 3.h),
                Text(
                  "سجل دلوقتي او اشترك معانا عشان طلباتك توصلك لحد \n.بيتك",
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall!.copyWith(color: Colors.black),
                ),
                SizedBox(height: 30.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignInWithGooglePressed());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الاستمرار عن طريق جوجل',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 15.w),

                      AppIcons.getIcon(
                        iconName: AppIcons.googleIcon,
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(SignInWithFacebookPressed());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'الاستمرار عن طريق الفيسبوك',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 15.w),
                      AppIcons.getIcon(
                        iconName: AppIcons.facebookIcon,
                        width: 20,
                        height: 20,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
              ],
            ),
          );
        },
      ),
    );
  }
}
