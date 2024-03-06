import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyCard extends StatelessWidget {
  MyCard(this.value, this.forString, {this.onTap, super.key});

  final String value;
  final String forString;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          title: Center(child: Text(" $forString ")),
          trailing: SizedBox(
            width: 100,
          ),
        ),
      ),
    );
  }
}
