import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/firestore_provider.dart';
import 'package:useful_links_app/utils/validator.dart';
import 'package:useful_links_app/widgets/atoms/input.dart';

class AddDialog extends StatefulWidget {
  const AddDialog({super.key});

  @override
  State<AddDialog> createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  final nameController = TextEditingController();
  final linkController = TextEditingController();
  
  final _formKey = GlobalKey<FormState>();
  AutovalidateMode autoValidate = AutovalidateMode.disabled;


  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AlertDialog(          
          title: const Text('링크 등록'),
          insetPadding: const EdgeInsets.all(20),
          content: SizedBox(
            width: width-50,
            child: Form(
              key: _formKey,
              autovalidateMode: autoValidate,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FormInput(
                    controller: nameController, 
                    label: "이름", 
                    placeholder: "이름을 입력해 주세요.", 
                  ),
                  FormInput(
                    validator: (val) => linkValidate(val),
                    controller: linkController, 
                    label: "링크", 
                    placeholder: "링크를 붙여넣어 주세요.",
                    isEnd: true,
                  )
                ],
              )
            )
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('확인'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Provider.of<StoreProvider>(context, listen: false).addData(
                    context,
                    nameController.text, 
                    linkController.text
                  );
                } else {                               
                  setState(() {
                    autoValidate = AutovalidateMode.onUserInteraction;
                  });
                }
              },
            ),
          ],
        );
  }
}