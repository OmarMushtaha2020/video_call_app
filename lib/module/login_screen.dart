import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_voice_call/cubit/bloc.dart';
import 'package:video_voice_call/cubit/status.dart';

class LoginScreen extends StatelessWidget {
   LoginScreen({Key? key}) : super(key: key);
var email =TextEditingController();
   var password =TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStatus>(
      listener: ( context,  state){},
      builder: (context,state){
        return Scaffold(
          appBar: AppBar(
            title: const Text("Login Screen"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 150,),
                  const Text("Login",style: TextStyle(
                    fontSize: 30,fontWeight: FontWeight.w700,
                  ),),
                  const SizedBox(height: 50,),
                  TextFormField(controller: email,
                    decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "email",
                  ),),
                  const SizedBox(height: 20,),
                  TextFormField(controller: password,decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "password",
                  ),),
                  const SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: MaterialButton(onPressed: (){
                      if(email.text.isNotEmpty&&password.text.isNotEmpty){
AppCubit.get(context).login(email.text, password.text, context);
                      }
                    },child: const Text("Login",style: TextStyle(
                      color: Colors.white,
                    ),),),
                  ),
                  const SizedBox(height: 20,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    const Text("Don't have an account"),
                    const SizedBox(height: 10,),
                    TextButton(onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, "/register_screen", (route) => false);

                    }, child: const Text("register"))
                  ],),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
