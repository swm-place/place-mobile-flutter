import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/utils.dart';
import 'package:place_mobile_flutter/screen/size.dart';
import 'package:place_mobile_flutter/state/state_controller.dart';
import 'theme/text_style.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                getDynamicPixel(context, 80) > 80 ?
                SvgPicture.asset(
                  'assets/images/navigation_icon.svg',
                  width: getDynamicPixel(context, 80),
                  height: getDynamicPixel(context, 80),
                ) : Container(width: 0, height: 0,),
                const Text(
                  "로그인",
                  style: title_large,
                ),
                SizedBox(
                  height: 10,
                ),
                Form(
                  key: _formKey,
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "email",
                            prefixIcon: Icon(
                                Icons.mail_rounded
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 0)
                          ),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return '이메일을 입력해주세요.';
                            }
                            if (!value.isEmail) {
                              return '형식에 맞는 이메일을 입력해주세요.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "password",
                              prefixIcon: Icon(
                                  Icons.lock_rounded
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 0)
                          ),
                          textInputAction: TextInputAction.done,
                          obscureText: true,
                          enableSuggestions: false,
                          autocorrect: false,
                          controller: passwordController,
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
                                if (_formKey.currentState!.validate()) {
                                  AuthController.to.signInEmail(
                                      emailController.text.tr,
                                      passwordController.text.tr
                                  );
                                }
                              },
                              child: const Text("로그인")
                          ),
                        ),
                      ],
                    ),
                  )
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

class _LoginFrom extends StatefulWidget {
  const _LoginFrom({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginFormState();
  }
}

class _LoginFormState extends State<_LoginFrom> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Form(
      key: _formKey,
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: getDynamicPixel(context, 20),
              constraints: const BoxConstraints(
                  minHeight: 48
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "email",
                  prefixIcon: Icon(
                      Icons.mail_rounded
                  ),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                controller: emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '이메일을 입력해주세요.';
                  }
                  if (!value.isEmail) {
                    return '형식에 맞는 이메일을 입력해주세요.';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 10,),
            Container(
              width: double.infinity,
              height: getDynamicPixel(context, 20),
              constraints: const BoxConstraints(
                  minHeight: 48
              ),
              child: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "password",
                  prefixIcon: Icon(
                      Icons.lock_rounded
                  ),
                ),
                textInputAction: TextInputAction.done,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                controller: passwordController,
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
                    if (_formKey.currentState!.validate()) {
                      AuthController.to.signInEmail(
                          emailController.text.tr,
                          passwordController.text.tr
                      );
                    }
                  },
                  child: const Text("로그인")
              ),
            ),
          ],
        ),
      )
    );
  }
}