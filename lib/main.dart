import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/firebase_options.dart';

import 'package:video_voice_call/module/register_screen.dart';
import 'package:video_voice_call/shared/network/local/cacth_helper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';
import 'module/constants.dart';
import 'dart:ui' as ui;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await CacthHelper.inti();
print("object");
  token= CacthHelper.get_Data(key: "token");
print("the token is ${token}");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

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
String? token;
   MyApp({
    required this.navigatorKey,
    this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => MyAppState(token);
}

class MyAppState extends State<MyApp> {
  String?token;
MyAppState(this.token);

  @override
  Widget build(BuildContext context) {
    print("MyAppState $token");
    final windowSize = ui.window.physicalSize;
    final screenScale = ui.window.devicePixelRatio;
    double screenWidth = windowSize.width / screenScale;
    double screenHeight = windowSize.height / screenScale;
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (BuildContext context) =>
          AppCubit()
            ..getData(token)
            ..getDataUser(token)),
        ],
        child: ScreenUtilInit(
            designSize: Size(screenWidth, screenHeight),
            builder: (context, w) {
              return MaterialApp(
                themeMode: ThemeMode.light,

                debugShowCheckedModeBanner: false,
                routes: routes,
                initialRoute: token?.isNotEmpty == true
                    ? PageRouteNames.home
                    : PageRouteNames.login_screen,
                theme: ThemeData(
                    scaffoldBackgroundColor: const Color(0xFFEFEFEF),
                    appBarTheme: const AppBarTheme(
                        color: Color(0xFFEFEFEF),
                        elevation: 0,
                        systemOverlayStyle: SystemUiOverlayStyle(
                          statusBarColor: Colors.transparent,
                          statusBarIconBrightness: Brightness.dark,
                          statusBarBrightness: Brightness.dark,
                        )
                    )),

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
              );
            }
        )
    );
  }

}