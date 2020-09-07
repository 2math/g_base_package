import 'dart:convert';

import 'package:example/flavors/main_dev.dart';
import 'package:example/network/network_manager.dart';
import 'package:example/res/res.dart';
import 'package:example/res/strings/main/bg_strings.dart';
import 'package:example/res/strings/main/en_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:g_base_package/base/app_exception.dart';
import 'package:g_base_package/base/ui/base_state.dart';
import 'package:g_base_package/base/ui/logs_screen.dart';
import 'package:g_base_package/base/utils/dialogs.dart';
import 'package:g_base_package/base/utils/logger.dart';
import 'package:g_base_package/base/utils/system.dart';
import 'package:g_base_package/base/utils/utils.dart';
import 'package:g_base_package/base/utils/versions.dart';
import 'package:g_base_package/base/utils/files.dart';
import 'package:image_picker/image_picker.dart';
import 'package:launch_review/launch_review.dart';

import 'model/session.dart';

void main() {
  DevConfig();
  Localization.init(null, [EnUSStrings(), BgStrings()], EnUSStrings(),
      globalLocales: [EnUSGlobalStrings(), BgGlobalStrings()]);
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
      home: MyHomePage(
        title: Txt.get(StrKey.mainTitle),
      ),
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

class _MyHomePageState extends BaseState<MyHomePage, Object, Object> {
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
            token = jsonDecode(json)['sessionId'] as String;
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
              Txt.get(StrKey.appName),
            ),
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
              child: Text("Select and Upload Image"),
              onPressed: () {
                _selectImage();
              },
            ),
            FlatButton(
              child: Text("Select and Upload Document"),
              onPressed: () {
                _selectFile();
              },
            ),
            FlatButton(
              child: Text("delete Document"),
              onPressed: () {
                _deleteFiles();
              },
            ),
            FlatButton(
              child: Text("Fetch Documents"),
              onPressed: () {
                _fetchFiles();
              },
            ),
            FlatButton(
              child: Text("Edit Document With file"),
              onPressed: () {
                _editFile(false);
              },
            ),
            FlatButton(
              child: Text("Edit Document Without file"),
              onPressed: () {
                _editFile(true);
              },
            ),
            FlatButton(
              child: Text("Check Internet"),
              onPressed: () async {
                Log.d(DateTime.now().toIso8601String());
                bool res = await NetUtil().checkInternet();
                Log.d(DateTime.now().toIso8601String());
                showInfoMessage(res ? "Has internet" : "No internet");
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
        NetworkManager(token).uploadImageFuture(
          copiedFile.path,
          "b55306bc-20d0-4ee6-adb1-d3307c308502",
          "2ac7d50d-da40-41a8-b84d-3a87c0fb9e4a",
          (json) {
            Log.d(json, tag);
          },
        ).catchError((e) {
          Log.error("uploadImageFuture", error: e);
        });
      }
    }
  }

  Future<void> _selectFile() async {
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
        NetworkManager(token).uploadFileFuture(
          copiedFile.path,
          "b55306bc-20d0-4ee6-adb1-d3307c308502",
          "2ac7d50d-da40-41a8-b84d-3a87c0fb9e4a",
          "{\"displayName\": \"document name\",\"description\": \"description\",\"createDate\":\"2020-09-02T07:30:47"
              "\",\"visibility\":\"PUBLIC\",\"typeId\": \"3c3b5ae4-955c-4b9d-8bd9-3d564767a2e8\",\"mimeType\": "
              "\"image/jpg\"}",
          (json) {
            Log.d(json, tag);
          },
        ).catchError((e) {
          Log.error("uploadImageFuture", error: e);
        });
      }
    }
  }

  Future<void> _editFile(bool dataOnly) async {
    var selectedFile = dataOnly
        ? null
        : await ImagePicker.pickImage(source: ImageSource.gallery).catchError((error) {
            Log.error("selectImage", error: error);
          });

    var copiedFile;

    if (selectedFile != null) {
      var emptyFile = await BaseFileUtils.getLocalFile(
        "imagesDir",
        '${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
      );

      copiedFile = await selectedFile.copy(emptyFile.path).catchError((error) {
        Log.error("selectImage copy", error: error);
      });
    }
    // if (copiedFile != null && await copiedFile.exists()) {
    NetworkManager(token)
        .updateFileFuture(
      pathFile: copiedFile?.path,
      companyId: "b55306bc-20d0-4ee6-adb1-d3307c308502",
      workspaceId: "2ac7d50d-da40-41a8-b84d-3a87c0fb9e4a",
      documentId: "b9c8bfc6-9e94-4fef-9c35-725958e21090",
      data: "{\"displayName\": \"document name1\",\"description\": \"description1\",\"createDate\":"
          "\"2020-09-02T07:30:47"
          "\",\"visibility\":\"PUBLIC\",\"typeId\": \"3c3b5ae4-955c-4b9d-8bd9-3d564767a2e8\",\"keepResource\": $dataOnly}",
      //,\"mimeType\": \"image/jpg\"
      handlePositiveResultBody: (json) {
        Log.d(json, tag);
      },
    )
        .catchError((e) {
      Log.error("uploadImageFuture", error: e);
    });
    // }
    // }
  }

  Future<void> _fetchFiles() async {
    NetworkManager(token)
        .getFile(
      "b55306bc-20d0-4ee6-adb1-d3307c308502",
      "2ac7d50d-da40-41a8-b84d-3a87c0fb9e4a",
    )
        .catchError((e) {
      Log.error("uploadImageFuture", error: e);
    });
  }

  Future<void> _deleteFiles() async {
    NetworkManager(token)
        .deleteFile(
      "b55306bc-20d0-4ee6-adb1-d3307c308502",
      "2ac7d50d-da40-41a8-b84d-3a87c0fb9e4a",
      "c064f29e-1a64-4777-9acc-c0fcb9a68e55",
      (_) {},
    )
        .catchError((e) {
      Log.error("uploadImageFuture", error: e);
    });
  }
}
