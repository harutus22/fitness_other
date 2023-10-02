import 'package:easy_localization/easy_localization.dart';
import 'package:fitness/model/challane_model.dart';
import 'package:fitness/model/plan_model_static.dart';
import 'package:fitness/model/training_done_model.dart';
import 'package:fitness/utils/database/initiate_plan_models.dart';
import 'package:fitness/utils/database/initiate_workout_model.dart';
import 'package:fitness/utils/words.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../model/custom_plan_model.dart';
import '../../model/reminder_workout.dart';
import '../../model/workout_model.dart';

class WorkoutModelDatabaseHelper {
  static const _databaseName = "FitnessDb.db";
  late Database _db;
  static const _databaseVersion = 1;
  static const String tableMuscleGroup = 'muscles_table';
  static const String tablePlanWorkout = 'plan_table';
  static const String tableStaticPlanWorkout = 'static_plan_table';
  static const String tableReminder = 'reminder_table';
  static const String tableTrainingDone = 'training_done_table';
  static const String tableChallenges = 'training_challenges';

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    _db = await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );

  }

  Future<void> _onConfigure(Database db) async{
    final list = initiateStartup();
    for(var item in list) {
      await db.insert(tableMuscleGroup, item.toMap());
    }

    final planList = initiatePlanModel();
    for(var item in planList){
      await db.insert(tableStaticPlanWorkout, item.toMap());
    }


    final listNames = [
      challengeFullBody1.tr(), challengeFullBody2.tr(), challengeLowerBody1.tr(), challengeLowerBody2.tr(),
      challengeCore1.tr(), challengeCore2.tr(), challengeCardio1.tr(), challengeCardio2.tr(), challengeUpperBody1.tr(), challengeUpperBody2.tr()
    ];

    final listPassed = List.generate(30, (index) => false);
    for(var item = 0; item < 10; item++){
      final challenge = ChallengeModel(name: listNames[item], isPassed: listPassed, image: "assets/images/challenge/${item + 1}.png");
      await db.insert(tableChallenges, challenge.toMap());
    }
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $tableMuscleGroup (
    $columnId INTEGER primary key,
    $columnTitle TEXT not null,
    $columnDifficulty Integer not null,
    $columnList TEXT not null,
    $columnAdditionalInfo TEXT)''');
    // fillDatabase(initiateStartup());

    await db.execute('''
    CREATE TABLE $tableStaticPlanWorkout (
    $planId INTEGER primary key autoincrement,
    $planName TEXT not null,
    $planDiffLevel INTEGER not null,
    $planWarmUp TEXT not null,
    $planWarmUpTime TEXT not null,
    $planTrainingInMin INTEGER not null,
    $planTraining TEXT not null,
    $planTrainingTime TEXT not null,
    $planHitch TEXT not null,
    $planHitchTime TEXT not null,
    $planRestBetweenExercises INTEGER not null,
    $planImage TEXT,
    $planType TEXT not null)''');

    await db.execute('''
    CREATE TABLE $tablePlanWorkout (
    $customPlanId INTEGER primary key autoincrement,
    $customPlanModelName TEXT not null,
    $customPlanCountModelList TEXT not null,
    $customPlanCount Integer not null,
    $customPlanIsChecked Integer not null)''');

    await db.execute('''
    CREATE TABLE $tableReminder (
    $reminderId INTEGER primary key autoincrement,
    $reminderTime TEXT not null,
    $reminderIsOn INTEGER not null,
    $reminderDays TEXT not null)''');

    await db.execute('''
    CREATE TABLE $tableTrainingDone (
    $trainingDoneId INTEGER primary key autoincrement,
    $trainingDoneDate TEXT not null,
    $trainingDoneCalories INTEGER not null,
    $trainingDoneTimePassed INTEGER not null)''');

    await db.execute('''
    CREATE TABLE $tableChallenges (
    $challengeId INTEGER primary key autoincrement,
    $challengeIsPassed TEXT not null,
    $challengeName TEXT not null,
    $challengeImage TEXT not null)''');

    await _onConfigure(db);
  }

  Future<WorkOutModel> insert(WorkOutModel workOutModel) async {
    workOutModel.id = await _db.insert(tableMuscleGroup, workOutModel.toMap());
    return workOutModel;
  }

  Future<List<WorkOutModel>> getWorkoutModels() async {
    List<Map> maps = await _db.query(tableMuscleGroup);
    List<WorkOutModel> list = [];
    if (maps.isNotEmpty) {
      for (var model in maps) {
        list.add(WorkOutModel.fromMap(model));
      }
    }
    return list;
  }

  Future<WorkOutModel> getWorkoutModel(int id) async{
    final model = await _db
        .query(tableMuscleGroup, where: '$columnId = ?', whereArgs: [id]);
    return WorkOutModel.fromMap(model.first);
  }

  void fillDatabase(List<WorkOutModel> list) {
    for (var element in list) {
      insert(element);
    }
  }

  Future<int> delete(int id) async {
    return await _db
        .delete(tableMuscleGroup, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(WorkOutModel todo) async {
    return await _db.update(tableMuscleGroup, todo.toMap(),
        where: '$columnId = ?', whereArgs: [todo.id]);
  }

  Future<List<ChallengeModel>> getChallenges() async {
    List<Map> maps = await _db.query(tableChallenges);
    List<ChallengeModel> list = [];
    if (maps.isNotEmpty) {
      for (var model in maps) {
        list.add(ChallengeModel.fromMap(model));
      }
    }
    return list;
  }

  Future<int> updateChallenge(ChallengeModel challenge) async {
    return await _db.update(tableChallenges, challenge.toMap(),
        where: '$challengeId = ?', whereArgs: [challenge.id]);
  }

  Future close() async => _db.close();

  Future<PlanModel> insertPlan(PlanModel planModel) async {
    planModel.id = await _db.insert(tablePlanWorkout, planModel.toJson());
    return planModel;
  }

  Future<List<PlanModel>> getPlanModels() async {
    List<Map> maps = await _db.query(tablePlanWorkout);
    List<PlanModel> list = [];
    if (maps.isNotEmpty) {
      for (var model in maps) {
        list.add(PlanModel.fromJson(model));
      }
    }
    return list;
  }

  Future<int> deletePlan(int? id) async {
    return await _db
        .delete(tablePlanWorkout, where: '$customPlanId = ?', whereArgs: [id]);
  }

  Future<int> updatePlan(PlanModel planModel) async {
    return await _db.update(tablePlanWorkout, planModel.toJson(),
        where: '$customPlanId = ?', whereArgs: [planModel.id]);
  }

  Future<List<PlanModelStatic>> getStaticPlanModels() async {
    List<Map> maps = await _db.query(tableStaticPlanWorkout);
    List<PlanModelStatic> list = [];
    for(var item in maps){
      list.add(PlanModelStatic.fromMap(item));
    }
    return list;
  }

  Future<PlanModelStatic> insertStaticPlan(PlanModelStatic planModel) async {
    planModel.id = await _db.insert(tableStaticPlanWorkout, planModel.toMap());
    return planModel;
  }

  Future<int> updateReminder(ReminderWorkout reminderWorkout) async {
    return await _db.update(tableReminder, reminderWorkout.toMap(),
        where: '$reminderId = ?', whereArgs: [reminderWorkout.id]);
  }

  Future<int> deleteReminder(int id) async {
    return await _db
        .delete(tableReminder, where: '$reminderId = ?', whereArgs: [id]);
  }

  Future<List<ReminderWorkout>> getReminders() async {
    List<Map> maps = await _db.query(tableReminder);
    List<ReminderWorkout> list = [];
    for(var item in maps){
      list.add(ReminderWorkout.fromMap(item));
    }
    return list;
  }

  Future<ReminderWorkout> insertReminder(ReminderWorkout reminderWorkout) async {
    reminderWorkout.id = await _db.insert(tableReminder, reminderWorkout.toMap());
    return reminderWorkout;
  }

  Future<List<TrainingDone>> getTrainingDone(String date) async{
    final model = await _db
        .query(tableTrainingDone, where: '$trainingDoneDate = ?', whereArgs: [date]);
    List<TrainingDone> list = [];
    for (var value in model) {
      list.add(TrainingDone.fromMap(value));
    }
    return list;
  }

  Future<TrainingDone> insertTrainingDone(TrainingDone trainingDone) async {
    trainingDone.id = await _db.insert(tableTrainingDone, trainingDone.toMap());
    return trainingDone;
  }
}
