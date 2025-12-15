import 'package:dakna/core/in/injection_container.dart';
import 'package:dakna/core/theme/app_icons.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_event.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dakna/features/auth/presentation/bloc/auth_bloc.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: Scaffold(
        appBar: AppBar(),
        body: BlocConsumer<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.message)));
            } else if (state is AuthSuccess) {
              // Navigate to home screen
            }
          },
          builder: (context, state) {
            if (state is AuthLoading) {
              return Center(child: CircularProgressIndicator());
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  Container(
                    height: height / 2,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/auth_image.png"),
                      ),
                    ),
                  ),
                  Spacer(),
                  Text(
                    "! اهلا و سهلا",
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                  SizedBox(height: 3),
                  Text(
                    "سجل دلوقتي او اشترك معانا عشان طلباتك توصلك لحد \n.بيتك",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall!.copyWith(color: Colors.black),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignInWithGooglePressed());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الاستمرار عن طريق جوجل',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(width: 15),

                        AppIcons.getIcon(
                          iconName: AppIcons.googleIcon,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(SignInWithFacebookPressed());
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'الاستمرار عن طريق الفيسبوك',
                          style: Theme.of(context).textTheme.bodyLarge!
                              .copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        SizedBox(width: 15),
                        AppIcons.getIcon(
                          iconName: AppIcons.facebookIcon,
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 100),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
