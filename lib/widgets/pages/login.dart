import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/utils/validator.dart';
import 'package:useful_links_app/widgets/atoms/button.dart';
import 'package:useful_links_app/widgets/atoms/input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final emailController = TextEditingController();
  final pwController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(
            child: Text(
              'Useful Links',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 30
              ),
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              children: [
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
                NormalButton(
                  onPressed: (){
                    if (_formKey.currentState!.validate()) {
                      Provider.of<AuthProvider>(context, listen: false).signIn(
                        context, 
                        emailController.text, 
                        pwController.text
                      );
                    }
                  }, 
                  label: "로그인"
                )
              ],
            )
          ),
        ],
      )
    );
  }
}