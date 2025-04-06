import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class GoalsPage extends StatefulWidget {
  const GoalsPage({Key? key}) : super(key: key);

  @override
  _GoalsPageState createState() => _GoalsPageState();
}

class _GoalsPageState extends State<GoalsPage> {
  final List<Map<String, dynamic>> _goalTypes = [
    {
      'title': 'Weight',
      'icon': Icons.monitor_weight,
      'description': 'Target a specific weight',
      'unit': 'kg',
      'color': const Color(0xFF0383C2),
    },
    {
      'title': 'Body Fat',
      'icon': Icons.percent,
      'description': 'Lower your body fat percentage',
      'unit': '%',
      'color': const Color(0xFF43A047),
    },
    {
      'title': 'Muscle Mass',
      'icon': Icons.fitness_center,
      'description': 'Build muscle mass',
      'unit': 'kg',
      'color': const Color(0xFFF57C00),
    },
    {
      'title': 'Water Content',
      'icon': Icons.water_drop,
      'description': 'Maintain healthy body water levels',
      'unit': '%',
      'color': const Color(0xFF1976D2),
    },
    {
      'title': 'BMI',
      'icon': Icons.score,
      'description': 'Reach healthy Body Mass Index',
      'unit': '',
      'color': const Color(0xFF9C27B0),
    },
    {
      'title': 'Visceral Fat',
      'icon': Icons.add_circle_outline,
      'description': 'Reduce visceral fat level',
      'unit': 'level',
      'color': const Color(0xFFE53935),
    },
  ];

  final _currentGoals = <Map<String, dynamic>>[];
  final _formKey = GlobalKey<FormState>();
  final _targetController = TextEditingController();
  final _deadlineController = TextEditingController();
  bool _isLoading = true;
  String? _selectedGoalType;
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  @override
  void dispose() {
    _targetController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _loadGoals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final goalsSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('goals')
            .orderBy('createdAt', descending: true)
            .get();

        final goals = goalsSnapshot.docs
            .map((doc) => {
                  'id': doc.id,
                  ...doc.data(),
                  'deadline': (doc.data()['deadline'] as Timestamp).toDate(),
                  'createdAt': (doc.data()['createdAt'] as Timestamp).toDate(),
                })
            .toList();

        setState(() {
          _currentGoals.clear();
          _currentGoals.addAll(goals);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading goals: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 2)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF0383C2),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showAddGoalDialog() {
    _selectedGoalType = null;
    _targetController.clear();
    _deadlineController.clear();
    _selectedDate = null;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Set New Goal'),
              content: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Goal Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Goal Type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        value: _selectedGoalType,
                        items: _goalTypes.map((goal) {
                          return DropdownMenuItem<String>(
                            value: goal['title'],
                            child: Row(
                              children: [
                                Icon(goal['icon'], color: goal['color']),
                                const SizedBox(width: 10),
                                Text(goal['title']),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedGoalType = value;
                          });
                        },
                        validator: (value) =>
                            value == null ? 'Please select a goal type' : null,
                      ),
                      const SizedBox(height: 16),

                      // Target Value
                      TextFormField(
                        controller: _targetController,
                        decoration: InputDecoration(
                          labelText: 'Target Value',
                          hintText: 'e.g. 70',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixText: _selectedGoalType != null
                              ? _goalTypes.firstWhere((g) =>
                                  g['title'] == _selectedGoalType)['unit']
                              : '',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a target value';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Please enter a valid number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Deadline Date
                      TextFormField(
                        controller: _deadlineController,
                        decoration: InputDecoration(
                          labelText: 'Target Date',
                          hintText: 'Select a target date',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          suffixIcon: const Icon(Icons.calendar_today),
                        ),
                        readOnly: true,
                        onTap: () => _selectDate(context),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a target date';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0383C2),
                  ),
                  onPressed: _saveGoal,
                  child: const Text('Save Goal',style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveGoal() async {
    if (_formKey.currentState!.validate()) {
      Navigator.of(context).pop();

      setState(() {
        _isLoading = true;
      });

      try {
        final user = FirebaseAuth.instance.currentUser;
        if (user != null &&
            _selectedGoalType != null &&
            _selectedDate != null) {
          final goalData = {
            'type': _selectedGoalType,
            'target': double.parse(_targetController.text),
            'current': 0.0, // Initial value
            'deadline': Timestamp.fromDate(_selectedDate!),
            'createdAt': Timestamp.fromDate(DateTime.now()),
            'completed': false,
            'progress': 0.0,
          };

          // Find the icon and unit for this goal type
          final goalType =
              _goalTypes.firstWhere((g) => g['title'] == _selectedGoalType);
          goalData['unit'] = goalType['unit'];

          // Save to Firestore
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .collection('goals')
              .add(goalData);

          // Refresh goals
          _loadGoals();
        }
      } catch (e) {
        print('Error saving goal: $e');
        setState(() {
          _isLoading = false;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving goal: ${e.toString()}')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0383C2),
        elevation: 0,
        title: const Text(
          'Health Goals',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          // Header with curved background
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: Color(0xFF0383C2),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Track Your Progress',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Set measurable goals based on your InBody results',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Goals List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF0383C2),
                    ),
                  )
                : _currentGoals.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.flag,
                              size: 80,
                              color: Colors.grey,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'No goals set yet',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Add your first health goal',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _showAddGoalDialog,
                              icon: const Icon(Icons.add),
                              label: const Text('Add Goal'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF0383C2),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _currentGoals.length,
                        itemBuilder: (context, index) {
                          final goal = _currentGoals[index];
                          final goalType = _goalTypes.firstWhere(
                            (g) => g['title'] == goal['type'],
                            orElse: () => _goalTypes.first,
                          );
                          final progress = (goal['progress'] as double) * 100;

                          // Calculate days remaining
                          final deadline = goal['deadline'] as DateTime;
                          final daysRemaining =
                              deadline.difference(DateTime.now()).inDays;

                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Goal header with icon
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: (goalType['color'] as Color)
                                              .withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          goalType['icon'] as IconData,
                                          color: goalType['color'] as Color,
                                          size: 24,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        goal['type'] as String,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        '${goal['target']}${goal['unit']}',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0383C2),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Progress bar
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: goal['progress'] as double,
                                      backgroundColor: Colors.grey[200],
                                      color: goalType['color'] as Color,
                                      minHeight: 10,
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Progress percentage and days remaining
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${progress.toInt()}% Complete',
                                        style: TextStyle(
                                          color: goalType['color'] as Color,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        daysRemaining > 0
                                            ? '$daysRemaining days left'
                                            : 'Goal expired',
                                        style: TextStyle(
                                          color: daysRemaining > 0
                                              ? Colors.grey[600]
                                              : Colors.red,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  // Target date
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_today,
                                        size: 16,
                                        color: Colors.grey,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Target: ${DateFormat('MMM d, yyyy').format(goal['deadline'] as DateTime)}',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddGoalDialog,
        backgroundColor: const Color(0xFF0383C2),
        child: const Icon(Icons.add),
      ),
    );
  }
}
