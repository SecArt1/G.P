import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class ResultsDashboardPage extends StatefulWidget {
  const ResultsDashboardPage({Key? key}) : super(key: key);

  @override
  _ResultsDashboardPageState createState() => _ResultsDashboardPageState();
}

class _ResultsDashboardPageState extends State<ResultsDashboardPage>
    with SingleTickerProviderStateMixin {
  bool _isLoading = true;
  List<Map<String, dynamic>> _testResults = [];
  late TabController _tabController;
  String _selectedTimeFrame = 'All Time';
  String _selectedMetric = 'Weight';

  final Map<String, String> _metricUnits = {
    'Weight': 'kg',
    'Body Fat': '%',
    'Muscle Mass': 'kg',
    'BMI': '',
    'Visceral Fat': 'level',
    'Body Water': '%',
  };

  final Map<String, Color> _metricColors = {
    'Weight': const Color(0xFF0383C2),
    'Body Fat': const Color(0xFFE53935),
    'Muscle Mass': const Color(0xFF43A047),
    'BMI': const Color(0xFFFB8C00),
    'Visceral Fat': const Color(0xFF8E24AA),
    'Body Water': const Color(0xFF1E88E5),
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadTestResults();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadTestResults() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // Get the test results from Firestore
        final resultsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('test_results')
            .orderBy('date', descending: true)
            .get();

        final results = resultsSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            ...doc.data(),
            'date': (doc.data()['date'] as Timestamp).toDate(),
          };
        }).toList();

        // If there's no real data yet, create some sample data for demonstration
        if (results.isEmpty) {
          final now = DateTime.now();
          results.addAll([
            {
              'id': '1',
              'date': now.subtract(const Duration(days: 90)),
              'Weight': 85.5,
              'Body Fat': 24.2,
              'Muscle Mass': 32.4,
              'BMI': 26.4,
              'Visceral Fat': 10.0,
              'Body Water': 53.8,
            },
            {
              'id': '2',
              'date': now.subtract(const Duration(days: 60)),
              'Weight': 83.2,
              'Body Fat': 23.5,
              'Muscle Mass': 32.9,
              'BMI': 25.8,
              'Visceral Fat': 9.0,
              'Body Water': 54.3,
            },
            {
              'id': '3',
              'date': now.subtract(const Duration(days: 30)),
              'Weight': 81.6,
              'Body Fat': 22.1,
              'Muscle Mass': 33.5,
              'BMI': 25.3,
              'Visceral Fat': 8.0,
              'Body Water': 55.0,
            },
            {
              'id': '4',
              'date': now.subtract(const Duration(days: 7)),
              'Weight': 80.2,
              'Body Fat': 21.0,
              'Muscle Mass': 34.0,
              'BMI': 24.8,
              'Visceral Fat': 7.0,
              'Body Water': 55.5,
            },
          ]);
        }

        setState(() {
          _testResults = results;
          _isLoading = false;
        });
      } else {
        // Handle case where user is not signed in
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading test results: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> _getFilteredResults() {
    final now = DateTime.now();
    switch (_selectedTimeFrame) {
      case '1 Month':
        return _testResults
            .where((result) => (result['date'] as DateTime)
                .isAfter(now.subtract(const Duration(days: 30))))
            .toList();
      case '3 Months':
        return _testResults
            .where((result) => (result['date'] as DateTime)
                .isAfter(now.subtract(const Duration(days: 90))))
            .toList();
      case '6 Months':
        return _testResults
            .where((result) => (result['date'] as DateTime)
                .isAfter(now.subtract(const Duration(days: 180))))
            .toList();
      case '1 Year':
        return _testResults
            .where((result) => (result['date'] as DateTime)
                .isAfter(now.subtract(const Duration(days: 365))))
            .toList();
      case 'All Time':
      default:
        return _testResults;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: const Color(0xFF0383C2),
        elevation: 0,
        title: const Text(
          'Results Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadTestResults();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF0383C2)),
            )
          : _testResults.isEmpty
              ? _buildEmptyState()
              : Column(
                  children: [
                    // Header with curve
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 30,
                        bottom: 50,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0383C2),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Your Health Journey',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'View and analyze your progress over time',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildStat(
                                _testResults.length.toString(),
                                'Tests',
                                Icons.assignment_outlined,
                              ),
                              _buildStat(
                                _getLatestValue('Weight').toStringAsFixed(1),
                                'kg',
                                Icons.monitor_weight_outlined,
                              ),
                              _buildStat(
                                _getLatestValue('BMI').toStringAsFixed(1),
                                'BMI',
                                Icons.equalizer_outlined,
                              ),
                              _buildStat(
                                _calculateProgress(),
                                'Progress',
                                Icons.trending_up_outlined,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Tab bar
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: TabBar(
                        controller: _tabController,
                        indicatorColor: const Color(0xFF0383C2),
                        labelColor: const Color(0xFF0383C2),
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: 'Analytics'),
                          Tab(text: 'History'),
                        ],
                      ),
                    ),

                    // Tab content
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          // Analytics Tab
                          _buildAnalyticsTab(),

                          // History Tab
                          _buildHistoryTab(),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.analytics_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No Test Results Yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Complete your first test to see results',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.add),
            label: const Text('Take Your First Test'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0383C2),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Icon(
            icon,
            color: const Color(0xFF0383C2),
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildAnalyticsTab() {
    final filteredResults = _getFilteredResults();

    // Sort chronologically for charts
    filteredResults.sort(
        (a, b) => (a['date'] as DateTime).compareTo(b['date'] as DateTime));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time frame selection
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Time Frame:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                DropdownButton<String>(
                  value: _selectedTimeFrame,
                  underline: Container(),
                  items: [
                    '1 Month',
                    '3 Months',
                    '6 Months',
                    '1 Year',
                    'All Time'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          color: Color(0xFF0383C2),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedTimeFrame = newValue;
                      });
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Key Metrics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Key metrics cards
          GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: _metricUnits.keys.map((metric) {
              return _buildMetricCard(metric, filteredResults);
            }).toList(),
          ),

          const SizedBox(height: 24),
          Text(
            'Trend Analysis',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Metric selection
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Select Metric:',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    DropdownButton<String>(
                      value: _selectedMetric,
                      underline: Container(),
                      items: _metricUnits.keys
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(
                              color: _metricColors[value],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedMetric = newValue;
                          });
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Line chart
                SizedBox(
                  height: 250,
                  child: _buildLineChart(filteredResults),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),
          Text(
            'Body Composition',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),

          // Body composition pie chart
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Latest Body Composition',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  height: 250,
                  child: _buildPieChart(),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildLegendItem('Muscle', const Color(0xFF43A047)),
                    _buildLegendItem('Fat', const Color(0xFFE53935)),
                    _buildLegendItem('Water', const Color(0xFF1E88E5)),
                    _buildLegendItem('Other', const Color(0xFFFFA726)),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _testResults.length,
      itemBuilder: (context, index) {
        final result = _testResults[index];
        final date = result['date'] as DateTime;

        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: ExpansionTile(
              tilePadding: const EdgeInsets.all(16),
              childrenPadding: const EdgeInsets.all(16),
              title: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0383C2).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: Color(0xFF0383C2),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Test Result',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                        Text(
                          DateFormat('MMMM d, yyyy').format(date),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0383C2).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      DateFormat('h:mm a').format(date),
                      style: const TextStyle(
                        color: Color(0xFF0383C2),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                const Divider(),
                GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  crossAxisCount: 2,
                  childAspectRatio: 3.5,
                  children: _metricUnits.keys.map((metric) {
                    return _buildResultDetailItem(
                      metric,
                      result[metric] ?? 0.0,
                      _metricUnits[metric] ?? '',
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {
                        // Download or share functionality would go here
                      },
                      icon: const Icon(Icons.share, size: 18),
                      label: const Text('Share'),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF0383C2)),
                        foregroundColor: const Color(0xFF0383C2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        // View detailed report functionality
                      },
                      icon: const Icon(Icons.description, size: 18),
                      label: const Text('View Full Report'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0383C2),
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMetricCard(String metric, List<Map<String, dynamic>> results) {
    final currentValue = _getLatestValue(metric);
    final previousValue =
        results.length > 1 ? results[1][metric] ?? currentValue : currentValue;

    final diff = currentValue - previousValue;
    final isImprovement = _isImprovement(metric, diff);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                metric,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                _getMetricIcon(metric),
                color: _metricColors[metric],
                size: 18,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                currentValue.toStringAsFixed(1),
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                _metricUnits[metric] ?? '',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                diff == 0
                    ? Icons.remove
                    : isImprovement
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                color: diff == 0
                    ? Colors.grey
                    : isImprovement
                        ? Colors.green
                        : Colors.red,
                size: 18,
              ),
              Text(
                '${diff.abs().toStringAsFixed(1)} ${_metricUnits[metric]}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: diff == 0
                      ? Colors.grey
                      : isImprovement
                          ? Colors.green
                          : Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLineChart(List<Map<String, dynamic>> results) {
    if (results.isEmpty) return Container();

    // Prepare data for chart
    final List<ChartData> chartData = [];
    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      final value = result[_selectedMetric] as double? ?? 0.0;
      final date = result['date'] as DateTime;
      chartData.add(ChartData(date, value));
    }

    return SfCartesianChart(
      primaryXAxis: DateTimeAxis(
        dateFormat: DateFormat('MMM d'),
        intervalType: DateTimeIntervalType.auto,
        majorGridLines: const MajorGridLines(width: 0),
      ),
      primaryYAxis: NumericAxis(
        labelFormat: '{value}',
        axisLine: const AxisLine(width: 0),
        majorTickLines: const MajorTickLines(size: 0),
      ),
      tooltipBehavior: TooltipBehavior(enable: true),
      series: <ChartSeries<ChartData, DateTime>>[
        LineSeries<ChartData, DateTime>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.value,
          name: _selectedMetric,
          color: _metricColors[_selectedMetric],
          markerSettings: const MarkerSettings(isVisible: true),
          dataLabelSettings: const DataLabelSettings(isVisible: false),
        )
      ],
    );
  }

  Widget _buildPieChart() {
    // Get latest test result
    if (_testResults.isEmpty) return Container();
    final latestResult = _testResults.first;

    // Calculate body composition percentages - ensure all values are doubles
    final weight = (latestResult['Weight'] is int)
        ? (latestResult['Weight'] as int).toDouble()
        : latestResult['Weight'] as double? ?? 70.0;

    final bodyFatPct = (latestResult['Body Fat'] is int)
        ? (latestResult['Body Fat'] as int).toDouble()
        : latestResult['Body Fat'] as double? ?? 20.0;

    final waterPct = (latestResult['Body Water'] is int)
        ? (latestResult['Body Water'] as int).toDouble()
        : latestResult['Body Water'] as double? ?? 55.0;

    final bodyFatMass = weight * bodyFatPct / 100;
    final waterMass = weight * waterPct / 100;

    final muscleMass = (latestResult['Muscle Mass'] is int)
        ? (latestResult['Muscle Mass'] as int).toDouble()
        : latestResult['Muscle Mass'] as double? ?? 30.0;

    final otherMass = weight - bodyFatMass - waterMass - muscleMass;

    final data = [
      {
        'category': 'Muscle',
        'value': muscleMass,
        'color': const Color(0xFF43A047)
      },
      {
        'category': 'Fat',
        'value': bodyFatMass,
        'color': const Color(0xFFE53935)
      },
      {
        'category': 'Water',
        'value': waterMass,
        'color': const Color(0xFF1E88E5)
      },
      {
        'category': 'Other',
        'value': otherMass > 0 ? otherMass : 0,
        'color': const Color(0xFFFFA726)
      },
    ];

    return SfCircularChart(
      series: <CircularSeries>[
        PieSeries<Map<String, dynamic>, String>(
          dataSource: data,
          xValueMapper: (datum, _) => datum['category'] as String,
          yValueMapper: (datum, _) {
            // Safely convert to double regardless of int or double input
            final value = datum['value'];
            return value is int ? value.toDouble() : value as double;
          },
          pointColorMapper: (datum, _) => datum['color'] as Color,
          dataLabelMapper: (datum, _) {
            final value = datum['value'];
            final doubleValue =
                value is int ? value.toDouble() : value as double;
            return '${doubleValue.toStringAsFixed(1)}kg';
          },
          dataLabelSettings: const DataLabelSettings(
            isVisible: true,
            labelPosition: ChartDataLabelPosition.outside,
            textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ),
          explode: true,
          explodeIndex: 0,
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildResultDetailItem(String label, double value, String unit) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          _getMetricIcon(label),
          color: _metricColors[label],
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 12,
                ),
              ),
              Text(
                '$value $unit',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  IconData _getMetricIcon(String metric) {
    switch (metric) {
      case 'Weight':
        return Icons.monitor_weight_outlined;
      case 'Body Fat':
        return Icons.accessibility_new_outlined;
      case 'Muscle Mass':
        return Icons.fitness_center_outlined;
      case 'BMI':
        return Icons.straighten_outlined;
      case 'Visceral Fat':
        return Icons.layers_outlined;
      case 'Body Water':
        return Icons.water_drop_outlined;
      default:
        return Icons.analytics_outlined;
    }
  }

  double _getLatestValue(String metric) {
    if (_testResults.isEmpty) return 0.0;
    return _testResults.first[metric] as double? ?? 0.0;
  }

  bool _isImprovement(String metric, double diff) {
    // For these metrics, lower is better
    if (metric == 'Weight' ||
        metric == 'Body Fat' ||
        metric == 'BMI' ||
        metric == 'Visceral Fat') {
      return diff < 0;
    }
    // For these metrics, higher is better
    return diff > 0;
  }

  String _calculateProgress() {
    if (_testResults.length < 2) return '0%';

    // Calculate overall progress using key metrics
    final firstResult = _testResults.last;
    final latestResult = _testResults.first;

    double totalImprovement = 0;
    int metricCount = 0;

    for (final metric in ['Weight', 'Body Fat', 'Muscle Mass', 'BMI']) {
      if (firstResult.containsKey(metric) && latestResult.containsKey(metric)) {
        final first = firstResult[metric] as double? ?? 0.0;
        final latest = latestResult[metric] as double? ?? 0.0;

        if (first > 0) {
          final diff = latest - first;
          final percentChange = (diff / first) * 100;

          if (_isImprovement(metric, diff)) {
            totalImprovement += percentChange.abs();
          } else {
            totalImprovement -= percentChange.abs();
          }

          metricCount++;
        }
      }
    }

    if (metricCount == 0) return '0%';

    final averageImprovement = totalImprovement / metricCount;
    return '${averageImprovement.abs().toStringAsFixed(0)}%';
  }
}

class ChartData {
  ChartData(this.date, this.value);
  final DateTime date;
  final double value;
}
