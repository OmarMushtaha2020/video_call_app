
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit,AppStatus>(
      listener: (context,status){},
      builder: (context,status){
        return  Scaffold(
          appBar: AppBar(
            title: const Text("Register Screen"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 150,),

                  const Text("Register",style: TextStyle(
                    fontSize: 30,fontWeight: FontWeight.w700,
                  ),),
                  const SizedBox(height: 30,),
                  TextFormField(controller: name, decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "name",
                  ),),
                  const SizedBox(height: 20,),

                  TextFormField(controller: email,  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "email",
                  ),),
                  const SizedBox(height: 20,),
                  TextFormField(controller: phoneNumber, decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "phoneNumber",
                  ),),
                  const SizedBox(height: 20,),
                  TextFormField(controller: password,decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "password",
                  )),
                  const SizedBox(height: 20,),
                  Container(
                    height: 50,
                    width: double.infinity,
                    color: Colors.blue,
                    child: MaterialButton(onPressed: (){
                      if(email.text.isNotEmpty&&password.text.isNotEmpty){
AppCubit.get(context).register(email.text, password.text, name.text, phoneNumber.text, context);

                      }
                    },child: const Text("register",style: TextStyle(
                      color: Colors.white,
                    ),),),
                  ),
                  const SizedBox(height: 20,),
                  Row(mainAxisAlignment: MainAxisAlignment.center,children: [
                    const Text("already have an account"),
                    const SizedBox(height: 10,),
                    TextButton(onPressed: (){
                      Navigator.pushNamedAndRemoveUntil(context, "/login_screen", (route) => false);


                    }, child: const Text("login"))
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
