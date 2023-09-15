import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/cubit/status.dart';
import 'package:video_voice_call/module/login_service.dart';
import 'package:video_voice_call/module/register_screen.dart';
import 'package:video_voice_call/shared/network/local/cacth_helper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
@override
  void initState() {
super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStatus>(
      listener: (context,status){

      },
      builder: (context,status) {
        return SafeArea(
          child:
          Scaffold(

            appBar: AppBar(
              centerTitle: false,
              actions: [logoutButton(),],
              backgroundColor: Colors.blue,
              title: Text("User", style: TextStyle(
                fontSize: 20.sp,
              ),),
            ),


            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: Stack(
                  alignment: Alignment.center,
                  children: [
                    AppCubit
                        .get(context)
                        .user
                        .isEmpty ? Center(
                      child: Text("There is No User", style: TextStyle(
                          fontSize: 50.h
                      ),),
                    ) : userListView(),

                  ]
              ),
            ),
          ),
        );
      }
    );
  }

  Widget logoutButton() {
    return Ink(
      width: 35,
      height: 35,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: const Icon(Icons.exit_to_app_sharp),
        iconSize: 20.h,
        color: Colors.white,
        onPressed: () {
    onUserLogout().then((value){
    token='';
    CacthHelper.saveData("token", "$token");

    Navigator.pushNamedAndRemoveUntil(context, "/login_screen", (route) => false);
    });
    },
    )
    );

  }

  Widget userListView() {

    return Padding(
      padding:  EdgeInsets.only(top: 10.h),


      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: AppCubit.get(context).user.length,
        itemBuilder: (context, index) {
           TextEditingController inviteeUsersIDTextCtrl=TextEditingController();
           inviteeUsersIDTextCtrl.text = AppCubit.get(context).user[index]['token'];
print(AppCubit.get(context).user[index]['name']);



           return Padding(
             padding: const EdgeInsets.only(left: 10,right: 10,top: 10),
             child: Column(
              children: [
                Row(
                  children: [
                    Text("${AppCubit.get(context).user[index]['name']}",style: TextStyle(
                      fontSize: 16.sp
                    ),),
                     SizedBox(width: 20.w),
                     SizedBox(width: 20.h),
                    Expanded(child: Container()),
                    sendCallButton(
                      isVideoCall: false,
                      inviteeUsersIDTextCtrl: inviteeUsersIDTextCtrl,
                      onCallFinished: onSendCallInvitationFinished,
                    ),
                    sendCallButton(
                      isVideoCall: true,
                      inviteeUsersIDTextCtrl: inviteeUsersIDTextCtrl,
                      onCallFinished: onSendCallInvitationFinished,
                    ),
                  ],
                ),
                 Padding(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 1.w),
                  child: Divider(height: 1.h, color: Colors.grey),
                ),
              ],
          ),
           );
        },
      ),
    );
  }

  void onSendCallInvitationFinished(
      String code,
      String message,
      List<String> errorInvitees,
      ) {
    if (errorInvitees.isNotEmpty) {
      var userIDs = '';
      for (var index = 0; index < errorInvitees.length; index++) {
        if (index >= 5) {
          userIDs += '... ';
          break;
        }

        final userID = errorInvitees.elementAt(index);
        userIDs += '$userID ';
      }
      if (userIDs.isNotEmpty) {
        userIDs = userIDs.substring(0, userIDs.length - 1);
      }

      var message = "User doesn't exist or is offline: $userIDs";
      if (code.isNotEmpty) {
        message += ', code: $code, message:$message';
      }
      // showToast(
      //   message,
      //   position: StyledToastPosition.top,
      //   context: context,
      // );
    } else if (code.isNotEmpty) {
      // showToast(
      //   'code: $code, message:$message',
      //   position: StyledToastPosition.top,
      //   context: context,
      // );
    }
  }
}



Widget sendCallButton({
  required bool isVideoCall,
  required TextEditingController inviteeUsersIDTextCtrl,
  void Function(String code, String message, List<String>)? onCallFinished,
}) {
  return ValueListenableBuilder<TextEditingValue>(
    valueListenable: inviteeUsersIDTextCtrl,
    builder: (context, inviteeUserID, _) {
      final invitees = getInvitesFromTextCtrl(inviteeUsersIDTextCtrl.text);

      return ZegoSendCallInvitationButton(
        isVideoCall: isVideoCall,
        invitees: invitees,
        resourceID: 'zego_data',
        iconSize: const Size(40, 40),
        buttonSize: const Size(50, 50),
        onPressed: onCallFinished,
      );
    },
  );
}

List<ZegoUIKitUser> getInvitesFromTextCtrl(String textCtrlText) {
  final invitees = <ZegoUIKitUser>[];

  final inviteeIDs = textCtrlText.trim().replaceAll('，', '');
  inviteeIDs.split(',').forEach((inviteeUserID) {
    if (inviteeUserID.isEmpty) {
      return;
    }

    invitees.add(ZegoUIKitUser(
      id: inviteeUserID,
      name: 'user_$inviteeUserID',
    ));
  });

  return invitees;
}
// ZegoUIKitUser(id: "4upzfD3sm7X6OLsHnkwdNMDe3QB2", name: "video"),
// ZegoUIKitUser(id: "Q7oZyEMCUPeALuZWmC0EA8lSrTu1", name: "omar"),
// ZegoUIKitUser(id: "1YyLSHedGyNhNlAgr1vWed8nFgj1", name: "smg"),
