import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  late String userToDo;
  List todoList = [];

  @override

  void initState() {
    super.initState();

    todoList.addAll(['Buy milk', 'Wash dishes', 'Купить картошку']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Список дел'),
        centerTitle: true,
        backgroundColor: Colors.deepOrangeAccent,
      ),

      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('items').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return Text('Нет записей');
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Dismissible(
                    key: Key(snapshot.data!.docs[index].id),
                    child: Card(
                      child: ListTile(
                        title: Text(snapshot.data!.docs[index].get('item')),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete_sweep,
                            color: Colors.deepOrangeAccent,
                          ), onPressed: () {
                          setState(() {
                            FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                          });
                        },
                        ),
                      ),
                    ),
                    onDismissed: (direction) {
                      // if(direction == DismissDirection.endToStart)
                      setState(() {
                        FirebaseFirestore.instance.collection('items').doc(snapshot.data!.docs[index].id).delete();
                      });
                    },
                );
              }
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.greenAccent,
        onPressed: () {
          showDialog(context: context, builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Добавить элемент'),
              content: TextField(
                onChanged: (String value) {
                  userToDo = value;
                },
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      // setState(() {
                      //   todoList.add(userToDo);
                      // });
                      FirebaseFirestore.instance.collection('items').add({'item': userToDo});
                      Navigator.of(context).pop();
                    },
                    child: const Text('Добавить'),
                )
              ],
            );
          });
        },
        child: const Icon(
          Icons.add_box,
          color: Colors.white,
        ),
      ),
    );
  }
}