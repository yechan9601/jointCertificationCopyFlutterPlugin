import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(MyApp());
}

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  static const platform = const MethodChannel('samples.flutter.dev/cert');
  String frontKey = "    ";
  String backKey = "    ";
  String _certificateDatas = "unknown";
  String _eightDigitCode = "12345678";
  String firstFourCode = "";
  String secondFourCode = "";

  @override
  void initState() {
    super.initState();
    //_onCreate();
  }


  Future<void> _onCreate() async {
    String certificateDatas;
    try {
      certificateDatas = await platform.invokeMethod("onCreate");
      setState(() {
        _certificateDatas = certificateDatas;
      });
    } on PlatformException catch (e) {
      print(e);
    }

  }

  Future<void> _buttonClicked3() async {
    String eightDigitCode;
    try {
      eightDigitCode = await platform.invokeMethod("buttonClicked");
      setState(() {
        _eightDigitCode = eightDigitCode;
        firstFourCode = _eightDigitCode.substring(0,4);
        secondFourCode = _eightDigitCode.substring(4, 8);
      });
      print("!!!@@" + _eightDigitCode + "@@!!!\n");
      Future.delayed(const Duration(milliseconds: 1000), () {
        _onCreate();
      });
    } on PlatformException catch (e) {
      print(e);
    }
  }

  void buttonClicked() {
    _startSetting();
    Future.delayed(const Duration(milliseconds: 1000), () {
      _getKey();
    });
  }

  void _startSetting() async {
    try {
      await platform.invokeMethod("startSetting");
    } catch (e) {
      print(e);
    }
  }

  void _getKey() async {
    String value;
    List key;
    try {
      value = await platform.invokeMethod("getKey");
      key = value.split("-");
      setState(() {
        frontKey = key[0];
        backKey = key[1];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('공동인증서(구 공인인증서) 복사'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'PC에서 공동인증서\n(구 공인인증서)를 복사해\n휴대폰으로 전달해주세요. ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                        '1.PC에서 cert.tilko.net에 접속해주세요.'
                            '\n2.공동인증서 복사하기 버튼을 클릭해주세요.'
                            '\n3.공동인증서(구 공인인증서) 로그인 후 아래 인증번호를 입력해주세요. '
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: RaisedButton(
                        child: Text('인증서 가져오기'),
                        onPressed: () {
                          //buttonClicked();
                          _buttonClicked3();
                          print(_eightDigitCode);
                        }, // fun here
                      ),
                    ),
                  ),
                  SizedBox(height: 16,),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(36, 0, 0, 0),
                    child: Text('인증번호'),
                  ),
                  SizedBox(height: 8,),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(36, 10, 36, 10),
                            child: Text(
                              firstFourCode, // fun here
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 8,),
                        Text('-'),
                        SizedBox(width: 8,),
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(36, 10, 36, 10),
                            child: Text(
                              secondFourCode, // fun here
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  OutlinedButton(
                    onPressed: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(_certificateDatas),
                    ),

                  ),
                ],
              ),
            ),
          )
      ),
    );
  }
}




