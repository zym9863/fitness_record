class FitnessData {
  final DateTime date;
  final int workoutMinutes;
  final int steps;
  final int calories;
  final int waterIntake;

  FitnessData({
    required this.date,
    required this.workoutMinutes,
    required this.steps,
    required this.calories,
    this.waterIntake = 0,
  });

  // 从JSON转换为对象
  factory FitnessData.fromJson(Map<String, dynamic> json) {
    return FitnessData(
      date: DateTime.parse(json['date']),
      workoutMinutes: json['workoutMinutes'],
      steps: json['steps'],
      calories: json['calories'],
      waterIntake: json['waterIntake'] ?? 0,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'workoutMinutes': workoutMinutes,
      'steps': steps,
      'calories': calories,
      'waterIntake': waterIntake,
    };
  }
}

class FitnessGoal {
  final int dailyWorkoutMinutes;
  final int dailySteps;
  final int dailyCalories;
  final int dailyWaterIntake;

  FitnessGoal({
    required this.dailyWorkoutMinutes,
    required this.dailySteps,
    required this.dailyCalories,
    required this.dailyWaterIntake,
  });

  // 从JSON转换为对象
  factory FitnessGoal.fromJson(Map<String, dynamic> json) {
    return FitnessGoal(
      dailyWorkoutMinutes: json['dailyWorkoutMinutes'],
      dailySteps: json['dailySteps'],
      dailyCalories: json['dailyCalories'],
      dailyWaterIntake: json['dailyWaterIntake'] ?? 2000,
    );
  }

  // 转换为JSON
  Map<String, dynamic> toJson() {
    return {
      'dailyWorkoutMinutes': dailyWorkoutMinutes,
      'dailySteps': dailySteps,
      'dailyCalories': dailyCalories,
      'dailyWaterIntake': dailyWaterIntake,
    };
  }

  // 默认目标
  factory FitnessGoal.defaultGoal() {
    return FitnessGoal(
      dailyWorkoutMinutes: 30,
      dailySteps: 10000,
      dailyCalories: 300,
      dailyWaterIntake: 2000,
    );
  }
}