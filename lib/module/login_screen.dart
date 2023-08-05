import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/cubit/status.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
var email =TextEditingController();
   var password =TextEditingController();
var formKey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStatus>(
      listener: ( context,  state){},
      builder: (context,state){
        return Scaffold(
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              alignment: Alignment.center,
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Text("Login",style: TextStyle(
                        fontSize: 30.sp,fontWeight: FontWeight.w700,
                      ),),
                       SizedBox(height: 50.h,),
                      TextFormField(controller: email,
                        decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "email",

                      ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Email mustn't be empty";
                        }
                      },
                      ),
                       SizedBox(height: 20.h,),
                      TextFormField(controller: password,decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "password",
                      ),
                        validator: (value){
                          if(value!.isEmpty){
                            return "Password mustn't be empty";
                          }
                        },
                      ),
                       SizedBox(height: 20.h,),
                      Container(
                        height: 50.h,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                        ),
                        child: MaterialButton(onPressed: (){
                          if(formKey.currentState!.validate()){
AppCubit.get(context).login(email.text, password.text, context);
                          }
                        },child:  Text("Login",style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp
                        ),),),
                      ),
                       SizedBox(height: 20.h,),
                      Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                        const Text("Don't have an account"),
                         SizedBox(height: 10.h,),
                        TextButton(onPressed: (){
                          Navigator.pushNamedAndRemoveUntil(context, "/register_screen", (route) => false);

                        }, child: const Text("register"))
                      ],),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
