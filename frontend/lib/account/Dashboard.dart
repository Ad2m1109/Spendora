import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import '../services/transaction_service.dart'; // Import the service

void main() {
  runApp(FinanceApp());
}

class FinanceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finance Dashboard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
        brightness: Brightness.light,
      ),
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<String, dynamic> metrics = {};
  bool isLoading = true;
  Uint8List? chartImage; // Unified variable for the currently loaded chart
  bool showExpenseChart = true; // Toggle between expense and income charts
  Uint8List? dailyNetSavingsChart;

  @override
  void initState() {
    super.initState();
    _fetchMetrics();
    _fetchDailyNetSavingsChart(); // Fetch daily net savings chart
    _loadExpenseChart(); // Load expense chart by default
  }

  Future<void> _fetchMetrics() async {
    try {
      final userId = 14; // Replace with the actual numeric userId
      final token = "token"; // Replace with the actual token
      final data = await TransactionService.getDashboardMetrics(
          userId.toString(), token);
      setState(() {
        metrics = {
          'totalIncome': data['totalIncome'] ?? 0.0,
          'totalExpenses': data['totalExpenses'] ?? 0.0,
          'netSavings': data['netSavings'] ?? 0.0,
        };
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching metrics: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchDailyNetSavingsChart() async {
    try {
      final userId = 14; // Replace with the actual numeric userId
      final token = "token"; // Replace with the actual token
      final chart = await TransactionService.getDailyNetSavingsChart(
          userId.toString(), token);
      setState(() {
        dailyNetSavingsChart = chart;
      });
    } catch (e) {
      print("Error fetching daily net savings chart: $e");
    }
  }

  Future<void> _loadExpenseChart() async {
    try {
      final userId = 14; // Replace with the actual numeric userId
      final token = "token"; // Replace with the actual token
      final response = await http.post(
        Uri.parse(
            '${TransactionService.baseUrl}/transactions/expense-categories-chart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          chartImage = response.bodyBytes; // Load expense chart
        });
      } else {
        print("Error fetching expense chart: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching expense chart: $e");
    }
  }

  Future<void> _loadIncomeChart() async {
    try {
      final userId = 14; // Replace with the actual numeric userId
      final token = "token"; // Replace with the actual token
      final response = await http.post(
        Uri.parse(
            '${TransactionService.baseUrl}/transactions/income-categories-chart'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'userId': userId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          chartImage = response.bodyBytes; // Load income chart
        });
      } else {
        print("Error fetching income chart: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching income chart: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text('Finance Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Overview',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildMetricCard(
                          'Total Income',
                          '\$${metrics['totalIncome'] ?? '0.00'}',
                          Icons.arrow_upward,
                          Colors.green,
                        ),
                        SizedBox(
                            width:
                                4.0), // Reduced from 16.0 to 4.0 to move "Total Expenses" left
                        _buildMetricCard(
                          'Total Expenses',
                          '\$${metrics['totalExpenses'] ?? '0.00'}',
                          Icons.arrow_downward,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  _buildMetricCard(
                    'Net Savings',
                    '\$${metrics['netSavings'] ?? '0.00'}',
                    Icons.savings,
                    Colors.blue,
                    fullWidth: true,
                  ),
                  SizedBox(height: 24.0),
                  // Monthly Chart Placeholder
                  Text(
                    'Everyday Overview', // Updated title
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 400, // Adjusted height for the chart
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: dailyNetSavingsChart == null
                          ? CircularProgressIndicator() // Show loading indicator while chart is being fetched
                          : Image.memory(
                              dailyNetSavingsChart!), // Display the chart
                    ),
                  ),
                  SizedBox(height: 24.0),
                  // Expense Categories
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16.0),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (!showExpenseChart) {
                              setState(() {
                                showExpenseChart = true;
                                chartImage = null; // Clear current chart
                              });
                              _loadExpenseChart(); // Load expense chart
                            }
                          },
                          child: Text('Expense Categories'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                showExpenseChart ? Colors.blue : Colors.grey,
                          ),
                        ),
                        SizedBox(width: 16.0), // Proper spacing between buttons
                        Transform.translate(
                          offset:
                              Offset(-5.9, 0), // Move 5.9 pixels to the left
                          child: ElevatedButton(
                            onPressed: () {
                              if (showExpenseChart) {
                                setState(() {
                                  showExpenseChart = false;
                                  chartImage = null; // Clear current chart
                                });
                                _loadIncomeChart(); // Load income chart
                              }
                            },
                            child: Text('Income Categories'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  !showExpenseChart ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    height: 400, // Increased the height of the box
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10.0,
                          spreadRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Center(
                      child: chartImage == null
                          ? CircularProgressIndicator() // Show loading indicator while chart is being fetched
                          : _buildPieChart(chartImage),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: null,
    );
  }

  Widget _buildMetricCard(
      String title, String amount, IconData icon, Color color,
      {bool fullWidth = false}) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.0,
            spreadRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 20),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Text(
            amount,
            style: TextStyle(
              fontSize: fullWidth ? 28 : 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.0),
          Text(
            'Tap for details',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    return CustomPaint(
      size: Size(double.infinity, 200),
      painter: BarChartPainter(),
    );
  }

  Widget _buildPieChart(Uint8List? chartImage) {
    if (chartImage == null) {
      return Text(
        'No data available',
        style: TextStyle(color: Colors.grey),
      ); // Fallback if no image is available
    }
    return FittedBox(
      fit: BoxFit.contain,
      child: Image.memory(chartImage),
    );
  }
}

// Simple bar chart painter (design only)
class BarChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint incomeBarPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.fill;

    final Paint expenseBarPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final Paint gridPaint = Paint()
      ..color = Colors.grey.withOpacity(0.2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    // Draw grid lines
    for (int i = 0; i < 5; i++) {
      double y = size.height - (i * size.height / 4);
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y),
        gridPaint,
      );
    }

    // Month labels
    // ignore: unused_local_variable
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
    final monthWidth = size.width / 5;

    // Draw bars for each month
    for (int i = 0; i < 5; i++) {
      double x = i * monthWidth + monthWidth * 0.2;
      double barWidth = monthWidth * 0.3;

      // Income bar
      double incomeHeight = (70 + i * 5) * size.height / 100;
      canvas.drawRect(
        Rect.fromLTRB(x, size.height - incomeHeight, x + barWidth, size.height),
        incomeBarPaint,
      );

      // Expense bar
      double expenseHeight = (40 + i * 3) * size.height / 100;
      canvas.drawRect(
        Rect.fromLTRB(x + barWidth + 5, size.height - expenseHeight,
            x + barWidth * 2 + 5, size.height),
        expenseBarPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

// Simple pie chart painter (design only)
class PieChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()..style = PaintingStyle.fill;

    final center = Offset(size.width / 2, size.height / 2);
    final radius =
        size.width < size.height ? size.width / 2.5 : size.height / 2.5;

    // Category colors
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.green,
      Colors.amber,
      Colors.purple,
    ];

    // Draw pie segments
    double startAngle = 0;
    final percentages = [0.35, 0.25, 0.20, 0.12, 0.08]; // Dummy data

    for (int i = 0; i < percentages.length; i++) {
      paint.color = colors[i];
      final sweepAngle = percentages[i] * 2 * 3.14159;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center white circle for donut effect
    paint.color = Colors.white;
    canvas.drawCircle(center, radius * 0.5, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
