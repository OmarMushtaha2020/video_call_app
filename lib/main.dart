// Flutter imports:
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/firebase_options.dart';
import 'package:video_voice_call/module/register_screen.dart';
import 'package:video_voice_call/shared/network/local/cacth_helper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'module/constants.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await CacthHelper.inti();
        token= CacthHelper.get_Data(key: "token");
print("the token is ${token}");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // final prefs = await SharedPreferences.getInstance();
  // final cacheUserID = prefs.get(cacheUserIDKey) as String? ?? '';
  // if (cacheUserID.isNotEmpty) {
  //   currentUser.id = cacheUserID;
  //   currentUser.name = 'user_$cacheUserID';
  // }

  /// 1/5: define a navigator key
  final navigatorKey = GlobalKey<NavigatorState>();

  /// 2/5: set navigator key to ZegoUIKitPrebuiltCallInvitationService
  ZegoUIKitPrebuiltCallInvitationService().setNavigatorKey(navigatorKey);

  ZegoUIKit().initLog().then((value) {
    ZegoUIKitPrebuiltCallInvitationService().useSystemCallingUI(
      [ZegoUIKitSignalingPlugin()],
    );

    runApp(MyApp(navigatorKey: navigatorKey,token: token,));
  });
}

class MyApp extends StatefulWidget {
  final GlobalKey<NavigatorState> navigatorKey;
var token;
   MyApp({
    required this.navigatorKey,
    this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    // if (currentUser.id.isNotEmpty) {
    //   onUserLogin();
    // }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) =>AppCubit()..getData()..getDataUser()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: routes,
        initialRoute:widget.token!=null? PageRouteNames.home:PageRouteNames.login_screen,
        theme: ThemeData(scaffoldBackgroundColor: const Color(0xFFEFEFEF)),

        /// 3/5: register the navigator key to MaterialApp
        navigatorKey: widget.navigatorKey,
        builder: (BuildContext context, Widget? child) {
          return Stack(
            children: [
              child!,

              /// support minimizing
              ZegoUIKitPrebuiltCallMiniOverlayPage(
                contextQuery: () {
                  return widget.navigatorKey.currentState!.context;
                },
              ),
            ],
          );
        },
      ),
    );
  }
}