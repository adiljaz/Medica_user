import 'package:fire_login/screens/home/homewidgets/searchbar.dart';
import 'package:fire_login/utils/colors/colormanager.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

// ignore: must_be_immutable
class SearchPage extends StatelessWidget {
 SearchPage({super.key});

  TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colormanager.scaffold,
      body: Padding(
        padding: const EdgeInsets.only(  top: 15,   left:10,right: 10),
        child: Column(

          children: [
            Searchfield(
              
              icons:Icon(IconlyLight.search ),
                controller: _search,
                value: (value) {
                  return null;
                }),
            // ListView.builder(itemBuilder: itemBuilder)
          ],
        ),
      ),
    ));
  }
}
