import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mpaiapp/services/authenticationService.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _key = GlobalKey<FormState>();

  final AuthenticationServices _auth = AuthenticationServices();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewInsets;
    var bottomInsets = 0.0;

    if (bottomPadding.bottom - 80 >= 0) {
      bottomInsets = bottomPadding.bottom - 80;
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.3),
                  radius: 0.8,
                  colors: [
                    Color(0xffff5d5d),
                    Color(0xffcc0015),
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0).copyWith(
                  top: MediaQuery.paddingOf(context).top,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Center(
                        child: SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.4,
                          child: Image.asset(
                            'assets/images/botos_clear.png',
                            colorBlendMode: BlendMode.srcIn,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CupertinoTextFormFieldRow(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      placeholder: "E-mail",
                      controller: emailController,
                      placeholderStyle: const TextStyle(
                          color: Color.fromARGB(255, 111, 111, 112)),
                      style: TextStyle(color: Colors.black54),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.redAccent),
                          color: Color.fromARGB(255, 243, 242, 242),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0,
                            )
                          ]),
                    ),
                    const SizedBox(height: 8),
                    CupertinoTextFormFieldRow(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      placeholder: "Şifre",
                      obscureText: true,
                      autocorrect: false,
                      controller: passwordController,
                      placeholderStyle: const TextStyle(
                          color: Color.fromARGB(255, 111, 111, 112)),
                      style: const TextStyle(color: Colors.black54),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.redAccent),
                          color: const Color.fromARGB(255, 243, 242, 242),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 10.0,
                            )
                          ]),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(height: 10),
                    Center(
                      child: SizedBox(
                        width: 150,
                        height: 45.0,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 3,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(32.0)),
                            ),
                            child: Text(
                              "Giriş yap",
                              style: TextStyle(fontSize: 20),
                            ),
                            onPressed: () {
                              print("butona basıldı");
                              _signInUser();
                            }),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: bottomInsets),
          SizedBox(
            height: 80,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Image.asset('assets/images/ai3.png'),
            ),
          ),
        ],
      ),
    );
  }

  void _signInUser() async {
    print("Buraya geldi.");
    final authResult = await _auth.loginUser(
      emailController.text.toString(),
      passwordController.text.toString(),
    );

    if (authResult == null) {
      print("Sign in error.");
      return _alertdialogBuilder();
    }

    try {
      emailController.clear();
      passwordController.clear();

      if (mounted) {
        Navigator.pushNamed(context, "/checkImageScreen");
      }
    } catch (e) {
      print("Sayfaya giremiyor ");
    }
  }

  void _alertdialogBuilder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Sizi bulamadık!'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 5,
              ),
              Text("Mailinizin ve şifrenizin doğruluğunu kontrol ediniz.")
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Çıkış'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
