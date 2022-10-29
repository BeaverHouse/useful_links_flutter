import 'package:flutter/material.dart';

class ConfirmDialog extends StatefulWidget {
  final String confirmMsg;
  final void Function() confirmFunc;

  const ConfirmDialog({super.key, required this.confirmMsg, required this.confirmFunc});

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {


  @override
  Widget build(BuildContext context) {
    return AlertDialog(          
          title: const Text('확인'),
          insetPadding: const EdgeInsets.all(20),
          content: Text(widget.confirmMsg),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('아니오'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              onPressed: widget.confirmFunc,
              child: const Text('네'),
            ),
          ],
        );
  }
}