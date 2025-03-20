import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/fitness_data.dart';

class FitnessProvider with ChangeNotifier {
  List<FitnessData> _fitnessRecords = [];
  FitnessGoal _fitnessGoal = FitnessGoal.defaultGoal();
  
  List<FitnessData> get fitnessRecords => _fitnessRecords;
  FitnessGoal get fitnessGoal => _fitnessGoal;
  
  // 加载数据
  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 加载健身记录
    final recordsJson = prefs.getStringList('fitness_records') ?? [];
    _fitnessRecords = recordsJson
        .map((json) => FitnessData.fromJson(jsonDecode(json)))
        .toList();
    
    // 按日期排序（最新的在前面）
    _fitnessRecords.sort((a, b) => b.date.compareTo(a.date));
    
    // 加载目标
    final goalJson = prefs.getString('fitness_goal');
    if (goalJson != null) {
      _fitnessGoal = FitnessGoal.fromJson(jsonDecode(goalJson));
    }
    
    notifyListeners();
  }
  
  // 保存数据
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // 保存健身记录
    final recordsJson = _fitnessRecords
        .map((record) => jsonEncode(record.toJson()))
        .toList();
    await prefs.setStringList('fitness_records', recordsJson);
    
    // 保存目标
    await prefs.setString('fitness_goal', jsonEncode(_fitnessGoal.toJson()));
  }
  
  // 添加或更新记录
  Future<void> addOrUpdateRecord(FitnessData record) async {
    // 检查是否已存在该日期的记录
    final index = _fitnessRecords.indexWhere((r) => isSameDay(r.date, record.date));
    
    if (index != -1) {
      // 更新现有记录
      _fitnessRecords[index] = record;
    } else {
      // 添加新记录
      _fitnessRecords.add(record);
      // 按日期排序（最新的在前面）
      _fitnessRecords.sort((a, b) => b.date.compareTo(a.date));
    }
    
    notifyListeners();
    await _saveData();
  }
  
  // 更新目标
  Future<void> updateGoal(FitnessGoal goal) async {
    _fitnessGoal = goal;
    notifyListeners();
    await _saveData();
  }
  
  // 获取特定日期的记录
  FitnessData? getRecordForDate(DateTime date) {
    try {
      return _fitnessRecords.firstWhere(
        (record) => isSameDay(record.date, date),
      );
    } catch (e) {
      return null;
    }
  }
  
  // 获取本周记录
  List<FitnessData> getWeeklyRecords() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    startOfWeek.subtract(const Duration(hours: 23, minutes: 59, seconds: 59));
    
    return _fitnessRecords.where((record) {
      return record.date.isAfter(startOfWeek) || isSameDay(record.date, startOfWeek);
    }).toList();
  }
  
  // 判断两个日期是否为同一天
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}