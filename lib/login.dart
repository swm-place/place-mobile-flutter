import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:place_mobile_flutter/screen/size.dart';
import 'theme/text_style.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/images/navigation_icon.svg',
                  width: getDynamicPixel(context, 80),
                  height: getDynamicPixel(context, 80),
                ),
                const Text(
                    "로그인",
                    style: title_large
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: getDynamicPixel(context, 20),
                  constraints: const BoxConstraints(
                    minHeight: 48
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "email",
                      prefixIcon: Icon(
                          Icons.mail_rounded
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: getDynamicPixel(context, 20),
                  constraints: const BoxConstraints(
                      minHeight: 48
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "password",
                        prefixIcon: Icon(
                            Icons.lock_rounded
                        )
                    ),
                    textInputAction: TextInputAction.done,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: getDynamicPixel(context, 20),
                  constraints: const BoxConstraints(
                    minHeight: 34,
                    maxHeight: 48
                  ),
                  child: FilledButton(
                      onPressed: () {
                        print("login");
                      },
                      child: const Text("로그인")
                  ),
                ),
                const SizedBox(height: 10,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Text('OR'),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 1,
                        height: 1,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: getDynamicPixel(context, 20),
                      height: getDynamicPixel(context, 20),
                      constraints: const BoxConstraints(
                        minHeight: 32,
                        minWidth: 32,
                        maxHeight: 48,
                        maxWidth: 48
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/logos/google_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color.fromARGB(255, 231, 91, 75);
                            }
                            return Color.fromARGB(255, 220, 74, 58);
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      width: getDynamicPixel(context, 20),
                      height: getDynamicPixel(context, 20),
                      constraints: const BoxConstraints(
                          minHeight: 32,
                          minWidth: 32,
                          maxHeight: 48,
                          maxWidth: 48
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/logos/apple_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color.fromARGB(255, 42, 42, 42);
                            }
                            return Color.fromARGB(255, 26, 26, 26);
                          }),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10,),
                    Container(
                      width: getDynamicPixel(context, 20),
                      height: getDynamicPixel(context, 20),
                      constraints: const BoxConstraints(
                          minHeight: 32,
                          minWidth: 32,
                          maxHeight: 48,
                          maxWidth: 48
                      ),
                      child: IconButton(
                        onPressed: () {},
                        icon: Image.asset(
                          'assets/logos/facebook_logo.png',
                          width: 24,
                          height: 24,
                        ),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.resolveWith((states) {
                            if (states.contains(MaterialState.pressed)) {
                              return Color.fromARGB(255, 66, 102, 180);
                            }
                            return Color.fromARGB(255, 59, 88, 153);
                          }),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("계정이 없으신가요?"),
                    Container(
                      height: 20,
                      child: TextButton(
                        onPressed: () {},
                        child: Text('회원가입'),
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.fromLTRB(4, 0, 4, 0)
                        ),
                      ),
                    )
                  ],
                ),
                Container(
                  height: 20,
                  child: TextButton(
                    onPressed: () {},
                    child: Text('비밀번호 찾기'),
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.fromLTRB(4, 0, 4, 0)
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      )
    );
  }
}