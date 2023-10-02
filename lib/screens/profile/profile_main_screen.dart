
import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/routes.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:math' as math;
import 'dart:io';

import '../../model/user_info_enums.dart';

class ProfileMainScreen extends StatefulWidget {
  const ProfileMainScreen({Key? key}) : super(key: key);

  @override
  State<ProfileMainScreen> createState() => _ProfileMainScreenState();
}

class _ProfileMainScreenState extends State<ProfileMainScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentDate();
  }

  int completedTraining = 0;
  int kcalSpend = 0;
  int timePassed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 10,),
            InkWell(
              onTap: () async {
                if(user.isSubscribed == false){
                  await changeScreen(payWallScreen, context, argument: canPop);
                  setState(() {});
                }
              },
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () async{
                      //TODO
                    },
                      child: Image.asset("assets/images/premium.png")),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    user.isSubscribed == true ?
                    premium.tr() : becomePremium.tr(),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold,
                      fontFamily: 'SairaCondensed',),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: (){
                            _getFromGallery();
                          },
                          child: FutureBuilder(
                            future: _getProfileImage(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                final item = snapshot.data;
                                return  item == null || item.isEmpty ? Image.asset(user.gender == Gender.male
                                      ? "assets/images/profile_male.png"
                                      : "assets/images/profile_female.png",
                                    height: 80, width: 80,) :
                                      Image.file(File('$item'), height: 80, width: 80,);
                              } else {
                                return Image.asset(user.gender == Gender.male
                                    ? "assets/images/profile_male.png"
                                    : "assets/images/profile_female.png",
                                  height: 80, width: 80,);
                              }
                            }
                          ),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          user.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.black, fontFamily: 'SairaCondensed',),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        // margin: EdgeInsets.symmetric(vertical: ),
                        width: MediaQuery.of(context).size.width / 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                ShaderMask(
                                  shaderCallback: (Rect bounds) {
                                    return bottomItemTextGradient;
                                  },
                                  child: SvgPicture.asset(
                                    "assets/images/fire.svg",
                                    height: 28,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Burned",
                                  style: TextStyle(
                                      fontFamily: 'SairaCondensed',
                                      fontSize: 20,
                                      color: Colors.grey),
                                )
                              ],
                            ),
                            RichText(
                                text: TextSpan(children: [
                                  TextSpan(
                                      text: user.caloriesBurned.toString(),
                                      style: TextStyle(
                                        fontSize: 32,
                                        color: Colors.black,
                                        fontFamily: 'SairaCondensed',
                                      )),
                                  WidgetSpan(
                                      child: SizedBox(
                                        width: 10,
                                      )),
                                  TextSpan(
                                      text: kcalText.tr(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'SairaCondensed',
                                          color: Colors.grey)),
                                ]))
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 40,),
            Column(
              children: [
                menuItem(true, aboutMe.tr()),
                const SizedBox(height: 20,),
                menuItem(true, reminder.tr()),
                const SizedBox(height: 20,),
                menuItem(true, rateUs.tr()),
                const SizedBox(height: 20,),
                menuItem(true, termsCondition.tr()),
                const SizedBox(height: 20,),
                menuItem(false, privacy.tr()),
                const SizedBox(height: 20,),
              ],
            ),
            Flexible(child: Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  //TODO sign out no meaning
                  exit(0);
                },
                child: Text("",
                    style: TextStyle(
                      // foreground: Paint()
                      //   ..shader =
                      //       textLinearGradient,
                      fontFamily: 'SairaCondensed',
                    fontSize: 24)),
              ),
            ))
          ],
        ),
      ),
    );
  }

  Widget trainingItem(String image, String value) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          image,
          width: 28,
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          value,
          style: const TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
        )
      ],
    );
  }

  Widget menuItem(bool dividerShown, String title) {
    return InkWell(
      onTap: () async {
        if(title == aboutMe.tr()){
          changeScreen(profileAboutMeScreen, context);
        } else if(title == changeDetails.tr()){
          changeScreen(profileChangeDetailsScreen, context);
        } else if(title == reminder.tr()){
          changeScreen(profileReminderScreen, context);
        } else if(title == termsCondition.tr()){
          launchUrlCall(Uri.parse(termsUrl));
        } else if(title == privacy.tr()){
          launchUrlCall(Uri.parse(privacyUrl));
        } else {
          final InAppReview inAppReview = InAppReview.instance;

          if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
        }
        }
      },

      child:
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 20, vertical: 0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title.tr(),
                  style: const TextStyle(
                      fontSize: 26, color: Colors.black,fontFamily: 'SairaCondensed',),
                ),
                Icon(Icons.arrow_forward_ios)
              ],
            ),
            SizedBox(height: 15,),
            dividerShown ? Divider(
              color: const Color(0xff0E1618).withOpacity(0.1),
              height: 2,
              thickness: 1,
            ): SizedBox(),
          ],
        ),
      ),
    );
  }

  void getCurrentDate(){
    final current = DateTime.now();
    final date = DateTime(current.year, current.month, current.day);
    databaseHelper.getTrainingDone(date.toIso8601String()).then((value) => {
    completedTraining = value.length,
      if(completedTraining == 0){
        kcalSpend = 0,
        timePassed = 0,
      } else
        {
          for(var item in value){
            kcalSpend += item.caloriesBurnt,
            timePassed += item.timePassed
          },
        },
      setState((){}),
    });
  }

  _getFromGallery() async {
    final _picker =  await ImagePicker().pickImage(source: ImageSource.gallery);
    if(_picker == null) return;

    String tempImage = await _picker.path;
    _setProfileImage(tempImage);

  }

  void _setProfileImage(String image) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("profile_image", image);
    setState(() {});
  }

  Future<String?> _getProfileImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userPref = prefs.getString("profile_image");
    return userPref;
  }
}
