import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pocketkeeper/application/member_cache.dart';
import 'package:pocketkeeper/widget/show_toast.dart';

/*
Firebase Authentication class
References: https://medium.com/flutter-community/flutter-implementing-google-sign-in-71888bca24ed
*/
class Authentication {
  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;

        // Store oAuth token in user cache
        MemberCache.oauthAccessToken =
            (await googleSignInAccount.authentication).accessToken;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          showToast(
            customMessage:
                'The account already exists with a different credential',
          );
        } else if (e.code == 'invalid-credential') {
          showToast(
            customMessage:
                'Error occurred while accessing credentials. Try again.',
          );
        }
      } catch (e) {
        showToast(
          customMessage: 'Error occurred using Google Sign In. Try again.',
        );
      }
    }

    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      await googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      showToast(
        customMessage: 'Error signing out. Try again.',
      );
    }
  }
}
