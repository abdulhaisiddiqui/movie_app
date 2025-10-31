import 'package:flutter/material.dart';
import 'package:myapp/core/routes/app_routes.dart';
import 'package:myapp/services/firebase_auth_service.dart';
import 'package:myapp/views/screens/Login_Signup/signup_screen.dart';
import 'package:myapp/core/widgets/UiHelper.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();


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
          //         BoxShadow(
          //           color: const Color(0xFF7000FF).withOpacity(0.1),
          //
          //         ),
          //
          //       ],
          //     ),
          //   ),
          // ),
          Padding(
            padding: EdgeInsetsGeometry.only(bottom: 60),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  width: double.infinity,
                  height: 600,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),

                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 4,
                        blurRadius: 12,
                        offset: const Offset(0, 8),
                      ),
                    ],

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
                                "Login",
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
                              controller: emailController,
                              HintText: "Enter Your Email",
                              icon: const Icon(
                                Icons.email,
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(height: 25),

                            UiHelper.CustomTextFields(
                              controller: passwordController,
                              HintText: "Enter your Password",
                              icon: const Icon(
                                Icons.security,
                                color: Colors.white70,
                              ),
                            ),

                            const SizedBox(height: 40),
                            // Login Button
                            Consumer<FirebaseAuthService>(builder: (context ,authVM,child){
                              return Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ).copyWith(
                                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                      shadowColor: WidgetStateProperty.all(Colors.transparent),
                                    ),
                                    onPressed: authVM.isLoading
                                        ? null
                                        : () async {

                                      await authVM.signIn(
                                        context,
                                        emailController.text.trim(),
                                        passwordController.text.trim(),
                                      );

                                    },
                                    child: authVM.isLoading
                                        ? const SizedBox(
                                      width: 25,
                                      height: 25,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Colors.pink,
                                          strokeWidth: 3,
                                        ),
                                      ),
                                    )
                                        : UiHelper.CustomButtons(text: "Login"),
                                  ),
                                ),
                              );
                            }),
                            SizedBox(height: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(context, AppRoutes.signup);
                              },
                              child: UiHelper.CustomText(
                                text: 'Create an account? Sign up',
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
          ),
        ],
      ),
    );
  }
}
