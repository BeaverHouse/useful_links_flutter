import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:useful_links_app/providers/firestore_provider.dart';
import 'package:useful_links_app/widgets/molecules/link_widget.dart';

class LinkView extends StatefulWidget {

  const LinkView({super.key});

  @override
  State<LinkView> createState() => _LinkViewState();
}

class _LinkViewState extends State<LinkView> {

  TextEditingController searchController = TextEditingController();
  String search = "";

  final List<String> options = [
    "방문수가 많은 순", 
    "최근 방문 순", 
    "방문수가 적은 순", 
    "예전 방문 순", 
    "삭제된 링크"
  ];
  String selectedValue = "0";

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: StreamBuilder(
        stream: context.watch<StoreProvider>().dataStream,
        builder: ((context, snapshot) {
          if(snapshot.hasData) {
            final arr = snapshot.data?.docs
                    .where((d) => d["name"].toString().contains(search));
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Center(
                  child: Text("수정 : 꾹 누르세요!"),
                ),
                const Center(
                  child: Text("삭제 : 왼쪽으로 드래그!"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                  child: TextField(
                    controller: searchController,
                    onChanged: ((value) {
                      setState(() {
                        search = value;
                      });
                    }),
                    decoration: const InputDecoration(
                        labelText: "검색",
                        hintText: "검색",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                    )
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0, left: 20.0, right: 20.0),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2(
                      hint: Text(
                        '필터',
                        style: TextStyle(
                          fontSize: 14,
                          color: Theme
                                  .of(context)
                                  .hintColor,
                        ),
                      ),
                      items:  options.asMap().entries.map((entry) =>
                              DropdownMenuItem<String>(
                                value: entry.key.toString(),
                                child: Text(
                                  entry.value,
                                  style: const TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                              ))
                              .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                        Provider.of<StoreProvider>(context, listen: false).changeSortData(selectedValue);
                      },
                      buttonHeight: 40,
                      buttonWidth: 140,
                      itemHeight: 40,
                    ),
                  )
                ),
                Flexible (
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Column(
                      children: [
                        ...arr!.map((e) => 
                          LinkWidget(data: e)
                        ),
                      ]
                    ),
                  ),
                )               
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        })
      ),
    );
  }
}