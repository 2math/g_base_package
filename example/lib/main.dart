import 'dart:convert';

import 'package:example/flavors/main_dev.dart';
import 'package:example/network/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:g_base_package/base/app_exception.dart';
import 'package:g_base_package/base/utils/dialogs.dart';
import 'package:g_base_package/base/utils/logger.dart';
import 'package:g_base_package/base/utils/system.dart';
import 'package:g_base_package/base/utils/versions.dart';
import 'package:g_base_package/base/utils/files.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';

import 'model/session.dart';

void main() {
  DevConfig();
  runApp(MyApp());
}

//todo Galeen (02 Apr 2020) : Make example of basic use, copy what can from Zoef
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String tag = "MyHomePage";
  int _counter = 0;
  String token, companyId;

  void _incrementCounter() {
    Log.d("${System.isKeyboardVisible(context)}", tag);
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      Log.d("new counter value : $_counter", tag);

      //todo Galeen (07 Apr 2020) : implement block and repository
      if (token == null) {
        Log.d("login", tag);
        NetworkManager(null).login("g.blagoev@futurist-labs.com", "123456", (json) {
          try {
            var session = Session.fromJson(jsonDecode(json));
            token = session.sessionId;
            companyId = session.company.id;
          } catch (e) {
            Log.e("weird error parsing session", tag, e);
          }
        });
      } else {
        NetworkManager(token).getWorkspaces(companyId, (json) {
          Log.d("getWorkspaces", tag);
          return List();
        }).catchError((error) {
          Log.e("error getting Workspaces", tag, error is Error ? error : AppException(data: error));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //important to be called here in first widget
    if (SizeConfig().init(context)) {
      Log.d(SizeConfig().toString());
    }
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
            FlatButton(
              child: Text("Logout"),
              onPressed: () {
                NetworkManager(token).logout().then((isOK) {
                  if (isOK ?? false) {
                    token = null;
                  }
                });
              },
            ),
            LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return FlatButton(
                  child: Text("Get versions"),
                  onPressed: () async {
                    var versions = await NetworkManager(null).getVersions();

                    if (versions == null) {
                      return;
                    }

                    int status = versions.getStatus();
                    Log.d("status : $status");

                    if (status != Version.ON_LATEST_VERSION && status != Version.UNKNOWN) {
                      bool isBlocking = status == Version.UPDATE_REQUIRED;
                      int result = await Dialogs.showVersions(
                          context,
                          Text("App Name"),
                          Text(isBlocking
                              ? "You are using a version which "
                                  "is no longer supported.\nTo continue using this app, please install latest version."
                              : "There is a new version available."),
                          Text(isBlocking ? "Exit" : "Next Time"),
                          Text("Go To Store"));
                      if (result == Version.UPDATE_REQUIRED) {
                        //go to store
                        LaunchReview.launch(
                          androidAppId: "com.facebook.katana",
                          iOSAppId: "284882215",
                        );
                      } else if (isBlocking) {
                        //exit app
                        await System.popToExit(animated: true);
                      } else {
                        Dialogs.showSnackBar(context, "Continue",
                            marginBottom: SizeConfig.screenHeight / 2.4,
                            textStyle: TextStyle(color: Colors.black),
                            bkgColor: Colors.blue,
                            duration: Duration(seconds: 2));
                      }
                    } else {
                      Dialogs.showSnackBar(context, "Continue");
                    }
                  },
                );
              },
            ),
            FlatButton(
              child: Text("Update"),
              onPressed: () {
                NetworkManager(token).updateWorkspace();
              },
            ),
            FlatButton(
              child: Text("Select and Upload"),
              onPressed: () {
                _selectImage();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Future<void> _selectImage() async {
    var selectedFile = await ImagePicker.pickImage(source: ImageSource.gallery).catchError((error) {
      Log.error("selectImage", error: error);
    });

    if (selectedFile != null) {
      var emptyFile = await BaseFileUtils.getLocalFile(
        "imagesDir",
        '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
      );

      var copiedFile = await selectedFile.copy(emptyFile.path).catchError((error) {
        Log.error("selectImage copy", error: error);
      });

      if (copiedFile != null && await copiedFile.exists()) {
        NetworkManager(token).uploadImage(
          copiedFile.path,
          companyId,
          "9e625fb6-e81a-414d-bcfe-95c9d8d80001",
          (_) {},
        );
      }
    }
  }
}
