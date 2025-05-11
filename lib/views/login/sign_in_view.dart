import 'package:budgetfrontend/controllers/auth_controller.dart';
import 'package:budgetfrontend/views/login/fade_animation.dart';
import 'package:budgetfrontend/views/login/forgot_password_view.dart';
import 'package:budgetfrontend/views/login/hex_color.dart';
import 'package:budgetfrontend/views/login/sign_up_view.dart';
import 'package:budgetfrontend/views/home/main_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum FormData { email, password }

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

final AuthController authController = Get.put(AuthController());

class _SignInViewState extends State<SignInView> {
  Color enabled = const Color.fromARGB(255, 63, 56, 89);
  Color enabledtxt = Colors.white;
  Color deaible = Colors.grey;
  Color backgroundColor = const Color(0xFF1F1A30);
  bool ispasswordev = true;
  FormData? selected;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.1, 0.4, 0.7, 0.9],
            colors: [
              HexColor("#4b4293").withOpacity(0.8),
              HexColor("#4b4293"),
              HexColor("#08418e"),
              HexColor("#08418e"),
            ],
          ),
          image: DecorationImage(
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              HexColor("#fff").withOpacity(0.2),
              BlendMode.dstATop,
            ),
            image: const NetworkImage(
              'https://mir-s3-cdn-cf.behance.net/project_modules/fs/01b4bd84253993.5d56acc35e143.jpg',
            ),
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 5,
                  color: const Color.fromARGB(
                    255,
                    171,
                    211,
                    250,
                  ).withOpacity(0.4),
                  child: Container(
                    width: 400,
                    padding: const EdgeInsets.all(40.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeAnimation(
                          delay: 0.8,
                          child: Image.network(
                            "https://cdni.iconscout.com/illustration/premium/thumb/job-starting-date-2537382-2146478.png",
                            width: 100,
                            height: 100,
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeAnimation(
                          delay: 1,
                          child: const Text(
                            "Please sign in to continue",
                            style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeAnimation(
                          delay: 1,
                          child: Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color:
                                  selected == FormData.email
                                      ? enabled
                                      : backgroundColor,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: emailController,
                              onTap: () {
                                setState(() {
                                  selected = FormData.email;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color:
                                      selected == FormData.email
                                          ? enabledtxt
                                          : deaible,
                                  size: 20,
                                ),
                                hintText: 'Email',
                                hintStyle: TextStyle(
                                  color:
                                      selected == FormData.email
                                          ? enabledtxt
                                          : deaible,
                                  fontSize: 12,
                                ),
                              ),
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                color:
                                    selected == FormData.email
                                        ? enabledtxt
                                        : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeAnimation(
                          delay: 1,
                          child: Container(
                            width: 300,
                            height: 40,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color:
                                  selected == FormData.password
                                      ? enabled
                                      : backgroundColor,
                            ),
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              controller: passwordController,
                              onTap: () {
                                setState(() {
                                  selected = FormData.password;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: InputBorder.none,
                                border: InputBorder.none,
                                prefixIcon: Icon(
                                  Icons.lock_open_outlined,
                                  color:
                                      selected == FormData.password
                                          ? enabledtxt
                                          : deaible,
                                  size: 20,
                                ),
                                suffixIcon: IconButton(
                                  icon:
                                      ispasswordev
                                          ? Icon(
                                            Icons.visibility_off,
                                            color:
                                                selected == FormData.password
                                                    ? enabledtxt
                                                    : deaible,
                                            size: 20,
                                          )
                                          : Icon(
                                            Icons.visibility,
                                            color:
                                                selected == FormData.password
                                                    ? enabledtxt
                                                    : deaible,
                                            size: 20,
                                          ),
                                  onPressed:
                                      () => setState(
                                        () => ispasswordev = !ispasswordev,
                                      ),
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  color:
                                      selected == FormData.password
                                          ? enabledtxt
                                          : deaible,
                                  fontSize: 12,
                                ),
                              ),
                              obscureText: ispasswordev,
                              textAlignVertical: TextAlignVertical.center,
                              style: TextStyle(
                                color:
                                    selected == FormData.password
                                        ? enabledtxt
                                        : deaible,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        FadeAnimation(
                          delay: 1,
                          child: TextButton(
                            onPressed: () {
                              // Navigator.pop(context);
                              // Navigator.of(context)
                              //     .push(MaterialPageRoute(builder: (context) {
                              //   // return MyApp(isLogin: true);
                              //   return MainTabView();
                              // }
                              // ));
                              // example: login amjilttai → home руу шилжих
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                authController.login(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              } else {
                                Get.snackbar(
                                  "Алдаа",
                                  "Имэйл эсвэл нууц үгээ бөглөнө үү",
                                );
                              }
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color.fromARGB(
                                255,
                                212,
                                53,
                                227,
                              ).withOpacity(0.6),
                              padding: const EdgeInsets.symmetric(
                                vertical: 14.0,
                                horizontal: 80,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            child: Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0.5,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                //End of Center Card
                //Start of outer card
                const SizedBox(height: 10),
                FadeAnimation(
                  delay: 1,
                  child: GestureDetector(
                    onTap: (() {
                      Navigator.pop(context);
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return ForgotPasswordView();
                          },
                        ),
                      );
                    }),
                    child: Text(
                      "Can't Log In?",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                FadeAnimation(
                  delay: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey,
                          letterSpacing: 0.5,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) {
                                return SignUpView();
                              },
                            ),
                          );
                        },
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
