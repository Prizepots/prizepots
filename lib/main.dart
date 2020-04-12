
import 'package:prizepots/screens/StartBuffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    statusBarColor: Colors.black,
  ));
  runApp(MyApp());
}

HexColor color1 = HexColor("#186955");
HexColor color2 = HexColor("#186955");
Color color3 =  HexColor("#186955");
HexColor color4 = HexColor("#186955");

HexColor textColor = HexColor("#ffffff");
HexColor textColordark = HexColor("#000000");
bool adInstantiated = false;
SharedPreferences sharedPreferences;

class MyApp extends StatelessWidget {

  final HexColor color1 = HexColor("#186955");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Adding',
      home: StartBuffer(),
      theme: ThemeData(
        fontFamily: 'ColaborateThin',
        primaryColor: Colors.black,


      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}

//class MessageHandler extends StatefulWidget {
//  @override
//  _MessageHandlerState createState() => _MessageHandlerState();
//}
//
//class _MessageHandlerState extends State<MessageHandler> {
//  final Firestore _db = Firestore.instance;
//  final FirebaseMessaging _fcm = FirebaseMessaging();
//
//  StreamSubscription iosSubscription;
//
//  @override
//  void initState() {
//    super.initState();
//    SharedPreferences.getInstance().then(
//      (SharedPreferences sp) {
//        sharedPreferences = sp;
//      });
//
//    if (Platform.isIOS) {
//      iosSubscription = _fcm.onIosSettingsRegistered.listen((data) {
//        // save the token  OR subscribe to a topic here
//      });
//
//      _fcm.requestNotificationPermissions(IosNotificationSettings());
//    }
//
//    _fcm.subscribeToTopic('push');
//
////    _fcm.unsubscribeFromTopic('puppies');
//
//    _fcm.configure(
//      onMessage: (Map<String, dynamic> message) async {
//        print("onMessage: $message");
//        showDialog(
//          context: context,
//          builder: (context) =>
//              AlertDialog(
//                content: ListTile(
//                  title: Text(message['notification']['title']),
//                  subtitle: Text(message['notification']['body']),
//                ),
//                actions: <Widget>[
//                  FlatButton(
//                    child: Text('Ok'),
//                    onPressed: () => Navigator.of(context).pop(),
//                  ),
//                ],
//              ),
//        );
//      },
//      onLaunch: (Map<String, dynamic> message) async {
//        print("onLaunch: $message");
//        // TODO optional
//      },
//      onResume: (Map<String, dynamic> message) async {
//        print("onResume: $message");
//        // TODO optional
//      },
//    );
//
//    _saveDeviceToken() async {
//      // Get the current user
//      String uid = sharedPreferences.getString("userID");
//      // FirebaseUser user = await _auth.currentUser();
//
//      // Get the token for this device
//      String fcmToken = await _fcm.getToken();
//
//      // Save it to Firestore
//      if (fcmToken != null) {
//        var tokens = _db
//            .collection('users')
//            .document(uid)
//            .collection('tokens')
//            .document(fcmToken);
//
//        await tokens.setData({
//          'token': fcmToken,
//          'createdAt': FieldValue.serverTimestamp(), // optional
//          'platform': Platform.operatingSystem // optional
//        });
//      }
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return null;
//  }
//}






