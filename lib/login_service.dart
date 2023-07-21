// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

// Project imports:
import 'common.dart';
import 'constants.dart';

ZegoUIKitPrebuiltCallController? callController;

/// local virtual login
// Future<void> login({
//   required String userID,
//   required String userName,
// }) async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.setString(cacheUserIDKey, userID);
//
//   currentUser.id = userID;
//   currentUser.name = 'user_$userID';
// }

/// local virtual logout
// Future<void> logout() async {
//   final prefs = await SharedPreferences.getInstance();
//   prefs.remove(cacheUserIDKey);
// }

/// on user login

/// on user logout
void onUserLogout() {
  callController = null;

  /// 5/5. de-initialization ZegoUIKitPrebuiltCallInvitationService when account is logged out
  ZegoUIKitPrebuiltCallInvitationService().uninit();
}