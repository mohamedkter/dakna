import 'dart:developer';
import 'package:dakna/features/auth/data/models/user_model.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signInWithGoogle();
  Future<UserModel> signInWithFacebook();
  Future<UserModel> signInAsGuest();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient supabase = Supabase.instance.client;

  AuthRemoteDataSourceImpl();

  @override
  Future<UserModel> signInWithGoogle() async {
    /// Web Client ID that you registered with Google Cloud.
    final webClientId = dotenv.env['GOOGLE_WEB_CLIENT_ID']!;

    final scopes = ['email', 'profile'];
    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize(serverClientId: webClientId);
    final googleUser = await googleSignIn.attemptLightweightAuthentication();

    if (googleUser == null) {
      throw AuthException('Failed to sign in with Google.');
    }
    final authorization =
        await googleUser.authorizationClient.authorizationForScopes(scopes) ??
        await googleUser.authorizationClient.authorizeScopes(scopes);
    final idToken = googleUser.authentication.idToken;
    if (idToken == null) {
      throw AuthException('No ID Token found.');
    }

    log('Google Sign-In successful. ID Token: ${authorization.accessToken}');
    await supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: authorization.accessToken,
    );

    log('Supabase Sign-In successful. User: ${supabase.auth.currentUser}');
    return UserModel(
      id: supabase.auth.currentUser!.id,
      email: supabase.auth.currentUser!.email!,
      name:
          supabase.auth.currentUser!.userMetadata?['full_name'] as String ?? "",
      token: authorization.accessToken,
      picture: supabase.auth.currentUser!.userMetadata?['picture'],
    );
  }

  @override
  Future<UserModel> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login(
        permissions: ['public_profile', 'email'],
      );
      if (result.status == LoginStatus.success) {
        final accessToken = result.accessToken!.tokenString;
        await supabase.auth.signInWithIdToken(
          provider: OAuthProvider.facebook,
          idToken: accessToken,
        );

        return UserModel(
          id: supabase.auth.currentUser!.id,
          email: supabase.auth.currentUser!.email ?? "",
          name: supabase.auth.currentUser!.userMetadata?['full_name'],
          token: supabase.auth.currentUser!.userMetadata?['full_name'],
          picture: supabase.auth.currentUser!.userMetadata?['picture'],
        );
        // Authentication successful
      } else {
        // Handle login cancellation or failure
        throw Exception('Facebook login failed: ${result.status}');
      }
    } catch (e) {
      // Handle errors
      throw Exception('Facebook authentication error: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInAsGuest() async {
    final session = await supabase.auth.signInAnonymously();
    final u = session.user!;
    return UserModel(
      id: u.id,
      email: u.email ?? "",
      name: "",
      token: "",
      picture: null,
    );
  }
}
