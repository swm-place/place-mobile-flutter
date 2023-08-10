import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:place_mobile_flutter/page/account/login.dart';
import 'package:place_mobile_flutter/page/main/bookmark.dart';
import 'package:place_mobile_flutter/page/main/home.dart';
import 'package:place_mobile_flutter/page/main/profile.dart';
import 'package:place_mobile_flutter/page/main/random.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'theme/color_schemes.g.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp()
    .then((value) => Get.put(AuthController()));

  runApp(GetMaterialApp(
    // builder: (context, child) {
    //   return MediaQuery(
    //     data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
    //     child: child!,
    //   );
    // },
    localizationsDelegates: [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: [
      const Locale('ko', 'KR'),
      const Locale('en', 'US'),
    ],
    title: 'OURS',
    themeMode: ThemeMode.light,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      fontFamily: 'Pretendard',
      // appBarTheme: AppBarTheme(
      //   systemOverlayStyle: Platform.isAndroid ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark
      // )
    ),
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'),
        const Locale('en', 'US'),
      ],
      title: 'OURS',
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: lightColorScheme,
        fontFamily: 'Pretendard',
        // appBarTheme: AppBarTheme(
        //     systemOverlayStyle: Platform.isAndroid ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark
        // )
      ),
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
  late int _selectedPageIndex;
  late List<Widget> _pages;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedPageIndex = 0;
    _pages = [
      HomePage(),
      BookmarkPage(),
      RandomPage(),
      ProfilePage()
    ];
    _pageController = PageController(initialPage: _selectedPageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        height: 62,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: _selectedPageIndex,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'home'),
          NavigationDestination(icon: Icon(Icons.bookmark_border_outlined), label: 'bookmark'),
          NavigationDestination(icon: Icon(Icons.lightbulb_outline), label: 'discover'),
          NavigationDestination(icon: Icon(Icons.person), label: 'profile'),
        ],
        onDestinationSelected: (selectedPageIndex) {
          setState(() {
            _selectedPageIndex = selectedPageIndex;
            _pageController.jumpToPage(selectedPageIndex);
          });
        }
      ),
    );
  }
}
