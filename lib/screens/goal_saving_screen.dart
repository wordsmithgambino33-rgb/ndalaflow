import 'package:flutter/material.dart';
import 'dart:math';

class Goal {
  final String name;
  final int target;
  final int saved;
  final IconData icon;
  final Color color;
  final DateTime deadline;
  final int weeklyTarget;
  final String category;

  Goal({
    required this.name,
    required this.target,
    required this.saved,
    required this.icon,
    required this.color,
    required this.deadline,
    required this.weeklyTarget,
    required this.category,
  });
}

class GoalsSavingScreen extends StatefulWidget {
  const GoalsSavingScreen({Key? key}) : super(key: key);

  @override
  State<GoalsSavingScreen> createState() => _GoalsSavingScreenState();
}

class _GoalsSavingScreenState extends State<GoalsSavingScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;

  List<Goal> goals = [
    Goal(name: 'Emergency Fund', target: 1000000, saved: 285000, icon: Icons.track_changes, color: Colors.green, deadline: DateTime(2024, 12, 31), weeklyTarget: 25000, category: 'Safety'),
    Goal(name: 'School Fees Next Semester', target: 500000, saved: 150000, icon: Icons.school, color: Colors.blue, deadline: DateTime(2024, 11, 30), weeklyTarget: 15000, category: 'Education'),
    Goal(name: 'New Motorcycle', target: 800000, saved: 320000, icon: Icons.motorcycle, color: Colors.purple, deadline: DateTime(2025, 3, 15), weeklyTarget: 20000, category: 'Transport'),
    Goal(name: 'House Down Payment', target: 2000000, saved: 450000, icon: Icons.home, color: Colors.orange, deadline: DateTime(2025, 12, 31), weeklyTarget: 35000, category: 'Housing'),
    Goal(name: 'Holiday to Cape Town', target: 300000, saved: 180000, icon: Icons.flight, color: Colors.teal, deadline: DateTime(2024, 12, 15), weeklyTarget: 10000, category: 'Travel'),
  ];

  int get totalSaved => goals.fold(0, (sum, g) => sum + g.saved);
  int get totalTarget => goals.fold(0, (sum, g) => sum + g.target);

  int getWeeksRemaining(DateTime deadline) {
    final now = DateTime.now();
    final diff = deadline.difference(now).inDays;
    return (diff / 7).ceil().clamp(0, 1000);
  }

  void _showAddGoalModal() {
    nameController.clear();
    amountController.clear();
    selectedDate = null;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Text('Add Goal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Goal name', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              TextField(controller: amountController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Target amount', border: OutlineInputBorder())),
              const SizedBox(height: 8),
              Row(children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(context: ctx, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
                      if (picked != null) setState(() => selectedDate = picked);
                    },
                    child: Text(selectedDate == null ? 'Select deadline' : 'Deadline: ${selectedDate!.toLocal().toString().split(' ')[0]}'),
                  ),
                ),
              ]),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text.isEmpty || amountController.text.isEmpty || selectedDate == null) return;
                  final amount = int.tryParse(amountController.text.replaceAll(',', '')) ?? 0;
                  setState(() {
                    goals.add(Goal(
                      name: nameController.text,
                      target: amount,
                      saved: 0,
                      icon: Icons.track_changes,
                      color: Colors.blueGrey,
                      deadline: selectedDate!,
                      weeklyTarget: max(1, amount ~/ 10),
                      category: 'Custom',
                    ));
                  });
                  Navigator.of(ctx).pop();
                },
                style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                child: const Text('Add Goal'),
              ),
              const SizedBox(height: 12),
            ]),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Goals & Saving'),
        backgroundColor: Colors.blue,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalModal,
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: [
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Total Saved: MWK $totalSaved'),
                Text('Total Target: MWK $totalTarget'),
                const SizedBox(height: 8),
                LinearProgressIndicator(value: totalTarget == 0 ? 0 : totalSaved / totalTarget),
              ]),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: goals.length,
              itemBuilder: (ctx, i) {
                final g = goals[i];
                final percent = g.target == 0 ? 0.0 : g.saved / g.target;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    leading: CircleAvatar(backgroundColor: g.color, child: Icon(g.icon, color: Colors.white)),
                    title: Text(g.name),
                    subtitle: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text('MWK ${g.saved} / MWK ${g.target}'),
                      const SizedBox(height: 6),
                      LinearProgressIndicator(value: percent),
                      const SizedBox(height: 6),
                      Text('${getWeeksRemaining(g.deadline)} weeks remaining • ${g.category}', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                    ]),
                    trailing: IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
                  ),
                );
              },
            ),
          ),
        ]),
      ),
    );
  }
}

