import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
                  width: 256,
                  height: 256,
                ),
                const SizedBox(height: 10,),
                const Text(
                    "로그인",
                    style: title_large
                ),
                const SizedBox(height: 10,),
                const TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "email",
                      prefixIcon: Icon(
                          Icons.mail_rounded
                      ),
                    )
                ),
                const SizedBox(height: 10,),
                const TextField(
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "password",
                      prefixIcon: Icon(
                          Icons.lock_rounded
                      )
                  ),
                ),
                const SizedBox(height: 10,),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 1000,
                    minHeight: 48
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
                    IconButton(
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
                    const SizedBox(width: 10,),
                    IconButton(
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
                    const SizedBox(width: 10,),
                    IconButton(
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
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("계정이 없으신가요?"),
                    TextButton(onPressed: () {}, child: Text('회원가입'))
                  ],
                ),
                TextButton(onPressed: () {}, child: Text('비밀번호 찾기'))
                // ConstrainedBox(
                //   constraints: const BoxConstraints(
                //       minWidth: 1000,
                //   ),
                //   child:
                //   const Row(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     children: [
                //       Divider(
                //         thickness: 1,
                //         height: 1,
                //       ),
                //       Text('OR'),
                //       Divider(
                //         thickness: 1,
                //         height: 1,
                //       ),
                //     ],
                //   )
                // ),
              ],
            ),
          ),
        )
      )
    );
  }
}