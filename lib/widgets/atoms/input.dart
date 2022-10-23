import 'package:flutter/material.dart';

// 로그인, 회원가입 등에 사용하는 input
class FormInput extends StatelessWidget {
  
  /// [validator] 식별자
  /// [controller] 값을 저장할 controller
  /// [label] 라벨
  /// [placeholder]
  /// [isPassword] 비밀번호 여부
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final String label;
  final String placeholder;
  final bool isPassword;
  final bool isEnd;

  const FormInput({
    super.key, 
    required this.controller,
    required this.label,
    required this.placeholder, 
    this.validator,
    this.isPassword = false,
    this.isEnd = false
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0),
      child: TextFormField(
        validator: validator,
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
          hintText: placeholder
        ),
        textInputAction: isEnd ? TextInputAction.done : TextInputAction.next,
      )
    );
  }
}