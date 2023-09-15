// Package imports:
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/module/register_screen.dart';
import 'package:video_voice_call/shared/network/local/cacth_helper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
ZegoUIKitPrebuiltCallController? callController;
/// on user logout
Future<void> onUserLogout() async {
  callController = null;
  token='';
  print(token);
  CacthHelper.saveData("token", "$token");

}