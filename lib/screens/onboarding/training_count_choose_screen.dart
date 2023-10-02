import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/user_info_enums.dart';
import 'package:fitness/utils/colors.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:gradient_borders/box_borders/gradient_box_border.dart';
import 'package:video_player/video_player.dart';

import '../../utils/back_button.dart';
import '../../utils/custom_radio_button.dart';
import '../../utils/next_button.dart';
import '../../utils/routes.dart';

class PushUpsScreen extends StatefulWidget {
  const PushUpsScreen({Key? key}) : super(key: key);

  @override
  State<PushUpsScreen> createState() => _PushUpsScreenState();
}

class _PushUpsScreenState extends State<PushUpsScreen> {
  bool isNextActive = false;
  late VideoPlayerController _controller;
  String? _groupValue;
  final males = [
    'assets/videos/male_1.mp4',
    'assets/videos/male_2.mp4',
    'assets/videos/male_3.mp4'
  ];
  final females = [
    'assets/videos/female_1.mp4',
    'assets/videos/female_2.mp4',
    'assets/videos/female_3.mp4'
  ];
  final maleTrain = [
    [howMany.tr(), pushUp.tr(), oneSet.tr()],
    [howMany.tr(), sitUps.tr(), oneSet.tr()],
    [howMany.tr(), burpees.tr(), oneSet.tr()],
  ];
  final femaleTrain = [
    [howMany.tr(), deepSquats.tr(), oneSet.tr()],
    [youCanDo.tr(), plank.tr(), forDo.tr()],
    [youCanDo.tr(), highKnees.tr(), forDo.tr()],
  ];
  int count = 0;

  ValueChanged<String?> _valueChangedHandler() {
    return (value) =>
        {isNextActive = true, setState(() => _groupValue = value!)};
  }

  double chooseHeight = 0;
  double chooseWidth = 0;

  void setVideo(bool isFirst) {
    if(!isFirst)
      _controller.dispose();
    _controller = VideoPlayerController.asset(
        user.gender == Gender.male ? males[count] : females[count]);
    _controller.addListener(() {
      // setState(() {});
    });
    _controller.setLooping(true);
    _controller.initialize().then((_) => setState(() {}));
    _controller.play();
  }

  @override
  void initState() {
    super.initState();
    setVideo(true);
  }

  @override
  Widget build(BuildContext context) {
    chooseWidth = MediaQuery.of(context).size.width * 0.25;
    chooseHeight = MediaQuery.of(context).size.height / 7 * 3;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        --count;
                        if (count < 0) {
                          popScreen(context, argument: false);
                        } else {
                          if (count == 1) {
                            _groupValue = user.secondCount.index.toString();
                          } else if (count == 0) {
                            _groupValue = user.firstCount.index.toString();
                          }
                          isNextActive = true;
                          setVideo(false);
                          setState(() {});
                        }
                      },
                      icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                      alignment: Alignment.bottomCenter,
                    ),
                  )),
              Expanded(
                  flex: 14,
                  child: Image.asset(
                    "assets/images/onboard_4.png",
                    alignment: Alignment.center,
                  ))
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: onboardingTextSize),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  children: [
                    TextSpan(
                      text: user.gender == Gender.male
                          ? maleTrain[count][0]
                          : femaleTrain[count][0],
                    ),
                    TextSpan(
                        text: user.gender == Gender.male
                            ? maleTrain[count][1]
                            : femaleTrain[count][1],
                        style: TextStyle(
                            foreground: Paint()..shader = textLinearGradient)),
                    TextSpan(
                      text: user.gender == Gender.male
                          ? maleTrain[count][2]
                          : femaleTrain[count][2],
                    ),
                  ],
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: onboardingTextSize,
                  )),
            ),
          ),
          // MenuGridView(),
          const SizedBox(
            height: 10,
          ),
          Container(
            height: chooseHeight,
            padding: const EdgeInsets.all(20),
            child: AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                    border: const GradientBoxBorder(
                      gradient: linearGradient,
                      width: 1,
                    )
                ),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    VideoPlayer(_controller),
                  ],
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: MyRadioOption<String>(
                  value: '1',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '1',
                  text: less5Times.tr(),
                ),
              ),
              Flexible(
                child: MyRadioOption<String>(
                  value: '2',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '2',
                  text: from5To10Times.tr(),
                ),
              ),
              Flexible(
                child: MyRadioOption<String>(
                  value: '3',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '3',
                  text: from10To15Times.tr(),
                ),
              ),
              Flexible(
                child: MyRadioOption<String>(
                  value: '4',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '4',
                  text: from15To25Times.tr(),
                ),
              ),
              Flexible(
                child: MyRadioOption<String>(
                  value: '5',
                  groupValue: _groupValue,
                  onChanged: _valueChangedHandler(),
                  label: '5',
                  text: more25Times.tr(),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          next(context, "", isNextActive, () {
            if (count == 0) {
              user.firstCount = TrainingCount.values[int.parse(_groupValue!)];
            } else if (count == 1) {
              user.secondCount = TrainingCount.values[int.parse(_groupValue!)];
            } else if (count == 2) {
              user.thirdCount = TrainingCount.values[int.parse(_groupValue!)];
              changeScreen(planCalculationScreen, context);
            }
            isNextActive = false;
            ++count;
            if (count > 2)
              count = 2;
            setVideo(false);
            _groupValue = "-1";
          }),
          const SizedBox(
            height: 20,
          ),
          GestureDetector(
            onTap: () {
              if (count == 0) {
                user.firstCount = TrainingCount.noResult;
              } else if (count == 1) {
                user.secondCount = TrainingCount.noResult;
              } else if (count == 2) {
                user.thirdCount = TrainingCount.noResult;
                changeScreen(planCalculationScreen, context);
              }
              isNextActive = false;
              ++count;
              if (count > 2)
                count = 2;
                setVideo(false);

              _groupValue = "-1";
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                iDoNotKnow.tr(),
                style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    color: Colors.white,
                  fontFamily: 'SairaCondensed',),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          )
        ],
      )),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
