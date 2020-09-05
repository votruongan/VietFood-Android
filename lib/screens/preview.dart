import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:http/http.dart' as http;

String urlPrefix = 'http://24e9bfd520c3.ngrok.io';

void gotoPreview(context,path,fileName){
    print('gotoPreview');
    print(path);
    Navigator.push(context, MaterialPageRoute(builder: (context) =>PreviewScreen(imgPath: path,fileName: fileName,)));
}

class PreviewScreen extends StatefulWidget {
  final String imgPath;
  final String fileName;
  PreviewScreen({this.imgPath, this.fileName});

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  ButtonState stateOnlyText1 = ButtonState.idle;
  ButtonState stateOnlyText2 = ButtonState.idle;
  Image imageContent;
  String catergoryText, confidentText;
  double splitHeight = 0;
  
  @override
  void initState(){
    imageContent = Image.file(File.fromUri(Uri.parse(widget.imgPath)),fit: BoxFit.fitWidth);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            imageContent,
              SizedBox(height:100-splitHeight-((catergoryText != null && catergoryText.length>0)?(42):(0))),
            (catergoryText != null && catergoryText.length>0)?(Center(child: Column(children: <Widget>[
              Text("Catergory: " + catergoryText, style: TextStyle(height: 1.25, fontSize: 18),),
              Text("Confident: " + confidentText, style: TextStyle(height: 1.25, fontSize: 18),),
            ],),)):(SizedBox(height:0)),
            SizedBox(height:splitHeight),
            Column(
              children: <Widget>[ 
                ProgressButton.icon(
                  iconedButtons: {
                      ButtonState.idle:
                        IconedButton(
                            text: "Classify",
                            icon: Icon(Icons.label,color: Colors.white),
                            color: Colors.deepPurple.shade500),
                      ButtonState.loading:
                        IconedButton(
                            text: "Processing",
                            color: Colors.deepPurple.shade700),
                      ButtonState.fail:
                        IconedButton(
                            text: "Failed",
                            icon: Icon(Icons.cancel,color: Colors.white),
                            color: Colors.red.shade300),
                      ButtonState.success:
                        IconedButton(
                            text: "Succeed",
                            icon: Icon(Icons.check_circle,color: Colors.white,),
                            color: Colors.green.shade400)
                    }, 
                    onPressed: ()  {
                      setState(() {
                        stateOnlyText1 = ButtonState.loading;
                      });
                      getBytes().then((bytes)async {
                        print('preview button');
                        print(widget.imgPath);
                        var i8list = bytes.buffer.asUint8List();
                        String b64 = base64.encode(i8list);
                        var url = urlPrefix;//'/cifar_classifier'
                        var req = http.post(url, headers: {
                          'content-type': 'application/json',
                        }, body:jsonEncode({
                          'img_encoded': b64,
                          'lang': 'custom',
                          'type': 'classify'
                          }));
                        var response = await req;
                        print(response.body);
                        var resObj = json.decode(response.body);
                        print(resObj);                        
                        setState(() {
                          catergoryText = resObj['predicted'].toString();
                          confidentText = (resObj['score']*100).toStringAsFixed(3) + "%";
                          splitHeight = 30;
                          stateOnlyText1 = ButtonState.success;
                        });
                        var future = new Future.delayed(const Duration(milliseconds:1500), (){setState(() {
                          stateOnlyText1 = ButtonState.idle;
                        });});
                      },
                      );
                    },
                    state: stateOnlyText1,
                  ),
                  SizedBox(height: 16,),
                  ProgressButton.icon(iconedButtons: {
                      ButtonState.idle:
                        IconedButton(
                            text: "Detection",
                            icon: Icon(Icons.center_focus_strong,color: Colors.white),
                            color: Colors.deepPurple.shade500),
                      ButtonState.loading:
                        IconedButton(
                            text: "Processing",
                            color: Colors.deepPurple.shade700),
                      ButtonState.fail:
                        IconedButton(
                            text: "Failed",
                            icon: Icon(Icons.cancel,color: Colors.white),
                            color: Colors.red.shade300),
                      ButtonState.success:
                        IconedButton(
                            text: "Succeed",
                            icon: Icon(Icons.check_circle,color: Colors.white,),
                            color: Colors.green.shade400)
                    }, 
                    onPressed: ()  {
                      setState(() {
                        stateOnlyText2 = ButtonState.loading;
                      });
                      getBytes().then((bytes)async {
                        print('preview button');
                        print(widget.imgPath);
                        var i8list = bytes.buffer.asUint8List();
                        String b64 = base64.encode(i8list);
                        var url = urlPrefix;//'/cifar_classifier'
                        var req = http.post(url, headers: {
                          'content-type': 'application/json',
                        }, body:jsonEncode({
                          'img_encoded': b64,
                          'lang': 'custom',
                          'type': 'detection'
                          }));
                        var response = await req;
                        print(response.body);
                        var resObj = json.decode(response.body);
                        imageCache.clear();
                        setState(() {
                          print("before: "+imageContent.toString());
                          imageContent = Image.memory(base64.decode(resObj['predicted']),fit: BoxFit.fitWidth);
                          print("after: "+imageContent.toString());
                          stateOnlyText2 = ButtonState.success;
                        });
                        var future = new Future.delayed(const Duration(milliseconds: 1500), (){setState(() {
                          stateOnlyText2 = ButtonState.idle;
                        });});
                        // Share.file('Share via', widget.fileName, i8list, 'image/path');
                      },
                      );
                    },
                    state: stateOnlyText2,
                  ),
                ]
              ),
              SizedBox(height:16),
          ],
        ),
      )
    );
  }

  Future getBytes () async {
    Uint8List bytes = File(widget.imgPath).readAsBytesSync() as Uint8List;
//    print(ByteData.view(buffer))
    return ByteData.view(bytes.buffer);
  }
}
