import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/utils/validator.dart';
import 'package:useful_links_app/widgets/atoms/button.dart';
import 'package:useful_links_app/widgets/atoms/input.dart';
import 'package:useful_links_app/widgets/atoms/text.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final pwController = TextEditingController();
  final pwCheckController = TextEditingController();
  
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
              const InfoText(title: "회원가입"),
              Form(
                key: _formKey,
                autovalidateMode: autoValidate,
                child: Column(
                  children: [
                    FormInput(
                      validator: (val) => nameValidate(val), 
                      controller: nameController, 
                      label: "이름", 
                      placeholder: "이름을 입력해 주세요.", 
                    ),
                    FormInput(
                      validator: (val) => emailValidate(val), 
                      controller: emailController, 
                      label: "이메일", 
                      placeholder: "이메일을 입력해 주세요.", 
                    ),
                    FormInput(
                      validator: (val) => passwordValidate(val), 
                      controller: pwController, 
                      label: "비밀번호", 
                      placeholder: "비밀번호를 입력해 주세요.", 
                      isPassword: true,
                    ),
                    FormInput(
                      validator: (val) => val != pwController.text ? "비밀번호 불일치" : null, 
                      controller: pwCheckController, 
                      label: "비밀번호 확인", 
                      placeholder: "비밀번호를 다시 입력해 주세요.", 
                      isPassword: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          NormalButton(
                            onPressed: (){
                              if (_formKey.currentState!.validate()) {
                                Provider.of<AuthProvider>(context, listen: false).register(
                                  context, 
                                  nameController.text,
                                  emailController.text, 
                                  pwController.text
                                );
                              } else {
                                setState(() {
                                  autoValidate = AutovalidateMode.onUserInteraction;
                                });
                              }
                            }, 
                            label: "회원가입"
                          ),
                          NormalButton(
                            onPressed: (){
                              Navigator.pop(context);
                            }, 
                            label: "Back"
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