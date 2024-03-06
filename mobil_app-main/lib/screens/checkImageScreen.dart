import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CheckImageScreen extends StatefulWidget {
  const CheckImageScreen({super.key});

  @override
  State<CheckImageScreen> createState() => _CheckImageScreenState();
}

class _CheckImageScreenState extends State<CheckImageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(
            onPressed: () {
              if (mounted) {
                Navigator.pushNamed(context, "/products");
              }
            },
            icon: const Icon(Icons.folder))
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Resmi nereden yükleyeceğinizi seçiniz.",
                  style: TextStyle(fontSize: 17),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/gallery",
                      arguments: ImageSource.gallery,
                    );
                  },
                  child: const Text("Galeriden  seç"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      "/gallery",
                      arguments: ImageSource.camera,
                    );
                  },
                  child: const Text("Kameradan al"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
