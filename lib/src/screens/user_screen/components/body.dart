import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tayt_app/provider/authentication_provider.dart';
import 'package:tayt_app/src/deps/colors.dart';
import 'package:tayt_app/src/deps/carousel.dart';
import 'package:tayt_app/src/screens/body_mesh_screen/body_mesh_screen.dart';
import 'package:tayt_app/src/screens/body_screen/body_screen.dart';

class Body extends StatelessWidget {
  const Body({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              //circle avatar
              Container(
                margin: const EdgeInsets.only(top: 20),
                child: Stack(children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: AppColors.secondaryColor,
                  ),
                  CircleAvatar(
                    radius: 75,
                    backgroundImage: AssetImage('assets/images/user.jpg'),
                  ),
                ]),
              ),
              const SizedBox(
                height: 20,
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                    text: 'Hi, ',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontFamily: 'Helvetica Neue',
                          fontWeight: FontWeight.w600,
                        )),
                const TextSpan(
                    text: 'Group 2',
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: 'Helvetica Neue',
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.secondaryColor,
                        decorationStyle: TextDecorationStyle.double,
                        decorationThickness: 3)),
                TextSpan(
                    text: '!',
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: AppColors.primaryColor,
                          fontSize: 24,
                          fontFamily: 'Helvetica Neue',
                          fontWeight: FontWeight.w600,
                        )),
              ])),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                onTap: () {
                  try {
                    print("Navigating to BodyMeshScreen...");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BodyMeshScreen(),
                      ),
                    );
                  } catch (e) {
                    print("Error navigating to BodyMeshScreen: $e");
                  }
                },
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryColor,
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset:
                              const Offset(2, 3), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.edit, color: AppColors.secondaryColor),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'My Body',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.secondaryColor,
                                fontSize: 20,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              const SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {},
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.secondaryColor,
                          spreadRadius: 1,
                          blurRadius: 0,
                          offset:
                              const Offset(2, 3), // changes position of shadow
                        ),
                      ]),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(FontAwesomeIcons.personCircleQuestion,
                            color: AppColors.secondaryColor),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Help & Support',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                color: AppColors.secondaryColor,
                                fontSize: 20,
                                fontFamily: 'Helvetica Neue',
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30, left: 16.0),
          child: const Text('Recently Viewed',
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Helvetica Neue',
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryColor)),
        ),
        const SizedBox(
          height: 10,
        ),
        Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: CustomCarousel(
                banners:
                    authProvider.recentItems.map((e) => e.frontImage).toList(),
                height: 200,
                width: 200,
                hasIndicator: false,
                viewportFraction: 0.55,
                infscroll: false,
                linked: true,
                linkedImages: authProvider.recentItems.toList(),
                bgColor: AppColors.secondaryColor)),
      ],
    );
  }
}
