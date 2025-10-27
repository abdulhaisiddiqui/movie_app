import 'package:flutter/material.dart';
import 'package:myapp/core/routes/app_routes.dart';
import 'package:provider/provider.dart';

import '../../../services/firebase_auth_service.dart';
import 'package:myapp/core/widgets/UiHelper.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController cnfpasswordController = TextEditingController();

    final authVM = Provider.of<FirebaseAuthService>(context,listen: false);


    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgroundImg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Center(
          //   child: Container(
          //     width: double.infinity,
          //     height: double.infinity,
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(30),
          //       boxShadow: [
          //         // Outer purple glow
          //         BoxShadow(color: const Color(0xFF7000FF).withOpacity(0.1)),
          //       ],
          //     ),
          //   ),
          // ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),

                  // 🔹 Subtle shadow for depth
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      spreadRadius: 4,
                      blurRadius: 12,
                      offset: const Offset(0, 8),
                    ),
                  ],

                  // 🔹 Transparent gradient
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF2E0069).withOpacity(0.55), // top purple
                      const Color(
                        0xFF48002B,
                      ).withOpacity(0.45), // bottom pinkish-black
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),

                // 🔹 Content
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 100),

                      Padding(
                        padding: const EdgeInsets.only(left: 30),
                        child: Stack(
                          alignment: Alignment.center,
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              left: -40,
                              bottom: 20,
                              child: Image.asset(
                                'assets/images/streamifyLogo.png',
                                width: 103,
                                height: 79,
                              ),
                            ),
                            const Text(
                              "Sign up",
                              style: TextStyle(
                                fontSize: 50,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25.0),
                        child: Text(
                          "Watch unlimited series, movies & TV shows anytime, anywhere",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.4,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      Column(
                        children: [
                          UiHelper.CustomTextFields(
                            controller: usernameController,
                            HintText: "Username",
                            icon: const Icon(
                              Icons.person,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 25),
                          UiHelper.CustomTextFields(
                            controller: emailController,
                            HintText: "Email",
                            icon: const Icon(
                              Icons.email,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 25),

                          UiHelper.CustomTextFields(
                            controller: passwordController,
                            HintText: "Password",
                            icon: const Icon(
                              Icons.security,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 25),

                          UiHelper.CustomTextFields(
                            controller: cnfpasswordController,
                            HintText: "Confirm Password",
                            icon: const Icon(
                              Icons.security,
                              color: Colors.white70,
                            ),
                          ),

                          const SizedBox(height: 40),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: authVM.isLoading
                                    ? null
                                    : () async {

                                  await authVM.signUp(username: usernameController.text.trim(), email: emailController.text.trim(), password: passwordController.text.trim(), cnfPassword: cnfpasswordController.text.trim(), context: context);


                                },
                                style:
                                    ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ).copyWith(
                                      backgroundColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                      shadowColor: WidgetStateProperty.all(
                                        Colors.transparent,
                                      ),
                                    ),

                                  child: authVM.isLoading
                                      ?  SizedBox(
                                    width: 25,
                                    height: 25,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 3,
                                    ),
                                  )
                                      : UiHelper.CustomButtons(text: "Sign Up"),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, AppRoutes.login);
                            },
                            child: UiHelper.CustomText(
                              text: 'Already have account? Login',
                              color: Colors.white,
                              size: 14,
                              fontweight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
