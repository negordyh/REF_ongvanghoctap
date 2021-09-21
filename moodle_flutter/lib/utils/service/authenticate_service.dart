import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:moodle_flutter/bee_service/log_user.dart';
import 'package:moodle_flutter/utils/app_context.dart';
import 'package:moodle_flutter/utils/share_preferences.dart';

class AuthenticateService {

  static logout() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    if (_auth.currentUser != null) {
      await _auth.signOut();
    }
    if (await GoogleSignIn().isSignedIn()) {
      await GoogleSignIn().signOut();
    }
    LogUserRequest.updateLogUsersToday(AppContext.getLogUser());
    await SharePrefs.clearDataLogOut();
  }
}