import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/fitness_provider.dart';
import '../models/fitness_data.dart';

class GoalScreen extends StatefulWidget {
  const GoalScreen({super.key});

  @override
  State<GoalScreen> createState() => _GoalScreenState();
}

class _GoalScreenState extends State<GoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _workoutMinutesController = TextEditingController();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterIntakeController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    
    // 加载当前目标
    Future.microtask(() {
      final provider = Provider.of<FitnessProvider>(context, listen: false);
      final goal = provider.fitnessGoal;
      
      _workoutMinutesController.text = goal.dailyWorkoutMinutes.toString();
      _stepsController.text = goal.dailySteps.toString();
      _caloriesController.text = goal.dailyCalories.toString();
      _waterIntakeController.text = goal.dailyWaterIntake.toString();
    });
  }
  
  @override
  void dispose() {
    _workoutMinutesController.dispose();
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterIntakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置目标'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '设置每日健身目标',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _workoutMinutesController,
                label: '每日锻炼时间 (分钟)',
                icon: Icons.timer,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _stepsController,
                label: '每日步数',
                icon: Icons.directions_walk,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _caloriesController,
                label: '每日卡路里消耗 (千卡)',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _waterIntakeController,
                label: '每日饮水量 (毫升)',
                icon: Icons.local_drink,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveGoal,
                  child: const Text('保存目标'),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton(
                  onPressed: _resetToDefault,
                  child: const Text('重置为默认值'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required TextInputType keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: const OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '请输入$label';
        }
        if (int.tryParse(value) == null) {
          return '请输入有效的数字';
        }
        return null;
      },
    );
  }

  void _saveGoal() {
    if (_formKey.currentState!.validate()) {
      final workoutMinutes = int.parse(_workoutMinutesController.text);
      final steps = int.parse(_stepsController.text);
      final calories = int.parse(_caloriesController.text);
      final waterIntake = int.parse(_waterIntakeController.text);
      
      final goal = FitnessGoal(
        dailyWorkoutMinutes: workoutMinutes,
        dailySteps: steps,
        dailyCalories: calories,
        dailyWaterIntake: waterIntake,
      );
      
      Provider.of<FitnessProvider>(context, listen: false).updateGoal(goal);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('目标已保存')),
      );
      
      Navigator.pop(context);
    }
  }

  void _resetToDefault() {
    final defaultGoal = FitnessGoal.defaultGoal();
    
    setState(() {
      _workoutMinutesController.text = defaultGoal.dailyWorkoutMinutes.toString();
      _stepsController.text = defaultGoal.dailySteps.toString();
      _caloriesController.text = defaultGoal.dailyCalories.toString();
      _waterIntakeController.text = defaultGoal.dailyWaterIntake.toString();
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已重置为默认值')),
    );
  }
}