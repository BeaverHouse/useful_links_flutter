import 'package:flutter/material.dart';

// 일반적인 버튼
class NormalButton extends StatelessWidget {
  
  final void Function() onPressed;
  final String label;

  const NormalButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0)
          ),
          minimumSize: const Size(100,40),
        ),
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}