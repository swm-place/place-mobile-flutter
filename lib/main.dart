import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:place_mobile_flutter/login.dart';
import 'package:place_mobile_flutter/state/state_controller.dart';
import 'theme/color_schemes.g.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
    .then((value) => Get.put(AuthController()));

  runApp(const GetMaterialApp(home: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //앱 자체 언어 설정 함으로써 캘린더를 한국어로 변경
      localizationsDelegates: [
        // 앱의 로컬라이제이션을 구성합니다.
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        // 앱에서 지원하는 언어 목록을 설정합니다.
        const Locale('ko', 'KR'), // 한국어
        const Locale('en', 'US'), // 영어
      ],
      title: 'OURS',
      themeMode: ThemeMode.light,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text('OURS'),
      ),
      body: Center(
        child: GetBuilder<AuthController>(
          init: AuthController(),
          builder: (controller) {
            if (controller.user.value == null) {
              return FilledButton(child: Text("로그인"), onPressed: () => {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()))
              });
            } else {
              return FilledButton(child: Text("로그아웃"), onPressed: () => {
                controller.signOut()
              });
            }
          },
        )
      ),
    );
  }
}
