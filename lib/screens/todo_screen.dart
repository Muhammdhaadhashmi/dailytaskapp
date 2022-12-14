import 'package:dailytaskapp/models/todo.dart';
import 'package:dailytaskapp/services/category_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/todo_service.dart';
class TodoScreen extends StatefulWidget {
  const TodoScreen({Key key}) : super(key: key);



  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController=TextEditingController();
  var _todoDescriptionController=TextEditingController();
   var _todoDateController=TextEditingController();
   var _selectedValue;
   var _categories=List<DropdownMenuItem>();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();


   @override
   void initState(){
     super.initState();
     _loadCategories();
   }
   _loadCategories() async{
     var _categoryService= CategoryService();
     var categories= await _categoryService.readCategories();
     categories.forEach((category){
       setState(() {
         _categories.add(DropdownMenuItem(child: Text(category['name']),
           value: category['name'],
         ));
       });
     });
   }

   DateTime _dateTime=DateTime.now();
   _selectedTodoData(BuildContext context)async{
     var _pickedDate=await showDatePicker(context: context,
         initialDate: _dateTime,
         firstDate: DateTime(2000),
         lastDate: DateTime(2100));
     if(_pickedDate!=null){
       setState(() {
         _dateTime=_pickedDate;
         _todoDateController.text=DateFormat('yyyy-MM-dd').format(_pickedDate);
       });
     }
   }

  _showSuccessSnackBar(message){
    var _snackBar= SnackBar(content: message);
    scaffoldMessengerKey.currentState.showSnackBar(_snackBar);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldMessengerKey,
      appBar: AppBar(
        title: Text('Create Todo'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
       child:Column(
        children: [
          TextField(
            controller: _todoTitleController,
            decoration: InputDecoration(
              labelText: 'Title',
              hintText: 'Write Todo Title',
            ),
          ),
          TextField(
            controller: _todoDescriptionController,
            decoration: InputDecoration(
              labelText: 'Description',
              hintText: 'Write Todo Description',
            ),
          ),
          TextField(
            controller: _todoDateController,
            decoration: InputDecoration(
              labelText: 'Date',
              hintText: 'Pick a Date',
              prefixIcon: InkWell(
                onTap: (){
                  _selectedTodoData(context);
                },
                child: Icon(Icons.calendar_today),
              )
            ),
          ),
          DropdownButtonFormField(
              value: _selectedValue ,
              items: _categories ,
              hint: Text('Category') ,
              onChanged:(value){
                setState(() {
                  _selectedValue=value;
                });
              }
          ),
          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            onPressed: ()async{
            var todoObject= Todo();
            todoObject.title=_todoTitleController.text;
            todoObject.description=_todoDescriptionController.text;
            todoObject.isFinished=0;
            todoObject.category=_selectedValue.toString();
            todoObject.todoDate=_todoDateController.text;

            var _todoService=TodoService();
            var result=await _todoService.saveTodos(todoObject);
            if(result>0){
              _showSuccessSnackBar(Text('Created'));
            }
            print(result);
          },
            // color: Colors.blue,
            child: Text('Save',style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      )
    );
  }
}
