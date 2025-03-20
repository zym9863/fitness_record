import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/fitness_provider.dart';
import '../models/fitness_data.dart';

class RecordScreen extends StatefulWidget {
  final DateTime? date;
  
  const RecordScreen({super.key, this.date});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  late DateTime _selectedDate;
  final _formKey = GlobalKey<FormState>();
  final _workoutMinutesController = TextEditingController();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  
  @override
  void initState() {
    super.initState();
    _selectedDate = widget.date ?? DateTime.now();
    
    // 如果是编辑现有记录，加载数据
    Future.microtask(() {
      final provider = Provider.of<FitnessProvider>(context, listen: false);
      final existingRecord = provider.getRecordForDate(_selectedDate);
      
      if (existingRecord != null) {
        _workoutMinutesController.text = existingRecord.workoutMinutes.toString();
        _stepsController.text = existingRecord.steps.toString();
        _caloriesController.text = existingRecord.calories.toString();
      }
    });
  }
  
  @override
  void dispose() {
    _workoutMinutesController.dispose();
    _stepsController.dispose();
    _caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.date == null ? '添加记录' : '编辑记录'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePicker(),
              const SizedBox(height: 20),
              _buildInputField(
                controller: _workoutMinutesController,
                label: '锻炼时间 (分钟)',
                icon: Icons.timer,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _stepsController,
                label: '步数',
                icon: Icons.directions_walk,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _caloriesController,
                label: '卡路里消耗 (千卡)',
                icon: Icons.local_fire_department,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _saveRecord,
                  child: const Text('保存记录'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '日期',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: () async {
            final pickedDate = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
            );
            
            if (pickedDate != null && pickedDate != _selectedDate) {
              setState(() {
                _selectedDate = pickedDate;
              });
              
              // 加载选定日期的记录
              final provider = Provider.of<FitnessProvider>(context, listen: false);
              final existingRecord = provider.getRecordForDate(_selectedDate);
              
              if (existingRecord != null) {
                _workoutMinutesController.text = existingRecord.workoutMinutes.toString();
                _stepsController.text = existingRecord.steps.toString();
                _caloriesController.text = existingRecord.calories.toString();
              } else {
                _workoutMinutesController.clear();
                _stepsController.clear();
                _caloriesController.clear();
              }
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('yyyy-MM-dd').format(_selectedDate),
                  style: const TextStyle(fontSize: 16),
                ),
                const Icon(Icons.calendar_today),
              ],
            ),
          ),
        ),
      ],
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

  void _saveRecord() {
    if (_formKey.currentState!.validate()) {
      final workoutMinutes = int.parse(_workoutMinutesController.text);
      final steps = int.parse(_stepsController.text);
      final calories = int.parse(_caloriesController.text);
      
      final record = FitnessData(
        date: _selectedDate,
        workoutMinutes: workoutMinutes,
        steps: steps,
        calories: calories,
      );
      
      Provider.of<FitnessProvider>(context, listen: false).addOrUpdateRecord(record);
      
      Navigator.pop(context);
    }
  }
}