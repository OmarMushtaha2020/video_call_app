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

import '../module/register_screen.dart';

class AppCubit extends Cubit<AppStatus>{

  AppCubit() : super(InitialState());
  static AppCubit get(context)=>BlocProvider.of(context);
  void  login(String email,String password,context){
    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {
     emit(LoginCompletedSuccessfully());
     Navigator.pushNamedAndRemoveUntil(context, "/home_page", (route) => false);

    });

  }
  void register(String email,String password,String name,String phoneNumber,context){
    FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.toString().trim(), password: password.toString().trim()).then((value) {

      FirebaseFirestore.instance.collection("user").add({
        "name":name,"email":email,"phoneNumber":phoneNumber,"id":""
      }).then((value) {
        token=value.id;
        CacthHelper.saveData("token", token);
        print(token);
getData();
        FirebaseFirestore.instance.collection("user").doc(value.id).update({"id":value.id}).then((value) {
          onUserLogin(name,name);
          Navigator.pushNamedAndRemoveUntil(context, "/home_page", (route) => false);

          emit(AccountCreationCompletedSuccessfully());

        });


      });
    });

  }
  void onUserLogin(String name,String id) {
    callController ??= ZegoUIKitPrebuiltCallController();

    /// 4/5. initialized ZegoUIKitPrebuiltCallInvitationService when account is logged in or re-logged in
    ZegoUIKitPrebuiltCallInvitationService().init(
      appID: 2096738575 /*input your AppID*/,
      appSign: "c005f1fd4436946f1855d26ca214fcba0544baf6d2850ef0d64414510094ce14" /*input your AppSign*/,
      userID: name,
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
  void  getData(){
    user=[];
    emit(ClearDataSuccessfully());
    FirebaseFirestore.instance.collection("user").get().then((value) {
      value.docs.forEach((element) {
        if(element.data()['id']!=token){
          user.add(element);

        }
      });
      emit(GetDataSuccessfully());

    });
    emit(GetDataSuccessfully());

  }
  void getDataUser(){
    if(token==null){
      print("yes");
    }else {
        FirebaseFirestore.instance.collection("user").doc(token).get().then((value) {

          onUserLogin(value.data()?['name'], value.data()?['name']);
          emit(GetUserDataSuccessfully());

        });
        emit(GetUserDataSuccessfully());
      }
  }

}