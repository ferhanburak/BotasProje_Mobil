import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  final CollectionReference _products =
      FirebaseFirestore.instance.collection('products');

  final _productNameController = TextEditingController();
  final _productCountController = TextEditingController();

  Future<void> _update([DocumentSnapshot? documentSnapshot]) async {
    if (documentSnapshot != null) {
      _productNameController.text = documentSnapshot['productName'];
      _productCountController.text =
          documentSnapshot['productCount'].toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ürünler"),
      ),
      body: StreamBuilder(
        stream: _products.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
              itemCount: streamSnapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final DocumentSnapshot documentSnapshot =
                    streamSnapshot.data!.docs[index];
                return Card(
                  margin: const EdgeInsets.all(7),
                  child: ListTile(
                    title: Text("${documentSnapshot['productName']}"),
                    subtitle: Text(
                        "Adet : ${documentSnapshot['productCount'].toString()}"),
                    trailing: SizedBox(
                      width: 70,
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _dialogBuilder(documentSnapshot),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  void _dialogBuilder(DocumentSnapshot documentSnapshot) {
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
              CupertinoTextField(
                controller: _productCountController,
                placeholder: "Ürün sayısı giriniz",
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
                  print("num: $num ----- productCount : $productCount");

                  if (num >= productCount) {
                    await _products.doc(documentSnapshot!.id).update({
                      // "productName": productName,
                      "productCount": num - productCount
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
