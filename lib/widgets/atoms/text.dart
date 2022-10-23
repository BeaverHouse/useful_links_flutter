import 'package:flutter/cupertino.dart';

// 메뉴를 표시해 주는 글씨 포맷
class InfoText extends StatelessWidget {

  final String title;

  const InfoText({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 30
          ),
        ),
      )
    );
  }
}