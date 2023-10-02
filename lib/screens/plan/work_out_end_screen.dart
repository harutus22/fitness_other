import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/training_done_model.dart';
import 'package:fitness/screens/challenges/challenge_screen.dart';
import 'package:fitness/screens/main_menu_screen.dart';
import 'package:fitness/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../model/challane_model.dart';
import '../../utils/colors.dart';
import '../../utils/words.dart';

class WorkOutEndScreen extends StatefulWidget {
  const WorkOutEndScreen({Key? key}) : super(key: key);

  @override
  State<WorkOutEndScreen> createState() => _WorkOutEndScreenState();
}

class _WorkOutEndScreenState extends State<WorkOutEndScreen> {
  int _selectedFeedback = -1;

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final map = ModalRoute.of(context)?.settings.arguments as Map;
    final name = map[planExerciseName] as String;
    final kcal = map[planExerciseKcal] as double;
    final exerciseCount = map[planExerciseCount] as int;
    final time = map[planExerciseTime] as String;
    final total = map[planExerciseTotal] as int;
    final challengeItem = map[challenge_item] as ChallengeModel?;
    final warmCount = map[planExerciseCalendarPass] as int;
    int dayCount = challengeItem != null
        ? challengeItem.isPassed!.contains(true)
            ? challengeItem.isPassed!
                    .indexWhere((element) => element == false) +
                1
            : 1
        : 1;
    getCalendar().then((value){
      final today = DateTime.now().day;
      for(final element in value!){
        if(element.day == today){
          if(challengeItem == null && warmCount != 0) {
            element.isChecked = 1;
            setCalendar(value);
            break;
          }
        }
      }
    });

    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                const SizedBox(
                  height: 40,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        time,
                        style: const TextStyle(
                            color: Colors.white,
                            fontFamily: 'SairaCondensed',
                            fontSize: 80),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 10,
                              ),
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
                                text: kcal.toInt().toString(),
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
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
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(20),
                  height: MediaQuery.of(context).size.height / 5 * 2,
                  width: width,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xff00C377), Color(0xff01936C)],
                  ),
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      itemHappiness("assets/images/exercise_medium.png",
                          tooEasy.tr(), 0),
                      const SizedBox(
                        width: 10,
                      ),
                      itemHappiness("assets/images/exercise_good.png",
                          hardInGoodWay.tr(), 1),
                      const SizedBox(
                        width: 10,
                      ),
                      itemHappiness("assets/images/exercise_bad.png",
                          tooHard.tr(), 2),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          var dateCurrent = DateTime.now();
                          var date = DateTime(dateCurrent.year,
                              dateCurrent.month, dateCurrent.day);
                          final training = TrainingDone(
                              date: date,
                              caloriesBurnt: kcal.toInt(),
                              timePassed: total);
                          databaseHelper.insertTrainingDone(training);
                          if (challengeItem != null) {
                            for (var item = 0;
                                item < challengeItem.isPassed!.length;
                                item++) {
                              if (challengeItem.isPassed![item] == false) {
                                challengeItem.isPassed![item] = true;
                                break;
                              }
                            }
                            databaseHelper.updateChallenge(challengeItem);
                          }
                          if(!user.isSubscribed)
                            openAdManager.showInterstitialAd((){

                            });
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) {
                                    return MainMenuScreen(
                                        numer: challengeItem != null ? 1 : null);
                                  }), (r) {
                                return false;
                              });
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 30),
                          width: width / 2,
                          decoration: BoxDecoration(
                              gradient: linearGradient,
                              borderRadius: BorderRadius.circular(24)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                            child: Text(
                              finishText.tr(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                fontFamily: 'SairaCondensed',),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Expanded(child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(resultTxt.tr(),style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: 'SairaCondensed',)),
                      SizedBox(width: 10,),
                      SvgPicture.asset("assets/images/checked.svg", height: 20,)
                    ],
                  ),
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemHappiness(String image, String title, int number) {
    return GestureDetector(
      onTap: () {
        _selectedFeedback = number;
        setState(() {});
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          width: MediaQuery.of(context).size.width / 5 * 4,
          decoration: BoxDecoration(
            color: Color(0xffD9D9D9).withOpacity(.52),
            border: Border.all(
                width: 2,
                color: _selectedFeedback == number
                    ? const Color(0xffCDCDCF)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10), //<-- SEE HERE
          ),
          child: Row(
            children: [
              Image.asset(image, height: 20,),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SairaCondensed', fontSize: 18),
              ),
            ],
          )),
    );
  }

  Widget itemColumn(String title, String item) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'SairaCondensed',),
        ),
        const SizedBox(
          width: 10,
        ),
        Text(
          item,
          style: TextStyle(
              fontWeight: FontWeight.w500, color: Colors.grey, fontSize: 20, fontFamily: 'SairaCondensed',),
        )
      ],
    );
  }
}
