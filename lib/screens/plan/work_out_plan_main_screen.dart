import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/calendar_item.dart';
import 'package:fitness/screens/plan/work_out_plan_item.dart';
import 'package:fitness/utils/Routes.dart';
import 'package:fitness/utils/const.dart';
import 'package:fitness/utils/words.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../model/plan_model_static.dart';
import '../../utils/colors.dart';
import '../onboarding/paywall_screen.dart';

class WorkOutPlanMainScreen extends StatefulWidget {
  const WorkOutPlanMainScreen({Key? key}) : super(key: key);

  @override
  State<WorkOutPlanMainScreen> createState() => _WorkOutPlanMainScreenState();
}

class _WorkOutPlanMainScreenState extends State<WorkOutPlanMainScreen> {
  String name = "";
  List<PlanModelStatic> planModels = [];
  double count = 0;
  bool isSubscribed = false;
  DateTime? _selectedDay;
  DateTime? _focusedDay;
  List<CalendarItem> calendarsItems = [];

  Future<void> _checkSubs() async {
    final shared = await SharedPreferences.getInstance();
    final res = shared.getString(date);
    if (res != null) {
      final a = DateTime.now().compareTo(DateTime.parse(res));
      isSubscribed = a < 0;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _checkSubs();
    inita();
    _getUserName();
    getUser().then((value) => {
          isSubscribed = value!.isSubscribed,
        });
  }

  void inita() async {
    await databaseHelper.init();
    // setCalendar([]);
    getCalendar().then((value) {
      if (value == null || value.isEmpty) {
        createMonthWorkout();
      } else {
        final date = DateTime.now().month;
        if (value[0].month != date) {
          createMonthWorkout();
        } else {
          final currentDate = DateTime.now().day;
          for(final i in value){
            if(i.day == currentDate){
              setCalendar(value);
              break;
            }
            if(i.day < currentDate && i.isChecked == 0){
              i.isChecked = 2;
            }
          }
          calendarsItems.addAll(value);
          setState(() {});
        }
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // databaseHelper.close();
  }

  void createMonthWorkout() {
    List<CalendarItem> calendars = [];
    final date = DateTime.now();
    final currentMonth = date.month;
    final currentDay = date.day;
    int weekday = date.weekday;
    var previousWeekDay = false;
    if(weekday % 2 != 0)
      previousWeekDay = true;
    final monthName = DateFormat("MMMM").format(date);
    int dayCount = DateTime(date.year, date.month + 1, 0).day;
    for (var counting = currentDay; counting <= dayCount; counting++) {
      if (count == 4.0) {
        if (previousWeekDay) {
          if (weekday == 1 || weekday == 3 || weekday == 5 || weekday == 7) {
            calendars.add(
                CalendarItem(isChecked: 0, day: counting, month: currentMonth));
          }
        } else {
          if (weekday == 2 || weekday == 4 || weekday == 5 || weekday == 6) {
            calendars.add(
                CalendarItem(isChecked: 0, day: counting, month: currentMonth));
          }
        }
      } else if (count == 5.0) {
        if (previousWeekDay) {
          if (weekday == 1 ||
              weekday == 2 ||
              weekday == 3 ||
              weekday == 5 ||
              weekday == 6) {
            calendars.add(
                CalendarItem(isChecked: 0, day: counting, month: currentMonth));
          }
        } else {
          if (weekday == 1 ||
              weekday == 2 ||
              weekday == 4 ||
              weekday == 5 ||
              weekday == 6) {
            calendars.add(
                CalendarItem(isChecked: 0, day: counting, month: currentMonth));
          }
        }
      } else {
        if (previousWeekDay) {
          if (weekday == 1 || weekday == 3 || weekday == 5) {
            calendars.add(
                CalendarItem(isChecked: 0, day: counting, month: currentMonth));
          }
        } else {
          if (weekday == 2 || weekday == 4 || weekday == 6) {
            calendars.add(
                CalendarItem(isChecked: 0, day: counting, month: currentMonth));
          }
        }
      }
      if ((counting - currentDay) % 7 == 0) {
        previousWeekDay = !previousWeekDay;
      }
      ++weekday;
      if(weekday == 8)
        weekday = 1;
    }

    print(monthName);
    setCalendar(calendars);
    calendarsItems.addAll(calendars);
    setState(() {});
  }

  void _getUserName() async {

    name = user.name;
    count = user.totalCount.toDouble();
    final item = await getWorkoutWeekDate();
    if (item == null) {
      _setDatabase();
    } else if (item == false) {
      planModels.addAll(await getWeekPlans());
      setState(() {});
    } else {
      _setDatabase();
    }
  }

  void _setDatabase() {
    databaseHelper.getStaticPlanModels().then((value) => {
          planModels.addAll(_getListStaticModel(
              value
                  .where((element) => element.restBetweenExercises! > 0)
                  .toList(),
              count)),
          _setWeeks(),
        });
  }

  void _setWeeks() async {
    setWorkoutWeekDate();
    _setImages();
    setWeekPlans(planModels);
    setState(() {});
  }

  void _setImages() {
    List<int> numbers = [];
    for (var item in planModels) {
      var random = Random().nextInt(15) + 1;
      while (numbers.contains(random)) {
        random = Random().nextInt(15) + 1;
      }
      numbers.add(random);
      item.image = "assets/images/covers/$random.png";
    }
  }

  List<PlanModelStatic> _getListStaticModel(
      List<PlanModelStatic> list, final double diff) {
    List<PlanModelStatic> retList = [];
    int a = 0;
    if (diff <= 3) {
      a = 3;
    } else if (diff > 3 && diff <= 4) {
      a = 4;
    } else {
      a = 5;
    }
    for (int i = 0; i < a; i++) {
      PlanModelStatic item = getStaticModel("Cardio", list);
      while (retList.contains(item)) {
        item = getStaticModel("Cardio", list);
      }
      retList.add(item);
    }
    return retList;
  }

  PlanModelStatic getStaticModel(
      String text, List<PlanModelStatic> chosenList) {
    List<PlanModelStatic> finalList =
        chosenList.where((element) => element.type!.contains(text)).toList();
    return finalList[Random().nextInt(finalList.length)];
  }

  final style = const TextStyle(
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontSize: 24,
    fontFamily: 'SairaCondensed',
  );

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final height2 = (height *0.00355).toInt();
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Column(
            children: [
              Wrap(
                runSpacing: 0,
                spacing: 5,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      textAlign: TextAlign.start,
                      text: TextSpan(children: [
                        TextSpan(
                          text: planNameHey.tr(),
                        ),
                        TextSpan(
                            text: name,
                            style: TextStyle(
                                foreground: Paint()
                                  ..shader = textLinearGradient,
                              fontFamily: 'SairaCondensed',)),
                        const TextSpan(text: ", "),
                      ], style: style),
                    ),
                  ),
                  Text(planNameWorkout.tr(),
                      style: style, textAlign: TextAlign.start)
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 3,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: linearGradient,
                  ),
                  child: Container(
                    margin: EdgeInsets.all(3),
                    color: backgroundColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TableCalendar(
                          daysOfWeekStyle: DaysOfWeekStyle(
                            weekdayStyle: TextStyle(
                              fontFamily: 'SairaCondensed',
                              color: Colors.white
                            ),
                            weekendStyle: TextStyle(
                                fontFamily: 'SairaCondensed',
                                color: Colors.white
                            ),
                          ),
                          availableGestures: AvailableGestures.none,
                          // rowHeight: 50, ios
                          rowHeight: height2 *13,
                          firstDay: DateTime.utc(2023, 1, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          focusedDay: DateTime.now(),
                          startingDayOfWeek: StartingDayOfWeek.sunday,
                          availableCalendarFormats: const {
                            CalendarFormat.month: 'Month',
                          },
                          headerStyle: HeaderStyle(
                            titleTextFormatter: (date, locale) => _firstLetterUp(DateFormat.yMMMM(locale).format(date)),
                              titleTextStyle:
                                  TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'SairaCondensed',),
                              headerMargin: EdgeInsets.symmetric(vertical: 0),
                              titleCentered: true,
                              leftChevronPadding: EdgeInsets.zero,
                              rightChevronPadding: EdgeInsets.zero,
                              leftChevronVisible: false,
                              rightChevronVisible: false),
                          calendarStyle: CalendarStyle(
                              ),

                          calendarBuilders: CalendarBuilders(
                            outsideBuilder: (context, day, time){
                              final text = DateFormat("dd").format(day);
                              return Container(
                                margin: EdgeInsets.only(top: 7),
                                alignment: Alignment.topCenter,
                                child: Text(
                                  text,
                                  style: TextStyle(color: Colors.grey, fontFamily: 'SairaCondensed',fontSize: height2 * 4)
                                ),
                              );
                            },
                            todayBuilder: (context, day, time) {
                              final text = DateFormat("dd").format(day);
                              final haveThatDay = calendarsItems.firstWhere((element) => element.day == day.day, orElse: CalendarItem.empty);
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color:  Color(0xff5D6364),
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: height2 / 3, horizontal: height2 / 3 * 10),
                                  margin: EdgeInsets.symmetric(vertical: height2 / 3 ),
                                  child: ConstrainedBox(
                                    constraints: new BoxConstraints(
                                    minHeight: height2 / 3  * 10,
                                    minWidth:  height2 / 3 * 10,
                                    maxHeight: height2/ 3 * 35,
                                    maxWidth: height2 /3 * 15,
                                  ),
                                    child: Column(
                                      children: [
                                        Text(
                                          text,
                                          style: TextStyle(color: Colors.white, fontFamily: 'SairaCondensed',
                                          fontSize: height2 * 4),
                                        ),
                                        SizedBox(
                                            height: height2 / 3,
                                        ),
                                        CalendarDayView(day.day, height2.toDouble())
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                            defaultBuilder: (context, day, time) {
                              final haveThatDay = calendarsItems.firstWhere((element) => element.day == day.day, orElse: CalendarItem.empty);
                              final text = DateFormat("dd").format(day);
                              return Center(
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: haveThatDay.day == day.day ? Color(0xff2C3233) : null,
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(
                                      vertical: height2 / 3, horizontal: height2 / 3 * 10),
                                  margin: EdgeInsets.symmetric(vertical: height2 / 3 ),
                                  child: ConstrainedBox(
                                    constraints: new BoxConstraints(
                                      minHeight: height2 / 3  * 10,
                                      minWidth:  height2 / 3 * 10,
                                      maxHeight: height2/ 3 * 35,
                                      maxWidth: height2 /3 * 15,
                                    ),
                                    child: Column(
                                      children: [
                                        Text(
                                          text,
                                          style: TextStyle(color: Colors.white, fontFamily: 'SairaCondensed',
                                              fontSize: height2 * 4),
                                        ),
                                        SizedBox(
                                          height: height2 / 3,
                                        ),
                                        CalendarDayView(day.day, height2.toDouble())
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CalendarMeanings("assets/images/calendar_skipped.svg", missedTxt.tr()),
                            CalendarMeanings("assets/images/calendar_done.png", completedTxt.tr()),
                            CalendarMeanings("assets/images/calendar_not_done.svg", followTxt.tr()),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Align(
                child: Text(
                  "My personal plan",
                  style: TextStyle(fontSize: 24, color: Color(0xff919BA9), fontFamily: 'SairaCondensed',),
                ),
                alignment: Alignment.centerLeft,
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                  flex: 2,
                  child: planModels.isEmpty
                      ? Container(
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, position) {
                            return Column(
                              children: [
                                WorkOutPlanItem(
                                  workOutPlanItemModel: planModels[position],
                                  workoutFunction: (workoutItem, isFree) async {
                                    if (isFree) {
                                      changeScreen(planDetailedScreen, context,
                                          argument: workoutItem);
                                    } else {
                                      await changeScreen(payWallScreen, context,
                                          argument: canPop);
                                      setState(() {});
                                    }
                                  },
                                  image: planModels[position].image!,
                                  isFree: position > 1 ? isSubscribed : true,
                                ),
                                position != planModels.length - 1
                                    ? const SizedBox(
                                        height: 10,
                                      )
                                    : const SizedBox()
                              ],
                            );
                          },
                          itemCount: planModels.length))
            ],
          ),
        ),
      ),
    );
  }


  List<bool> _getEventsForDay(DateTime day) {
    return events[day.day] ?? [];
  }

  final events = List.generate(32, (index) => [true]);

  Widget CalendarMeanings(String image, String text){
    final imageSize = 10.0;
    return Row(
      children: [
        image.contains(".png") ?
            Image.asset(image, height: imageSize,)
            :
      SvgPicture.asset(
      image,
      height: imageSize,
      color: Colors.white,
    ),
        SizedBox(width: 4,),
        Text(text, style: TextStyle(fontSize: 16, color: Color(0xff919BA9), fontFamily: 'SairaCondensed',))
      ],
    );
  }

  Widget CalendarDayView(int day, double size) {
    final imageSize = size * 2.5;
    CalendarItem? calendarItem;
    final today = DateTime.now().day;
    for(var item = 0; item < calendarsItems.length; item++){
      if(calendarsItems[item].day < today && calendarsItems[item].isChecked == 0){
        calendarsItems[item].isChecked == 2;
      }
      if(calendarsItems[item].day == day){
        calendarItem = calendarsItems[item];
        break;
      }
    }
    if (calendarItem != null) {
      if (calendarItem.isChecked == 0) {
        return SvgPicture.asset(
          "assets/images/calendar_not_done.svg",
          height: imageSize,
          color: Colors.white,
        );
      } else if (calendarItem.isChecked == 1) {
        return Image.asset("assets/images/calendar_done.png", height: imageSize);
      } else {
        return SvgPicture.asset(
          "assets/images/calendar_skipped.svg",
          height: imageSize,
          color: Colors.white,
        );
      }
    } else {
      return SizedBox();
    }
  }

  String _firstLetterUp(String text){
    return "${text[0].toUpperCase()}${text.substring(1)}";;
  }
}
