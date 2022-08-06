import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TodoApp',
      home: TopPage(),
    );
  }
}

class TopPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TodoApp using StreamBuilder')),
      body: ListView(),
      floatingActionButton: FloatingActionButton.extended(
        label: Row(
          children: const [
            Icon(
              Icons.arrow_right,
              size: 32,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              'Create Todo',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return CreateTodo();
          }));
        },
      ),
    );
  }
}

class CreateTodo extends StatelessWidget {
  String inputValue = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Todo')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              style: const TextStyle(fontSize: 16),
              decoration: const InputDecoration(
                  hintText: 'Enter Todo',
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue))),
              maxLines: 8,
              onChanged: (String value) {
                inputValue = value;
              },
            ),
            const SizedBox(height: 24),
            SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(width: 1.0, color: Colors.blue)),
                    onPressed: () {},
                    child: const Text('Create Todo'))),
          ],
        ),
      ),
    );
  }
}
