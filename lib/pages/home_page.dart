import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:todo_app/data/database.dart';
import 'package:todo_app/util/dialog_box.dart';
import 'package:todo_app/util/todo_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // reference the hive box
  final _mybox = Hive.box("mybox");
  ToDoDataBase db = ToDoDataBase();

  @override
  void initState() {
    // if this is the 1st time ever opening the app, then create default data
    if(_mybox.get("TODOLIST") == null){
      db.createInitialData();
    }else{
      //there already exist data--
      db.loadData();
    }

    
    super.initState();
  }

  //text controller---
  final _controller = TextEditingController();

  //list of todo tasksss..(used for default)
  // List toDoList = [
  //   ["Make tutorial", false],
  //   ["Do Exercise", false],
  // ];
  //checkbox was tapped---
  void checkBoxChanged(bool? value, int index){
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDatabase();
  }

  // save new task---
  void saveNewTask(){
    setState(() {
      db.toDoList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  // create a newtask....
  void createNewTask(){
    showDialog(
      context: context, 
      builder: (context){
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  //delete task
  void deleteTask(int index){
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDatabase();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[200],
      appBar: AppBar(
        title: const Center(
            child: Text(
          "To Do",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        )),
        elevation: 0,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          createNewTask();
        },
        backgroundColor: Colors.purple,
        foregroundColor: Colors.white,
        child: Icon(Icons.add, size: 30,),
      ),

      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index){
          return ToDoTile(
            taskName: db.toDoList[index][0], 
            taskCompleted: db.toDoList[index][1], 
            onChanged: (value) => checkBoxChanged(value, index),
            deleteFunction: (context) => deleteTask(index),
          );
        },
      )
    );
  }
}
