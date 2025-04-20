import 'package:budgetfrontend/common/color_extension.dart';
import 'package:budgetfrontend/common_widget/primary_button.dart';
import 'package:budgetfrontend/common_widget/round_textfield.dart';
import 'package:budgetfrontend/common_widget/secondary_button.dart';
import 'package:budgetfrontend/view/login/sign_in_view.dart';
import 'package:flutter/material.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.sizeOf(context);
    return Scaffold(
      backgroundColor: TColor.gray80,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/img/app_logo.png",
                width: media.width * 0.5,
                fit: BoxFit.contain,
              ),
              const Spacer(),

              /// 💡 Email Field Block
              RoundTextField(
                title: "E-mail address",
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 10),
              RoundTextField(
                title: "Password",
                controller: txtPassword,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 30),

              /// 💡 Progress Indicator (Bars)
              Row(
                children: List.generate(
                  4,
                  (index) => Expanded(
                    child: Container(
                      height: 5,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(color: TColor.gray70),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 💡 Primary Button
              PrimaryButton(
                title: "Get Started, it's free",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpView()),
                  );
                },
              ),

              const Spacer(),

              /// 💡 Already have account
              Text(
                "Do you have already an account?",
                textAlign: TextAlign.center,
                style: TextStyle(color: TColor.white, fontSize: 14),
              ),

              const SizedBox(height: 10),

              /// 💡 Secondary Button
              SecondaryButton(
                title: "Sign in",
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignInView()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
