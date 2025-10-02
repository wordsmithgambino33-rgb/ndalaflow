
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

enum ChartType { pie, bar, trend }

class ReportsAnalyticsScreen extends StatefulWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  State<ReportsAnalyticsScreen> createState() => _ReportsAnalyticsScreenState();
}

class _ReportsAnalyticsScreenState extends State<ReportsAnalyticsScreen> {
  int currentMonth = 8; // September (0-indexed)
  ChartType selectedChart = ChartType.pie;

  final List<String> months = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];

  final List<Map<String, dynamic>> expenseData = [
    {"name": "Market & Groceries", "value": 68000.0, "color": Colors.red},
    {"name": "School Fees", "value": 75000.0, "color": Colors.blue},
    {"name": "Transport", "value": 17000.0, "color": Colors.orange},
    {"name": "Food & Drinks", "value": 19500.0, "color": Colors.yellow.shade700},
    {"name": "Rent & Bills", "value": 150000.0, "color": Colors.grey},
    {"name": "Health", "value": 25000.0, "color": Colors.green},
  ];

  final List<Map<String, dynamic>> monthlyData = [
    {"month": "May", "income": 450000.0, "expenses": 280000.0},
    {"month": "Jun", "income": 450000.0, "expenses": 320000.0},
    {"month": "Jul", "income": 480000.0, "expenses": 295000.0},
    {"month": "Aug", "income": 450000.0, "expenses": 354500.0},
    {"month": "Sep", "income": 450000.0, "expenses": 165000.0},
  ];

  final List<Map<String, dynamic>> trendData = [
    {"day": 1, "amount": 15000.0},
    {"day": 5, "amount": 8000.0},
    {"day": 8, "amount": 25000.0},
    {"day": 12, "amount": 5000.0},
    {"day": 15, "amount": 75000.0},
    {"day": 18, "amount": 12000.0},
    {"day": 22, "amount": 18000.0},
    {"day": 25, "amount": 30000.0},
    {"day": 28, "amount": 7000.0},
  ];

  double get totalExpenses => expenseData.fold(0, (sum, e) => sum + e['value']);
  double get totalIncome => 450000.0;
  double get savings => totalIncome - totalExpenses;
  double get savingsRate => (savings / totalIncome) * 100;

  void navigateMonth(bool forward) {
    setState(() {
      if (forward && currentMonth < 11) currentMonth++;
      if (!forward && currentMonth > 0) currentMonth--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.blue]),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Column(
                    children: [
                      Text(
                        '${months[currentMonth]} 2024',
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      const Text(
                        'Financial Overview',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      )
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.download, color: Colors.white),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Summary Cards
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _summaryCard('Income', totalIncome, Colors.green, Icons.trending_up),
                        _summaryCard('Expenses', totalExpenses, Colors.red, Icons.trending_down),
                        _summaryCard('Savings', savings, Colors.teal, Icons.savings),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Savings Rate
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Savings Rate'),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: savingsRate >= 20 ? Colors.green : Colors.red,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text('${savingsRate.toStringAsFixed(1)}%',
                                      style: const TextStyle(color: Colors.white)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            LinearProgressIndicator(
                              value: savingsRate / 100,
                              color: savingsRate >= 20 ? Colors.green : Colors.red,
                              backgroundColor: Colors.grey.shade300,
                              minHeight: 8,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              savingsRate >= 20
                                  ? "Great! You're on track with your savings goal."
                                  : "Consider reducing expenses to improve your savings rate.",
                              style: const TextStyle(fontSize: 12),
                            )
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Chart Type Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _chartTypeButton('Categories', ChartType.pie),
                        _chartTypeButton('Trends', ChartType.bar),
                        _chartTypeButton('Daily', ChartType.trend),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Chart
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: 250,
                          child: _renderChart(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Category Breakdown
                    if (selectedChart == ChartType.pie)
                      Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Category Breakdown', style: TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              Column(
                                children: expenseData.map((e) {
                                  double percentage = (e['value'] / totalExpenses) * 100;
                                  return Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 12,
                                            height: 12,
                                            decoration: BoxDecoration(
                                              color: e['color'],
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(e['name']),
                                        ],
                                      ),
                                      Text('${e['value'].toInt()} MWK (${percentage.toStringAsFixed(1)}%)')
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Financial Insights
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      color: Colors.teal.shade50,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Financial Insights', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
                            const SizedBox(height: 8),
                            const Text('Your biggest expense category is Rent & Bills at 45% of total spending.\nConsider reviewing utility bills for potential savings.'),
                            const SizedBox(height: 8),
                            Text("You're saving ${savingsRate.toStringAsFixed(1)}% of your income this month. Aim for 20-30% savings rate for financial security."),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard(String title, double value, Color color, IconData icon) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 4),
              Text('${value.toInt()} MWK', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chartTypeButton(String label, ChartType type) {
    bool isSelected = selectedChart == type;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedChart = type;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected ? [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)] : [],
          ),
          child: Center(child: Text(label, style: TextStyle(color: isSelected ? Colors.teal : Colors.grey.shade700))),
        ),
      ),
    );
  }

  Widget _renderChart() {
    switch (selectedChart) {
      case ChartType.pie:
        return PieChart(
          PieChartData(
            sections: expenseData
                .map((e) => PieChartSectionData(
                      value: e['value'],
                      color: e['color'],
                      title: '',
                      radius: 50,
                    ))
                .toList(),
          ),
        );

      case ChartType.bar:
        return BarChart(
          BarChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: true),
            barGroups: monthlyData
                .asMap()
                .entries
                .map(
                  (e) => BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(toY: e.value['income'], color: Colors.teal),
                    BarChartRodData(toY: e.value['expenses'], color: Colors.red),
                  ]),
                )
                .toList(),
          ),
        );

      case ChartType.trend:
        return LineChart(
          LineChartData(
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(show: true),
            lineBarsData: [
              LineChartBarData(
                spots: trendData.map((e) => FlSpot(e['day'].toDouble(), e['amount'])).toList(),
                isCurved: true,
                color: Colors.blue,
                dotData: FlDotData(show: true),
              ),
            ],
          ),
        );

      default:
        return Container();
    }
  }
}
