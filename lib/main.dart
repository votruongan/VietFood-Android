import 'dart:io';
import 'dart:async';

import 'package:cuiseen/screens/camera.dart';
import 'package:cuiseen/screens/preview.dart';
import 'package:flutter/material.dart';
import 'package:fab_circular_menu/fab_circular_menu.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cuiseen',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      home: RingSelector(),
    );
  }
}
 
class RingSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(child: Image.asset(
                  'images/lake.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
          ]
        ),
        floatingActionButton: FabCircularMenu(
          ringColor: Colors.deepPurple.shade700,
          fabColor: Colors.deepPurple.shade700,
          fabOpenIcon: Icon(Icons.center_focus_weak,color: Colors.white,),
          animationCurve: Curves.easeInOutCirc,
          animationDuration: Duration(milliseconds: 500),
          fabSize: 72.0,
          fabElevation: 32.0,
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            FlatButton.icon(icon: Icon(Icons.collections,color: Colors.white,), onPressed: () async {
              File fil;
              final _picker = ImagePicker();
              final pickedFile = await ImagePicker.pickImage(source: ImageSource.gallery);
              final splits = pickedFile.path.split('/');
              print(splits);
              gotoPreview(context, pickedFile.path, splits[splits.length-1]);
            },label: Text('Choose image'),textColor: Colors.white,),
            Text('Provide an image to process', style: TextStyle(color: Colors.white),),
            FlatButton.icon(icon: Icon(Icons.camera,color: Colors.white,), onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CameraScreen()),
              );
            },label:Text('Capture image'),textColor: Colors.white,),
          ]
        ),
    ),
    );
  }
}

class Selector extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: null,
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(child: Image.asset(
                  'images/lake.jpg',
                  fit: BoxFit.fitHeight,
                ),
              ),
          ]
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
              _settingModalBottomSheet(context);
            // Add your onPressed code here!
          },
          label: Text('Bắt đầu'),
          icon: Icon(Icons.aspect_ratio),
          backgroundColor: Colors.pink,
        ),
      ),
      );
  }
}


void _settingModalBottomSheet(context){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child:Column(
            children:<Widget>[
              CloseButton(
                color: Colors.amber,
                onPressed: null,
              ),
              
              RaisedButton(
                child:Center(child:Row(
                  children: <Widget>[
                    Icon(Icons.camera),
                    Text("Chụp hình từ máy ảnh"),
                  ],)),
                onPressed: (){
                },
                )
              ],)
        );
      }
    );
}
