import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:place_mobile_flutter/api/provider/user_provider.dart';
import 'package:place_mobile_flutter/state/auth_controller.dart';
import 'package:place_mobile_flutter/state/user_controller.dart';
import 'package:place_mobile_flutter/theme/color_schemes.g.dart';
import 'package:place_mobile_flutter/theme/text_style.dart';
import 'package:place_mobile_flutter/util/async_dialog.dart';
import 'package:place_mobile_flutter/util/validator.dart';
import 'package:place_mobile_flutter/widget/tos.dart';

class SignUpPage extends StatefulWidget {
  SignUpPage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SignUpPageState();
  }
}

enum Sex {male, female}

class SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final FocusNode passwordCheckFocusNode = FocusNode();
  final FocusNode phoneNumberFocusNode = FocusNode();

  final PageController pageController = PageController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordCheckController = TextEditingController();

  final TextEditingController nicknameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController birthController = TextEditingController();

  final UserProvider userProvider = UserProvider();

  bool hidePassword = true;
  bool emailEnable = true;
  bool checkNicknameDup = false;

  String? emailError;
  String? passwordError;
  String? passwordCheckError;

  String? nicknameError;
  String? nicknameHelper;
  String? phoneNumberError;
  String? birthError;
  int pageIdx = 0;

  String tosButtonText = "다음";
  Color tosButtonNextColor = lightColorScheme.primary;

  DateTime? selectedBirth;

  List? tosList;

  Sex selectedSex = Sex.male;

  Widget _emailPage() {
    User? user = AuthController.to.user.value;
    if (user != null) {
      if (user.email != null) {
        emailEnable = false;
        emailController.text = user.email!;

        // FocusScope.of(context).unfocus();
      }
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "이메일을 입력해주세요",
              style: PageTextStyle.titleLarge(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "로그인에 필요합니다",
              style: PageTextStyle.bodyLarge(Colors.black54),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  final email = text.tr;
                  emailError = emailTextFieldValidator(email);
                });
              },
              decoration: InputDecoration(
                enabled: emailEnable,
                  hintText: "example@example.com",
                  hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                  errorText: emailError
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              controller: emailController,
              style: PageTextStyle.headlineSmall(Colors.black),
            ),
          )
        ],
      ),
    );
  }

  Widget _passwordPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "비밀번호를 입력해주세요",
              style: PageTextStyle.titleLarge(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "6자 이상 필요합니다",
              style: PageTextStyle.bodyLarge(Colors.black54),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              onChanged: (text) {
                setState(() {
                  final password = text.tr;
                  passwordError = passwordTextFieldValidator(password);
                });
              },
              decoration: InputDecoration(
                hintText: "비밀번호",
                hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                // helperText: "hdusiah",
                errorText: passwordError,
                suffixIcon: IconButton(
                  icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.next,
              keyboardType: TextInputType.emailAddress,
              controller: passwordController,
              style: PageTextStyle.headlineSmall(Colors.black),
              obscureText: hidePassword,
              enableSuggestions: false,
              autocorrect: false,
              onSubmitted: (String value) {
                FocusScope.of(context).requestFocus(passwordCheckFocusNode);
              },
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: TextField(
              focusNode: passwordCheckFocusNode,
              onChanged: (text) {
                setState(() {
                  final passwordCheck = text.tr;
                  if (passwordController.text.tr != passwordCheck) {
                    passwordCheckError = "비밀번호가 일치하지 않습니다!";
                  } else {
                    passwordCheckError = null;
                  }
                });
              },
              decoration: InputDecoration(
                hintText: "비밀번호 재입력",
                hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                errorText: passwordCheckError,
                suffixIcon: IconButton(
                  focusNode: null,
                  icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      hidePassword = !hidePassword;
                    });
                  },
                ),
              ),
              textInputAction: TextInputAction.done,
              keyboardType: TextInputType.emailAddress,
              controller: passwordCheckController,
              style: PageTextStyle.headlineSmall(Colors.black),
              obscureText: hidePassword,
              enableSuggestions: false,
              autocorrect: false,
            ),
          )
        ],
      ),
    );
  }

  Widget __tosWidgetList() {
    List<Widget> tosWidget = [];
    for (var element in tosList!) {
      print(element);
      print(element['required']);
      // print(element['required']);
      tosWidget.add(SizedBox(
          width: double.infinity,
          child: CheckTos(
            agreeValue: element['agree'],
            tosContent: element['contents'],
            tosText: element['title'],
            require: element['required'],
            callback: (val) {
              element['agree'] = val;
            },
          ),
        )
      );
    }
    return Column(
      children: tosWidget,
    );
  }

  Widget _tosAgreePage() {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter bottomState) {
          return Padding(
              padding: EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        "약관 동의",
                        style: PageTextStyle.titleLarge(),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(child: __tosWidgetList()),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: tosButtonNextColor
                            ),
                            child: Text(tosButtonText),
                            onPressed: () {
                              bool checkTos = true;
                              for (var element in tosList!) {
                                if (element['required']) {
                                  if (!(element['agree'])) {
                                    checkTos = false;
                                    break;
                                  }
                                }
                              }

                              if (checkTos) {
                                print("dsfsdjufvisjhvo");
                                bottomState(() {
                                  tosButtonText = "완료";
                                  tosButtonNextColor = lightColorScheme.primary;
                                });

                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);

                                final nickname = nicknameController.text.tr;
                                final phoneNumber = phoneNumberController.text.tr;
                                final sex = selectedSex;
                                final birth = birthController.text.tr;

                                List<int> agreeTermIdx = [];
                                if (tosList != null) {
                                  for (var t in tosList!) {
                                    if (t['agree']) agreeTermIdx.add(t['id']);
                                  }
                                }
                                ProfileController.to.makeUserProfile(nickname, phoneNumber, birth.replaceAll('/', '-') + "T00:00:00.000Z", sex.index, agreeTermIdx);
                              } else{
                                bottomState(() {
                                  tosButtonText = "필수 약관을 동의해주세요";
                                  tosButtonNextColor = Colors.red;
                                });
                              }
                            },
                          ),
                        )
                    )
                  ],
                ),
              )
          );
        },
      );
  }

  Future<bool> checkNickname(String nickname) async {
    setState(() {
      nicknameHelper = null;
      nicknameError = nicknameTextFieldValidator(nickname);
    });
    if (nicknameError == null) {
      int? result = await userProvider.checkNickname(nickname);
      if (result == 200) {
        checkNicknameDup = true;
        setState(() {
          nicknameError = null;
          nicknameHelper = '사용 가능한 닉네임입니다!';
        });
        return true;
      } else if (result == 409) {
        checkNicknameDup = false;
        setState(() {
          nicknameError = "이미 사용중인 닉네임입니다.";
        });
        return false;
      } else {
        setState(() {
          nicknameError = "다시 시도해주세요.";
        });
        return false;
      }
    }
    return false;
  }

  Widget _userInformPage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: Text(
              "사용자 정보를 입력해주세요",
              style: PageTextStyle.titleLarge(),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Text(
              "서비스를 이용할 때 필요합니다",
              style: PageTextStyle.bodyLarge(Colors.black54),
            ),
          ),
          SizedBox(
            height: 24,
          ),
          SizedBox(
            width: double.infinity,
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text("닉네임 *"),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: TextFormField(
                                decoration: InputDecoration(
                                  hintText: "닉네임",
                                  hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                                  contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  errorText: nicknameError,
                                  helperText: nicknameHelper
                                ),
                                textInputAction: TextInputAction.next,
                                controller: nicknameController,
                                style: PageTextStyle.headlineSmall(Colors.black),
                                validator: nicknameTextFieldValidator,
                                onFieldSubmitted: (String value) {
                                  FocusScope.of(context).requestFocus(phoneNumberFocusNode);
                                },
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                await checkNickname(nicknameController.text.tr);
                              },
                              child: Text("중복확인")
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("전화번호 *"),
                  ),
                  TextFormField(
                    focusNode: phoneNumberFocusNode,
                    decoration: InputDecoration(
                      hintText: "01012341234",
                      hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                      contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      errorText: phoneNumberError,
                    ),
                    textInputAction: TextInputAction.done,
                    controller: phoneNumberController,
                    style: PageTextStyle.headlineSmall(Colors.black),
                    validator: phoneNumberTextFieldValidator,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("성별 *"),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<Sex>(
                      segments: [
                        ButtonSegment<Sex>(
                          value: Sex.male,
                          label: Text("남성"),
                          icon: Icon(Icons.male)
                        ),
                        ButtonSegment<Sex>(
                          value: Sex.female,
                          label: Text("여성"),
                            icon: Icon(Icons.female)
                        ),
                      ],
                      selected: <Sex>{selectedSex},
                      onSelectionChanged: (newValue) {
                        setState(() {
                          selectedSex = newValue.first;
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text("생년월일 *"),
                  ),
                  GestureDetector(
                    onTap: () async {
                      selectedBirth = await showDatePicker(
                          locale: Locale('ko', 'KR'),
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now()
                      );
                      if (selectedBirth != null) {
                        birthController.text = DateFormat('yyyy/MM/dd').format(selectedBirth!);
                      }
                    },
                    child: TextFormField(
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: "yyyy/mm/dd",
                          hintStyle: PageTextStyle.headlineSmall(Colors.grey[700]!),
                          contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                          errorText: birthError
                      ),
                      controller: birthController,
                      style: PageTextStyle.headlineSmall(Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "생년월일을 선택해주세요";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            )
          ),
        ],
      ),
    );
  }

  late Future _loadTos;

  Future<Map<String, dynamic>?> _loadTosAsync() async {
    Map<String, dynamic>? data = await userProvider.getTerm();
    print('data: $data');
    if (data != null) {
      tosList = data['result'];
      for (int idx = 0;idx < tosList!.length;idx++) {
        tosList![idx]['agree'] = false;
        // tosList![idx]['required'] = tosList![idx]['required'] == 1;
      }
      return data;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _loadTos = _loadTosAsync();
  }

  @override
  void dispose() {
    passwordController.dispose();
    passwordCheckController.dispose();
    emailController.dispose();
    nicknameController.dispose();
    phoneNumberController.dispose();
    birthController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _loadTos,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              appBar: AppBar(
                leading: Platform.isAndroid ? IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: _pressedBack,
                ) : IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  onPressed: _pressedBack,
                ),
              ),
              body: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            if (AuthController.to.user.value == null)
                              SingleChildScrollView(child: _emailPage(),),
                            if (AuthController.to.user.value == null)
                              SingleChildScrollView(child: _passwordPage()),
                            SingleChildScrollView(
                              child: _userInformPage(),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
                            child: FilledButton(
                              child: Text("다음"),
                              onPressed: () async {
                                switch (pageController.page!.toInt()) {
                                  case 0: {
                                    if (AuthController.to.user.value == null) {
                                      setState(() {
                                        final email = emailController.text.tr;
                                        emailError = emailTextFieldValidator(email);
                                        if (emailError == null) {
                                          FocusScope.of(context).unfocus();
                                          pageController.nextPage(
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOut);
                                        }
                                      });
                                    } else {
                                      if (tosList != null && tosList!.isNotEmpty) {
                                        _validateInput(false);
                                      } else {
                                        _validateInput(true);
                                      }
                                    }
                                    break;
                                  }
                                  case 1: {
                                    setState(() {
                                      final password = passwordController.text.tr;
                                      passwordError = passwordTextFieldValidator(password);
                                      if (passwordError == null) {
                                        final passwordCheck = passwordCheckController.text.tr;
                                        if (password != passwordCheck) {
                                          passwordCheckError = "비밀번호가 일치하지 않습니다!";
                                        } else {
                                          passwordCheckError = null;

                                          FocusScope.of(context).unfocus();
                                          pageController.nextPage(
                                              duration: const Duration(milliseconds: 250),
                                              curve: Curves.easeInOut);
                                        }
                                      }
                                    });
                                    break;
                                  }
                                  case 2: {
                                    if (tosList != null && tosList!.isNotEmpty) {
                                      _validateInput(false);
                                    } else {
                                      _validateInput(true);
                                    }
                                    break;
                                  }
                                }
                              },
                            ),
                          )
                      )
                    ],
                  )
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('데이터 로딩중 오류가 발생했습니다. 로그아웃 후 다시 시도해주세요.'),
                      const SizedBox(height: 24,),
                      FilledButton(
                          onPressed: () {
                            AuthController.to.signOut();
                          },
                          child: Text('로그아웃')
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        } else {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: const Scaffold(
              body: SafeArea(
                child: Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 24,),
                      Text('회원가입 데이터 로딩중')
                    ],
                  ),
                ),
              ),
            )
          );
        }
      },
    );
  }

  void _validateInput(bool noTos) async {
    final email = emailController.text.tr;
    final password = passwordController.text.tr;
    final nickname = nicknameController.text.tr;
    final phoneNumber = phoneNumberController.text.tr;
    final sex = selectedSex;
    final birth = birthController.text.tr;

    if (_formKey.currentState!.validate() && await checkNickname(nickname)) {
      if (noTos) {
        setState(() {
          FocusScope.of(context).unfocus();
          if (AuthController.to.user.value == null) {
            AuthController.to.registerEmail(email, password);
          } else {
            List<int> agreeTermIdx = [];
            if (tosList != null) {
              for (var t in tosList!) {
                if (t['agree']) agreeTermIdx.add(t['id']);
              }
            }
            ProfileController.to.makeUserProfile(nickname, phoneNumber, birth.replaceAll('/', '-') + "T00:00:00.000Z", sex.index, agreeTermIdx);
          }
        });
      } else {
        showModalBottomSheet(
          useSafeArea: true,
          isScrollControlled: true,
          context: context,
          builder: (BuildContext context) {
            return _tosAgreePage();
          },
          enableDrag: false
        );
      }
    }
  }

  void _pressedBack() {
    if (pageController.page!.toInt() == 0) {
      if (AuthController.to.user.value == null) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("회원가입 필요"),
              content: Text("${AuthController.to.user.value!.email!} 계정은 회원가입이 완료되지 않았습니다. 현재 계정을 로그아웃 하고 다른 계정으로 로그인 하시겠습니다?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                    AuthController.to.signOut();
                  },
                  child: Text("로그아웃")
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                  child: Text("회원가입 하기")
                ),
              ],
            );
          },
        );
      }
    } else {
      FocusScope.of(context).unfocus();
      pageController.previousPage(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut
      );
    }
  }
}