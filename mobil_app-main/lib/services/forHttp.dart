import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForHttp extends StatefulWidget {
  @override
  _ForHttpState createState() => _ForHttpState();
}

class _ForHttpState extends State<ForHttp> {
  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('http://10.10.208.123:8080/web'));
    if (response.statusCode == 200) {
      print('Başarılı cevap: ${response.body}');
    } else {
      print('İstek başarısız: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tasarım kodları

    return Scaffold(
      appBar: AppBar(
        title: Text('Ürünler'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            fetchData();
          },
          child: Text('Web Servisi isteği'),
        ),
      ),
    );
  }
}
