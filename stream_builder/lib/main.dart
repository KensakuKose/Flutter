import 'package:cloud_firestore/cloud_firestore.dart';
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
  final _todosStream =
      FirebaseFirestore.instance.collection('todos').snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TodoApp using StreamBuilder')),
      body: StreamBuilder(
          stream: _todosStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data!.docs
                    .map((DocumentSnapshot documentSnapshot) {
                  return Dismissible(
                    key: Key(documentSnapshot['todo']),
                    onDismissed: (direction) {
                      FirebaseFirestore.instance
                          .collection('todos')
                          .doc(documentSnapshot.id)
                          .delete();
                    },
                    child: Card(
                        child: ListTile(title: Text(documentSnapshot['todo']))),
                  );
                }).toList(),
              );
            } else {
              return const Center(
                child: Text(
                  'There is no Todo',
                  style: TextStyle(fontSize: 20, color: Colors.grey),
                ),
              );
            }
          }),
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
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
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
                      borderSide: BorderSide(color: Colors.blue)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.blue)),
                ),
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
                    child: const Text('Create Todo'),
                    onPressed: () async {
                      if (inputValue == "") {
                        showDialog(
                          context: (context),
                          builder: (context) {
                            return const AlertDialog(
                              title: Text('TextField has not inputs'),
                            );
                          },
                        );
                      } else {
                        try {
                          await FirebaseFirestore.instance
                              .collection('todos')
                              .add({'todo': inputValue});
                        } catch (e) {
                          print(e);
                        }
                        Navigator.of(context).pop();
                      }
                    },
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
