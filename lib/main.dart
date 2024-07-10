import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const ResumenApp());
}

class ResumenApp extends StatelessWidget {
  const ResumenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resumen Automático',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const ResumenHomePage(),
    );
  }
}

class ResumenHomePage extends StatefulWidget {
  const ResumenHomePage({super.key});

  @override
  _ResumenHomePageState createState() => _ResumenHomePageState();
}

class _ResumenHomePageState extends State<ResumenHomePage> {
  final TextEditingController _controller = TextEditingController();
  String _resumen = "";
  bool _loading = false;

  Future<void> _getResumen() async {
    setState(() {
      _loading = true;
    });

    final response = await http.post(
      Uri.parse(
          'https://summary-generator-maqi.onrender.com/resumir'), // Cambia esto a la dirección de tu servidor si es necesario
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'texto': _controller.text,
        'num_sentences': 3,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _resumen = jsonDecode(response.body)['resumen'];
      });
    } else {
      throw Exception('Failed to load resumen');
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Generador de Resumen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: 'Introduce el texto aquí...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getResumen,
              child: _loading
                  ? const SizedBox(
                      child: CircularProgressIndicator(),
                      width: 20,
                      height: 20,
                    )
                  : const Text('Generar Resumen'),
            ),
            const SizedBox(height: 20),
            Text(
              _resumen,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
