 import 'package:dailytaskapp/screens/home_screen.dart';
import 'package:dailytaskapp/screens/todo_by_category.dart';
import 'package:dailytaskapp/services/category_service.dart';
import 'package:flutter/material.dart';

import '../screens/categories_screen.dart';
 class DrawerNavigation extends StatefulWidget {
   const DrawerNavigation ({Key key}) : super(key: key);

   @override
   State<DrawerNavigation> createState() => _DrawerNavigationState();
 }

 class _DrawerNavigationState extends State<DrawerNavigation> {
   List<Widget>_categoryList=List<Widget>();

   CategoryService _categoryService=CategoryService();

   @override
   initState(){
     super.initState();
     getAllCategories();
   }

   getAllCategories()async{
     var categories=await _categoryService.readCategories();

     categories.forEach((category){
       setState(() {
         _categoryList.add(InkWell(
           onTap: ()=>Navigator.push(context, new MaterialPageRoute(builder: (context)=>new TodosByCategory(category: category['name'],))),
             child:ListTile(
           title: Text(category['name']),

         )));
       });

     });

   }
   @override
   Widget build(BuildContext context) {
     return Container(
       child: Drawer(
         child: ListView(
           children:  <Widget>[
             UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  child:  Image.asset('asset/images/profile.jpg'),
                  radius: 56.0,
                ) ,
                 accountName: Text('Muhammad Haad Hashmi'),
                 accountEmail:Text('muhmmad.haad96@gmail.com'),
               decoration: BoxDecoration(color: Colors.blue),
             ),
             ListTile(
               leading: Icon(Icons.home),
               title: Text('Home'),
               onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>HomeScreen())),
             ),
             ListTile(
               leading: Icon(Icons.view_list),
               title: Text('Courses'),
               onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context)=>CategoriesScreen())),
             ),
             Divider(),
               Column(
                 children: _categoryList,
               ),
           ],
         ),
       ),
     );
   }
 }
