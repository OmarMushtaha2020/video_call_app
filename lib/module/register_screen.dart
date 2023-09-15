
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/cubit/status.dart';
int ?randomNumber;

String? token;

class RegisterScreen extends StatefulWidget {
  RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  var email =TextEditingController();

  var password =TextEditingController();

  var name =TextEditingController();

  var phoneNumber =TextEditingController();
  var formKey=GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStatus>(
      listener: (context,status){},
      builder: (context,status){
        return  Scaffold(
          body: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.w),
            child: Container(
              alignment: Alignment.center,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                     Text("Register",style: TextStyle(
                      fontSize: 30.sp,fontWeight: FontWeight.w700,
                    ),),
                     SizedBox(height: 30.h,),
                    TextFormField(controller: name, decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "name",

                    ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Name mustn't be empty";
                        }
                      },
                    ),
                     SizedBox(height: 20.h,),

                    TextFormField(controller: email,  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "email",
                    ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "Email mustn't be empty";
                        }
                      },),
                     SizedBox(height: 20.h,),
                    TextFormField(keyboardType: TextInputType.phone,controller: phoneNumber, decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "phoneNumber",
                    ),
                      validator: (value){
                        if(value!.isEmpty){
                          return "PhoneNumber mustn't be empty";
                        }
                      },
                    ),
                     SizedBox(height: 20.h,),
                    TextFormField(controller: password,decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "password",
                    ),    validator: (value){
                      if(value!.isEmpty){
                        return "PhoneNumber mustn't be empty";
                      }
                    }),
                     SizedBox(height: 20.h,),
                    Container(
                      height: 50.h,
                      width: double.infinity,
                      color: Colors.blue,
                      child: MaterialButton(onPressed: (){
                        if(formKey.currentState!.validate()){
AppCubit.get(context).register(email.text, password.text, name.text, phoneNumber.text, context);

                        }
                      },child:  Text("register",style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp
                      ),),),
                    ),
                     SizedBox(height: 20.h,),
                    Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                      const Text("already have an account"),
                       SizedBox(height: 10.h,),
                      TextButton(onPressed: (){
                        Navigator.pushNamedAndRemoveUntil(context, "/login_screen", (route) => false);


                      }, child: const Text("login"))
                    ],),
                  ],
                )
        )
        )
        )
        );
    }


    );
  }
}
