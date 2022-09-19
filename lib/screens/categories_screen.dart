import 'package:dailytaskapp/screens/home_screen.dart';
import 'package:dailytaskapp/services/category_service.dart';
import 'package:flutter/material.dart';

import '../models/category_model.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({Key key}) : super(key: key);

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController=TextEditingController();
  var _categoryDescriptionController=TextEditingController();


  var _category= Category();
  var _categoryService=CategoryService();

  List<Category>_categoryList = List<Category>();

  var category;

  var _editcategoryNameController=TextEditingController();
  var _editcategoryDescriptionController=TextEditingController();

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();



  @override
  void initState(){
    super.initState();
    getAllCategories();
  }



  getAllCategories()async{
    _categoryList=List<Category>();
    var categories= await _categoryService.readCategories();
    categories.forEach((category){
      setState(() {
        var categoryModel =Category();
        categoryModel.name = category['name'];
        categoryModel.description = category['description'];
        categoryModel.id = category['id'];
        _categoryList.add(categoryModel);
      });
    });
  }
  _editCategory(BuildContext context, categoryId) async{
    category = await _categoryService.readCategoryById(categoryId);
    setState(() {
      _editcategoryNameController.text= category[0]['name']??'No Name';
      _editcategoryDescriptionController.text= category[0]['description']??'No Description';

    });
    _editFormDialog(context);
  }
  _showFormDialog(BuildContext context){
    return showDialog(context: context,barrierDismissible: true,builder:(params){
      return AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red, // foreground
            ),
            // color: Colors.red,
              onPressed: ()=>Navigator.pop(context),
              child: Text("Cancel"),
          ),
            TextButton(
                style: TextButton.styleFrom(
                  primary: Colors.blue,
                ),
            // child: Colors.blue,
            onPressed: () async{
                _category.name= _categoryNameController.text;
                _category.description=_categoryDescriptionController.text;
              var result= await  _categoryService.saveCategory(_category);
              if(result>0){
                print (result);
                Navigator.pop(context);
                getAllCategories();
              }
            },
            child: Text("Save"),
          ),
        ],
        title: Text("Categories Form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _categoryNameController,
               decoration: InputDecoration(
                 hintText: "Write a Category",
                 labelText: "Category"
               ),
              ),
              TextField(
                controller: _categoryDescriptionController,
                decoration: InputDecoration(
                    hintText: "Write a Description",
                    labelText: "Description",
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _editFormDialog(BuildContext context){
    return showDialog(context: context,barrierDismissible: true,builder:(params){
      return AlertDialog(
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red, // foreground
            ),
            onPressed: ()=>Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red, // foreground
            ),
            onPressed: () async{
              _category.id= category[0]['id'];
              _category.name= _editcategoryNameController.text;
              _category.description=_editcategoryDescriptionController.text;


              var result= await  _categoryService.updateCategory(_category);
              if(result>0){
                Navigator.pop(context);
                getAllCategories();
                _showSuccessSnackBar(Text('Updated',style: TextStyle(fontSize: 17,color: Colors.indigoAccent),));
              }
            },
            child: Text("Update"),
          ),
        ],
        title: Text(" Edit Categories Form"),
        content: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              TextField(
                controller: _editcategoryNameController,
                decoration: InputDecoration(
                    hintText: "Write a Category",
                    labelText: "Category"
                ),
              ),
              TextField(
                controller: _editcategoryDescriptionController,
                decoration: InputDecoration(
                  hintText: "Write a Description",
                  labelText: "Description",
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  _deleteFormDialog(BuildContext context, categoryId){
    return showDialog(context: context,barrierDismissible: true,builder:(params){
      return AlertDialog(
        actions: [
          ElevatedButton(
            // color: Colors.green,
            onPressed: ()=>Navigator.pop(context),
            child: Text("Cancel"),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.red, // foreground
            ),
            // color: Colors.red,
            onPressed: () async{

              var result=  await  _categoryService.deleteCategory(categoryId);
              if(result>0){
                Navigator.pop(context);
                getAllCategories();
                _showSuccessSnackBar(Text('Deleted',style: TextStyle(fontSize: 17,color: Colors.indigoAccent)));
              }
            },
            child: Text("Delete"),
          ),
        ],
        title: Text("Are you sure you want to delete this?"),

      );
    });
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
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>HomeScreen())),
          // elevation: 0.0,
          child: Icon(Icons.arrow_back,color: Colors.white,),

        ),
        title: Text("Categories"),
      ),
      body: ListView.builder(itemCount:_categoryList.length,itemBuilder: (context ,index){
        return Padding(
            padding: EdgeInsets.only(top:8.0,left:16.0,right: 16.0),
          child:Card(
            elevation: 8.0,
           child: ListTile(
            leading: IconButton(icon:Icon(Icons.edit,),
              onPressed: (){
              _editCategory(context,_categoryList[index].id);
            },),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(_categoryList[index].name),
                IconButton(icon:Icon(Icons.delete,color: Colors.red,),onPressed: (){
                  _deleteFormDialog(context,_categoryList[index].id );
                },),
              ],
            ),
             subtitle: Text(_categoryList[index].description),
          ),
          ),
        );
      }
      ),
        floatingActionButton: FloatingActionButton(
            onPressed: (){
              _showFormDialog(context);
            },
            child: Icon(Icons.add)),
    );
  }
}
