import 'package:flutter/material.dart';

const String splashScreen = "/splash_screen";
const String userNameScreen = "/userNameScreen";
const String userAgeScreen = "/userAgeScreen";
const String userHeightScreen = "/userHeightScreen";
const String userCurrentWeightScreen = "/userCurrentWeightScreen";
const String userTargetWeightScreen = "/userTargetWeightScreen";
const String genderScreen = "/gender_screen";
const String motivationScreen = "/motivation_screen";
const String trainingSetScreen = "/training_set_screen";
const String deepSquatsScreen = "/deep_squats_screen";
const String plankScreen = "/plank_screen";
const String highKneesScreen = "/high_knees_screen";
const String pushUpsScreen = "/push_ups_screen";
const String sitUpsScreen = "/sit_ups_screen";
const String burpeesScreen = "/burpees_screen";
const String planCalculationScreen = "/plan_calculation_screen";
const String bodyMassIndexScreen = "/body_mass_index_screen";
const String basalMetabolicRateScreen = "/basal_metabolic_rate_screen";
const String loaderScreen = "/loader_screen";
const String payWallScreen = "/paywall_screen";
const String mainMenuScreen = "/main_menu_screen";
const String planDetailedScreen = "/plan_detailed_screen";
const String planWorkoutStartScreen = "/plan_work_out_start_screen";
const String planWorkoutEndScreen = "/plan_work_out_end_screen";
const String nameWorkoutScreen = "/name_workout_screen";
const String chooseWorkoutScreen = "/choose_workout_screen";
const String quantityScreen = "/quantity_work_out_screen";
const String createMainScreen = "/create_main_screen";
const String createExerciseFinalScreen = "/create_exercise_final_screen";
const String createdDetailedPreStartScreen = "/created_detailed_pre_start_screen";
const String profileAboutMeScreen = "/profile_about_me_screen";
const String profileChangeDetailsScreen = "/profile_change_details_screen";
const String profileReminderScreen = "/profile_reminder_screen";
const String profileReminderTimeChooseScreen = "/profile_reminder_time_chooser_screen";

Future<T?> changeScreen<T extends Object?>(String route, BuildContext context, {Object? argument}) {
  return Navigator.pushNamed(context, route, arguments: argument);
}

void popScreen(BuildContext context, {Object? argument}){
  Navigator.pop(context, argument);
}