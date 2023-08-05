import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_voice_call/module/common.dart';
import 'package:video_voice_call/cubit/status.dart';
import 'package:video_voice_call/module/login_service.dart';
import 'package:video_voice_call/shared/network/local/cacth_helper.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';
import 'package:zego_uikit_signaling_plugin/zego_uikit_signaling_plugin.dart';

String ?token='';

class AppCubit extends Cubit<AppStatus>{

  AppCubit() : super(InitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  void  login(String email,String password,context){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
      token=value.user?.uid;
      CacthHelper.saveData("token", token);

FirebaseFirestore.instance.collection("user").where("token",isEqualTo: token).get().then((value){
  value.docs.forEach((element) {
    onUserLogin(element.data()['token'], element.data()['name']);
    getData(token!);
    emit(LoginCompletedSuccessfully());
    Navigator.pushNamedAndRemoveUntil(context, "/home_page", (route) => false);
  });

});



    });

  }
  void register(String email, String password, String name, String phoneNumber, BuildContext context) {
    // Create a new user with email and password using FirebaseAuth
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      token=value.user?.uid;

      CacthHelper.saveData("token", token);

      FirebaseFirestore.instance.collection("user").add({
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
        "token": token,
        "id":"",
      }).then((value) {
        onUserLogin(token!,name); // Assuming this is a function you want to call after login

        FirebaseFirestore.instance.collection("user").doc(value.id).update({"id":value.id}).then((value){
          getData(token!).then((value) {
            Navigator.pushNamedAndRemoveUntil(context, "/home_page", (route) => false);
            emit(AccountCreationCompletedSuccessfully());
          });


        });
        emit(AccountCreationCompletedSuccessfully());

        // You can call the 'onUserLogin' function and navigate after completing the operations above
        // onUserLogin(name, name);
        // Navigator.pushNamedAndRemoveUntil(context, "/home_page", (route) => false);
        // emit(AccountCreationCompletedSuccessfully());
      });
      emit(AccountCreationCompletedSuccessfully());

    }).catchError((error) {
      // If there is an error during registration, you can handle it here
      print("Error during registration: ${error.toString()}");
    });
  }  Future<void> onUserLogin(String tokens,String name) async {
    callController ??= ZegoUIKitPrebuiltCallController();

    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2096738575 /*input your AppID*/,
      appSign: "c005f1fd4436946f1855d26ca214fcba0544baf6d2850ef0d64414510094ce14" /*input your AppSign*/,
      userID: tokens,
      userName: name,
      notifyWhenAppRunningInBackgroundOrQuit: false,
      plugins: [ZegoUIKitSignalingPlugin()],
      controller: callController,
      requireConfig: (ZegoCallInvitationData data) {
        final config = (data.invitees.length > 1)
            ? ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.groupVideoCall()
            : ZegoUIKitPrebuiltCallConfig.groupVoiceCall()
            : ZegoCallType.videoCall == data.type
            ? ZegoUIKitPrebuiltCallConfig.oneOnOneVideoCall()
            : ZegoUIKitPrebuiltCallConfig.oneOnOneVoiceCall();

        config.avatarBuilder = customAvatarBuilder;

        /// support minimizing, show minimizing button
        config.topMenuBarConfig.isVisible = true;
        config.topMenuBarConfig.buttons
            .insert(0, ZegoMenuBarButtonName.minimizingButton);

        return config;
      },
    );
    emit(ZegoUIKitPrebuiltCallInvitationSuccessfully());
  }

  List user=[];
  Future<void>  getData(String? token) async {
    user=[];
    emit(ClearDataSuccessfully());
    if(token!=null){
      FirebaseFirestore.instance.collection("user").get().then((value) {
        print("the length is ${value.docs.length}");
        print("the token  is ${token}");

        value.docs.forEach((element) {
          if(element.data()['token']!=token){
            user.add(element);

          }
        });
        emit(GetDataSuccessfully());

      });
      emit(GetDataSuccessfully());
    }


  }
  void getDataUser(String? token){

    if(token==null){
      print("yes");
    }else {

      FirebaseFirestore.instance.collection("user").where("token",isEqualTo: token).get().then((value) {
        print("my length is ${value.docs.length}");
        value.docs.forEach((element) {

          onUserLogin(element.data()['token'],element.data()['name']);
          emit(GetUserDataSuccessfully());
        });




      });
      emit(GetUserDataSuccessfully());
    }
  }

}