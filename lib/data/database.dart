import 'package:hive_flutter/hive_flutter.dart';

class ToDoDataBase{
  List toDoList=[];

  //reference our box--
  final _mybox = Hive.box("mybox");

  //run this method if this is the 1st time ever openning this app
  void createInitialData(){
    toDoList=[
      ["Make tutorial", false],
      ["Do Exercise", false],
    ];
  }

  // load the data from database---
  void loadData(){
    toDoList= _mybox.get("TODOLIST");
  }

  //update the database----
  void updateDatabase(){
    _mybox.put("TODOLIST", toDoList);
  }


}