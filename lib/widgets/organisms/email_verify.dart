import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/auth_provider.dart';
import 'package:useful_links_app/widgets/atoms/button.dart';
import 'package:useful_links_app/widgets/atoms/text.dart';

class EmailVerifyForm extends StatefulWidget {
  const EmailVerifyForm({super.key});

  @override
  State<EmailVerifyForm> createState() => _EmailVerifyFormState();
}

class _EmailVerifyFormState extends State<EmailVerifyForm> {

  String date = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const InfoText(title: "이메일 인증"),
              const Text("이메일을 인증해 주세요."),
              const SizedBox(height: 20),
              NormalButton(
                onPressed: (){
                  Provider.of<AuthProvider>(context, listen: false).sendEmailVerify(context);
                }, 
                label: "이메일 인증 발송"
              ),
              const SizedBox(height: 50),
              const Text("인증 완료 후에는 오른쪽 위의 새로고침 버튼을 눌러 주세요.")
            ],
          )
        )
      );
  }
}