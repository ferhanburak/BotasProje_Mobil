import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mpaiapp/Widgets/MyCard.dart';
import 'package:mpaiapp/services/HttpService.dart';
import 'package:path_provider/path_provider.dart';

class GallerySelectScreen extends StatefulWidget {
  @override
  _GallerySelectScreenState createState() => _GallerySelectScreenState();
}

class _GallerySelectScreenState extends State<GallerySelectScreen> {
  final _products = FirebaseFirestore.instance.collection('products');

  List<QueryDocumentSnapshot<Map<String, dynamic>>> products = [];

  Uint8List? imageFile;
  File? compressedFile;
  String? endValue;

  final _picker = ImagePicker();

  String values = '';
  List<String> results = [];
  Map<String, dynamic> end = {};

  Map<String, dynamic> short_end = {};
  XFile? image;

  //base64
  void _pickImageBase64Gallery(ImageSource source) async {
    // const maxSize = 146 * 146;
    final image = await _picker.pickImage(
      source: source,
      imageQuality: 25,
      maxHeight: 600,
      maxWidth: 600,
    );

    if (image == null) {
      print("resim değeri null");
      Navigator.pop(context);
      return;
    }

    imageFile = await image.readAsBytes();

    setState(() {});

    String base64String = base64Encode(imageFile!);

    //son hali nasıl
    print(base64String.length);
    print(base64String);

    //json formatında post etme
    print("JSONN");
    var json = jsonEncode({'image': base64String});
    print(json);

    final response = await HttpService.post('', {'image': base64String});
    values = response.body;
    results = values.split(",");
    for (var i = 0; i < results.length; i++) {
      var deger = results[i].split(":");
      var key = deger[0];
      var value = deger[1];
      end[key] = value;
    }

    print("---------------------------");
    setState(() {
      values;
      end;
    });

    print(values);
    print("val : ${values}");

    if (response.statusCode == 200) {
      print('Başarılı cevap: ${response.body}');
    } else {
      print('İstek başarısız: ${response.statusCode}');
    }
  }

  void _dialogMinusPlusBuilder(
      QueryDocumentSnapshot<Object?> documentSnapshot) {
    final _productNameController = TextEditingController();
    final _productCountController = TextEditingController();

    Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
      if (documentSnapshot != null) {
        _productNameController.text = documentSnapshot['productName'];
        _productCountController.text =
            documentSnapshot['productCount'].toString();
      }
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ürünü Güncelleyin'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 5,
              ),
              Text(
                "Ürün Adı : ${documentSnapshot["productName"]}\nMevcut Adet : ${documentSnapshot["productCount"]}",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 5,
              ),
              TextField(
                controller: _productCountController,
                decoration: InputDecoration(
                  hintText: "Ürün sayısı giriniz",
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Ekle'),
              onPressed: () async {
                final String productName = _productNameController.text;
                final int? productCount =
                    int.tryParse(_productCountController.text);
                _update(documentSnapshot);
                if (productCount != null) {
                  int num = int.parse(_productCountController.text);
                  await _products.doc(documentSnapshot!.id).update({
                    // "productName": productName,
                    "productCount": productCount + num
                  });
                  _productNameController.text = "";
                  _productCountController.text = "";
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Eksilt'),
              onPressed: () async {
                final String productName = _productNameController.text;
                final int? productCount =
                    int.tryParse(_productCountController.text);
                _update(documentSnapshot);
                if (productCount != null) {
                  int num = int.parse(_productCountController.text);
                  print("num : $num ---- productCount : $productCount");
                  print("dogru yere geliyor");

                  if (num >= productCount) {
                    await _products.doc(documentSnapshot!.id).update({
                      // "productName": productName,
                      "productCount": num - productCount,
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Ürün çıkartma yapamazsınız.'),
                      ),
                    );
                  }

                  _productNameController.text = "";
                  _productCountController.text = "";
                }
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Çıkış'),
              onPressed: () {
                if (mounted) {
                  Navigator.of(context).popUntil(
                    (route) => route.settings.name == '/gallery',
                  );

// Navigator.pushNamed(context, "/checkImageScreen");
                }

                /*
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).pop();
                });
                */
              },
            ),
          ],
        );
      },
    );
  }

  void checkProduct(String id) {
    final matchedProducts = products
        .where(
          (snapshot) => snapshot['productName'] == id,
        )
        .toList();
    print("gelen product name : $id");
    print(matchedProducts);

    if (matchedProducts.isNotEmpty) {
      _dialogMinusPlusBuilder(matchedProducts.first);
    }
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? listener;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final source = ModalRoute.of(context)!.settings.arguments as ImageSource;

      _pickImageBase64Gallery(source);

      listener = _products.snapshots().listen((snapshot) {
        products = snapshot.docs;
      });
    });
  }

  @override
  void dispose() {
    listener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünler'),
      ),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          imageFile == null
              ? Container(
                  child: Text("Henüz resim yüklemediniz."),
                  padding: EdgeInsets.symmetric(vertical: 50),
                )
              : Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * .4,
                      child: Image.memory(
                        imageFile!,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: SizedBox(
                        child: Text(
                          "Görüntüyü hangi nesne sınıfına kaydetmek istediğinizi seçiniz.",
                          style: TextStyle(fontSize: 17, fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                    for (var i in end.keys)
                      MyCard(
                        i,
                        i + ":" + end[i],
                        onTap: () {
                          checkProduct(i);
                        },
                      ),
                  ],
                )
        ],
      ),
    );
  }
}
