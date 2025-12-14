import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/fitness_provider.dart';
import '../models/fitness_data.dart';
import '../theme/app_theme.dart';
import 'record_screen.dart';
import 'goal_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // 加载数据
    Future.microtask(() => 
      Provider.of<FitnessProvider>(context, listen: false).loadData()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('健身记录器'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GoalScreen()),
              );
            },
          ),
        ],
      ),
      body: Consumer<FitnessProvider>(
        builder: (context, provider, child) {
          final todayRecord = provider.getRecordForDate(DateTime.now());
          final goal = provider.fitnessGoal;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTodayCard(todayRecord, goal),
                const SizedBox(height: 20),
                const Text(
                  '本周进度',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildWeeklyChart(provider),
                const SizedBox(height: 20),
                const Text(
                  '最近记录',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                _buildRecentRecords(provider),
              ],
            ),
          );
        },
      ),
      floatingActionButton: Container(
        decoration: BoxDecoration(
          boxShadow: AppTheme.buttonShadow,
          shape: BoxShape.circle,
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const RecordScreen()),
            );
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppTheme.primaryGradient,
            ),
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );  
  }

  Widget _buildTodayCard(FitnessData? todayRecord, FitnessGoal goal) {
    final workoutMinutes = todayRecord?.workoutMinutes ?? 0;
    final steps = todayRecord?.steps ?? 0;
    final calories = todayRecord?.calories ?? 0;
    final waterIntake = todayRecord?.waterIntake ?? 0;
    
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          boxShadow: AppTheme.cardShadow,
        ),
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '今日进度',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildProgressItem(
              icon: Icons.timer,
              title: '锻炼时间',
              value: '$workoutMinutes 分钟',
              progress: workoutMinutes / goal.dailyWorkoutMinutes,
              color: Colors.blue,
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.directions_walk,
              title: '步数',
              value: '$steps 步',
              progress: steps / goal.dailySteps,
              color: Colors.green,
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.local_fire_department,
              title: '卡路里',
              value: '$calories 千卡',
              progress: calories / goal.dailyCalories,
              color: Colors.orange,
            ),
            const SizedBox(height: 15),
            _buildProgressItem(
              icon: Icons.local_drink,
              title: '饮水',
              value: '$waterIntake ml',
              progress: waterIntake / goal.dailyWaterIntake,
              color: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressItem({
    required IconData icon,
    required String title,
    required String value,
    required double progress,
    required Color color,
  }) {
    LinearGradient gradient;
    
    if (title.contains('锻炼时间')) {
      gradient = AppTheme.primaryGradient;
    } else if (title.contains('步数')) {
      gradient = AppTheme.activityGradient;
    } else {
      gradient = AppTheme.energyGradient;
    }
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              title, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)
            ),
            const Spacer(),
            Text(
              value, 
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            // 背景
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            // 进度
            AnimatedContainer(
              duration: AppTheme.animationDuration,
              height: 10,
              width: MediaQuery.of(context).size.width * 0.8 * progress.clamp(0.0, 1.0),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(FitnessProvider provider) {
    final weeklyRecords = provider.getWeeklyRecords();
    final goal = provider.fitnessGoal;
    
    // 确保有7天的数据
    final now = DateTime.now();
    final completeData = List.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final record = weeklyRecords.firstWhere(
        (r) => provider.isSameDay(r.date, date),
        orElse: () => FitnessData(
          date: date,
          workoutMinutes: 0,
          steps: 0,
          calories: 0,
        ),
      );
      return record;
    });
    
    return Container(
      height: 220,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: AppTheme.cardShadow,
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: goal.dailyWorkoutMinutes / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey[200]!,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  final weekday = ['一', '二', '三', '四', '五', '六', '日'];
                  final index = value.toInt();
                  if (index >= 0 && index < 7) {
                    final date = completeData[index].date;
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        weekday[date.weekday - 1],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    );
                  }
                  return const Text('');
                },
                reservedSize: 30,
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: goal.dailyWorkoutMinutes.toDouble() * 1.2,
          lineBarsData: [
            LineChartBarData(
              spots: List.generate(completeData.length, (index) {
                return FlSpot(
                  index.toDouble(),
                  completeData[index].workoutMinutes.toDouble(),
                );
              }),
              isCurved: true,
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF4A78FA),
                  Color(0xFF5CE1E6),
                ],
              ),
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(
                show: true,
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 3,
                    strokeColor: const Color(0xFF4A78FA),
                  );
                },
              ),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4A78FA).withOpacity(0.3),
                    const Color(0xFF5CE1E6).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentRecords(FitnessProvider provider) {
    final records = provider.fitnessRecords.take(5).toList();
    
    if (records.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('暂无记录，点击右下角按钮添加'),
        ),
      );
    }
    
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: records.length,
      itemBuilder: (context, index) {
        final record = records[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(DateFormat('yyyy-MM-dd').format(record.date)),
            subtitle: Text(
              '锻炼: ${record.workoutMinutes}分钟 | 步数: ${record.steps} | 卡路里: ${record.calories}千卡'
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordScreen(date: record.date),
                ),
              );
            },
          ),
        );
      },
    );
  }
}