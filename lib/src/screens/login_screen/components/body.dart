import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:tayt_app/src/deps/colors.dart';
import 'package:tayt_app/src/widgets/nav_bar.dart';
import 'package:tayt_app/src/screens/signup_screen/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:tayt_app/provider/authentication_provider.dart';

class Body extends StatefulWidget {
  Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void initState() {
    super.initState();
    // Fetch clothing items when the Body widget is initialized
    Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    bool noLoginError = true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Image.asset(
              'assets/images/primarycolor_swatch.png',
              height: 400,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Positioned(
              bottom: 20,
              left: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Sign In',
                    style: Theme.of(context).textTheme.displayMedium!.copyWith(
                          color: AppColors.secondaryColor,
                          fontSize: 64,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(left: 25.0, top: 20, right: 20, bottom: 12),
          child: Text(
            'Welcome back!',
            style: TextStyle(fontSize: 20, fontFamily: 'Helvetica Neue'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: _emailController,
            style: const TextStyle(
              color: const Color.fromARGB(255, 100, 100, 100),
              fontSize: 15,
              fontFamily: 'Helvetica Neue',
            ),
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Color.fromARGB(255, 243, 220, 166),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              contentPadding: const EdgeInsets.only(left: 25.0, right: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(70.0),
              ),
              hintText: 'Email',
              suffixIcon: const Icon(
                Icons.email,
                color: Colors.black,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0),
          child: TextField(
            controller: _passwordController,
            style: const TextStyle(
              color: Color.fromARGB(255, 100, 100, 100),
              fontSize: 15,
              fontFamily: 'Helvetica Neue',
            ),
            obscureText: true,
            decoration: InputDecoration(
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(
                    width: 2,
                    color: Color.fromARGB(255, 243, 220, 166),
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(40))),
              contentPadding: const EdgeInsets.only(left: 25.0, right: 20.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(70.0),
              ),
              hintText: 'Password',
              suffixIcon: const Icon(
                Icons.lock,
                color: Colors.black,
              ),
            ),
          ),
        ),
        // SizedBox(height: 20),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 20.0,
            ),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await authProvider.login(
                      _emailController.text, _passwordController.text);
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) =>
                          BottomNavBar(), // Replace with your desired screen
                    ),
                  );
                } catch (e) {
                  _emailController.clear();
                  _passwordController.clear();
                  noLoginError = false;
                  String errorMessage = e is AuthenticationException
                      ? e.message
                      : 'Unknown error';
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    backgroundColor: AppColors.secondaryColor,
                    content: Text(
                      errorMessage,
                      style: TextStyle(color: AppColors.primaryColor),
                    ),
                  ));
                  noLoginError = true;
                }
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(350, 20),
                backgroundColor: AppColors.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(70.0),
                ),
                shadowColor: Colors.black.withOpacity(0.5),
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 12.0),
              ),
              child: Text(
                'Submit',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 15,
                      fontFamily: 'Helvetica Neue',
                    ),
              ),
            ),
          ),
        ),
        SizedBox(height: 30),
        Column(
          children: [
            Center(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Helvetica Neue',
                    fontSize: 15,
                  ),
                  children: [
                    TextSpan(
                      text: "Don't have an account yet? ",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: "Create one",
                      style: TextStyle(
                          color: AppColors.primaryColor,
                          decoration: TextDecoration.underline),
                      // add underline to the text
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                SignupScreen(), // Navigate to the sign-up page
                          ));
                        },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
