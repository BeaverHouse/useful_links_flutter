import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/utils/validator.dart';
import 'package:useful_links_app/widgets/atoms/button.dart';
import 'package:useful_links_app/widgets/atoms/input.dart';
import 'package:useful_links_app/widgets/atoms/text.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const InfoText(title: "Useful Links"),
              Form(
                key: _formKey,
                autovalidateMode: autoValidate,
                child: Column(
                  children: [
                    FormInput(
                      validator: (val) => emailValidate(val), 
                      controller: emailController, 
                      label: "이메일", 
                      placeholder: "이메일을 입력해 주세요.", 
                    ),
                    FormInput(
                      controller: pwController, 
                      label: "비밀번호", 
                      placeholder: "비밀번호를 입력해 주세요.", 
                      isPassword: true,
                      isEnd: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NormalButton(
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                Provider.of<AuthProvider>(context, listen: false).signIn(
                                  context, 
                                  emailController.text, 
                                  pwController.text
                                );
                              } else {                                
                                setState(() {
                                  autoValidate = AutovalidateMode.onUserInteraction;
                                });
                              }
                            }, 
                            label: "로그인"
                          ),
                          NormalButton(
                            onPressed: (){
                              Navigator.pushNamed(context, "/register");
                            }, 
                            label: "회원가입"
                          )
                        ],
                      ),
                    ),
                  ],
                )
              ),
            ],
          )
        )
      )
    );
  }
}