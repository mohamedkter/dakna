// import 'package:dakna/features/auth/presentation/bloc/auth_event.dart';
// import 'package:dakna/features/auth/presentation/bloc/auth_state.dart';
// import 'package:dakna/features/home/presentation/pages/home_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/auth_bloc.dart';


// class SignupPage extends StatelessWidget {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController nameController = TextEditingController();

//   SignupPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(16),
//         child: BlocConsumer<AuthBloc, AuthState>(
//           listener: (context, state) {
//             if (state is Authenticated) {
//               Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomePage()));
//             } else if (state is AuthError) {
//               ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
//             }
//           },
//           builder: (context, state) {
//             if (state is AuthLoading) return Center(child: CircularProgressIndicator());

//             return Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text('Create Account', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//                 SizedBox(height: 40),
//                 TextField(controller: nameController, decoration: InputDecoration(labelText: 'Name')),
//                 SizedBox(height: 16),
//                 TextField(controller: emailController, decoration: InputDecoration(labelText: 'Email')),
//                 SizedBox(height: 16),
//                 TextField(controller: passwordController, decoration: InputDecoration(labelText: 'Password'), obscureText: true),
//                 SizedBox(height: 32),
//                 ElevatedButton(
//                   onPressed: () {
//                     BlocProvider.of<AuthBloc>(context).add(
//                       SignUpEvent(emailController.text, passwordController.text, nameController.text),
//                     );
//                   },
//                   child: Text('Sign Up'),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
