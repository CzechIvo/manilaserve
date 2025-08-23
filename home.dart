
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1; // Start with Departments tab
  PageController _pageController = PageController(initialPage: 1);

  // Maps related state
  final TextEditingController _searchController = TextEditingController();
  bool _showOfficeInfo = false;
  bool _showNavigation = false;
  String _selectedOffice = 'Office of the Mayor';
  FocusNode _searchFocus = FocusNode();

  // User todo/reminders data
  List<Map<String, dynamic>> userReminders = [
    {
      'title': 'Business Permit Renewal Due',
      'description': 'Annual business permit expires March 31, 2024',
      'status': 'Pending',
      'priority': 'High',
      'dueDate': 'Due: March 15, 2024',
      'category': 'Business',
      'reminderTasks': [
        {'task': 'Gather required documents', 'completed': true},
        {'task': 'Visit City Hall for renewal', 'completed': false},
        {'task': 'Pay renewal fees', 'completed': false},
        {'task': 'Submit to business office', 'completed': false},
      ],
    },
    {
      'title': 'Document Request Reminder',
      'description': 'Need marriage certificate copy for visa application',
      'status': 'In Progress',
      'priority': 'Medium',
      'dueDate': 'Need by: March 20, 2024',
      'category': 'Documents',
      'reminderTasks': [
        {'task': 'Check requirements online', 'completed': true},
        {'task': 'Prepare valid IDs', 'completed': true},
        {'task': 'Go to Civil Registry office', 'completed': false},
        {'task': 'Process request form', 'completed': false},
      ],
    },
    {
      'title': 'Barangay Clearance Obtained',
      'description': 'Successfully obtained clearance for employment',
      'status': 'Completed',
      'priority': 'Low',
      'dueDate': 'Completed: March 5, 2024',
      'category': 'Clearance',
      'reminderTasks': [
        {'task': 'Visit barangay hall', 'completed': true},
        {'task': 'Submit requirements', 'completed': true},
        {'task': 'Meet with barangay captain', 'completed': true},
        {'task': 'Receive clearance', 'completed': true},
      ],
    },
    {
      'title': 'Building Plan Consultation',
      'description': 'Need to consult about home extension requirements',
      'status': 'Todo',
      'priority': 'Medium',
      'dueDate': 'Plan by: April 1, 2024',
      'category': 'Construction',
      'reminderTasks': [
        {'task': 'Research building requirements', 'completed': true},
        {'task': 'Consult with architect', 'completed': false},
        {'task': 'Visit engineering office', 'completed': false},
        {'task': 'Get initial assessment', 'completed': false},
      ],
    },
    {
      'title': 'Health Card Renewal',
      'description': 'Annual health card expires next month',
      'status': 'Upcoming',
      'priority': 'Medium',
      'dueDate': 'Expires: April 15, 2024',
      'category': 'Health',
      'reminderTasks': [
        {'task': 'Schedule medical checkup', 'completed': false},
        {'task': 'Prepare medical requirements', 'completed': false},
        {'task': 'Visit health center', 'completed': false},
        {'task': 'Update health records', 'completed': false},
      ],
    },
  ];

  // Department directory data with heads
  final Map<String, Map<String, String>> departmentHeads = {
    'Office of the Mayor': {
      'head': 'Hon. Francisco "Isko Moreno" Domagoso',
      'designation': 'City Mayor',
      'contact': '(02) 527-4040',
      'room': 'Mayor\'s Office, 2nd Floor',
    },
    'Office of the Chief of Staff': {
      'head': 'Atty. Caesar Poblador',
      'designation': 'Chief of Staff',
      'contact': '(02) 527-4041',
      'room': 'Room 201, 2nd Floor',
    },
    'Office of the Secretary to the Mayor': {
      'head': 'Ms. Maria Santos',
      'designation': 'Secretary to the Mayor',
      'contact': '(02) 527-4042',
      'room': 'Room 202, 2nd Floor',
    },
    'Manila Public Information Office': {
      'head': 'Mr. Julius Leonen',
      'designation': 'Public Information Officer',
      'contact': '(02) 527-4043',
      'room': 'Room 105, 1st Floor',
    },
    'Electronic Data Processing Services': {
      'head': 'Engr. Roberto Cruz',
      'designation': 'IT Director',
      'contact': '(02) 527-4044',
      'room': 'Room 301, 3rd Floor',
    },
    'Manila Sports Council': {
      'head': 'Mr. Bernie Fernandez',
      'designation': 'Sports Director',
      'contact': '(02) 527-4045',
      'room': 'Room 110, 1st Floor',
    },
    'Office of the Seniors Citizen Affairs': {
      'head': 'Ms. Luz Mercado',
      'designation': 'Senior Citizens Affairs Officer',
      'contact': '(02) 527-4046',
      'room': 'Room 115, 1st Floor',
    },
    'People\'s Law Enforcement Board': {
      'head': 'Atty. Ricardo Hernandez',
      'designation': 'PLEB Chairman',
      'contact': '(02) 527-4047',
      'room': 'Room 205, 2nd Floor',
    },
    'Public Employment Services Office (PESO)': {
      'head': 'Ms. Carmen Reyes',
      'designation': 'PESO Manager',
      'contact': '(02) 527-4048',
      'room': 'Room 120, 1st Floor',
    },
  };

  final List<Map<String, dynamic>> departments = [
    {
      'title': 'Departments Under the Office of the Mayor',
      'items': [
        'Office of the Mayor',
        'Office of the Chief of Staff',
        'Office of the Secretary to the Mayor',
        'Manila Public Information Office',
        'Electronic Data Processing Services',
        'Manila Sports Council',
        'Office of the Seniors Citizen Affairs',
        'People\'s Law Enforcement Board',
        'Public Employment Services Office (PESO)',
      ],
      'expanded': true,
    },
    {
      'title': 'Departments under the Office of the Vice Mayor',
      'items': [],
      'expanded': false,
    },
    {
      'title': 'Departments under the City Council',
      'items': [],
      'expanded': false,
    },
    {
      'title': 'Departments under the City Administrator',
      'items': [],
      'expanded': false,
    },
    {
      'title': 'City Universities',
      'items': [],
      'expanded': false,
    },
    {
      'title': 'City Hospitals',
      'items': [],
      'expanded': false,
    },
    {
      'title': 'Health Centers',
      'items': [],
      'expanded': false,
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // Method to add new reminder from requirements checklist screen
  void _addNewReminderFromRequirements(Map<String, dynamic> reminderData) {
    setState(() {
      final newReminder = {
        'title': '${reminderData['serviceName'] ?? 'New Task'} Reminder',
        'description': 'Remember to process ${reminderData['serviceName'] ?? 'service'}',
        'status': 'Todo',
        'priority': 'Medium',
        'dueDate': 'Plan by: ${_getFutureDateString()}',
        'category': 'General',
        'reminderTasks': (reminderData['requirements'] as List<String>?)
                ?.map((req) => {'task': req, 'completed': false})
                ?.toList() ??
            [],
      };

      userReminders.add(newReminder);
    });
  }

  String _getFutureDateString() {
    final future = DateTime.now().add(Duration(days: 30));
    return '${future.month}/${future.day}/${future.year}';
  }

  // Navigate to profile screen
  void _navigateToProfile() {
    context.push('/profile');
  }

  // Show directory for department
  void _showDirectoryDialog(String departmentName) {
    final departmentInfo = departmentHeads[departmentName];
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.brown[700],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.people, color: Colors.white, size: 24),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Directory',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentName,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown[700],
                  ),
                ),
                SizedBox(height: 20),
                if (departmentInfo != null) ...[
                  _buildDirectoryField('Head of Office:', departmentInfo['head']!),
                  SizedBox(height: 15),
                  _buildDirectoryField('Designation:', departmentInfo['designation']!),
                  SizedBox(height: 15),
                  _buildDirectoryField('Contact Number:', departmentInfo['contact']!),
                  SizedBox(height: 15),
                  _buildDirectoryField('Office Location:', departmentInfo['room']!),
                ] else ...[
                  Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Text(
                      'Directory information not available for this department.',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'CLOSE',
                style: TextStyle(
                  color: Colors.brown[700],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDirectoryField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.brown[600],
            fontSize: 14,
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  // Navigate to office services
  void _navigateToOfficeServices(String officeName) {
    context.push('/office-services?office=${Uri.encodeComponent(officeName)}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E6D3),
        elevation: 0,
        title: Text(
          'ManilaServe',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 15),
            child: InkWell(
              onTap: _navigateToProfile,
              borderRadius: BorderRadius.circular(25),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.brown[700],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 22,
                ),
              ),
            ),
          ),
        ],
        leading: Builder(
          builder: (context) => Container(
            margin: EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.brown[700],
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
      drawer: _buildUserRemindersDrawer(),
      body: Column(
        children: [
          // Tab Bar
          Container(
            color: Color(0xFFF5E6D3),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });
                      _pageController.animateToPage(
                        0,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _currentIndex == 0
                                ? Colors.brown[700]!
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'Maps',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _currentIndex == 0
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });
                      _pageController.animateToPage(
                        1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: _currentIndex == 1
                                ? Colors.brown[700]!
                                : Colors.transparent,
                            width: 3,
                          ),
                        ),
                      ),
                      child: Text(
                        'Departments',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: _currentIndex == 1
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              children: [
                _buildMapsTab(),
                _buildDepartmentsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserRemindersDrawer() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5E6D3),
              Colors.white,
            ],
          ),
        ),
        child: Column(
          children: [
            // Enhanced Drawer Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 50, 20, 25),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.brown[800]!,
                    Colors.brown[600]!,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.person,
                          size: 35,
                          color: Colors.brown[700],
                        ),
                      ),
                      SizedBox(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Juan Dela Cruz',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'juan.delacruz@email.com',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.task_alt, color: Colors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'My Reminders & Tasks',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Reminders Section
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: userReminders.length,
                itemBuilder: (context, index) {
                  return _buildReminderCard(userReminders[index], index);
                },
              ),
            ),

            // Enhanced Footer Actions
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(top: BorderSide(color: Colors.brown[200]!, width: 2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _navigateToRequirementsChecklist();
                      },
                      icon: Icon(Icons.add_task, color: Colors.white, size: 20),
                      label: Text(
                        'Add New Reminder',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[700],
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _showCompletedReminders();
                      },
                      icon: Icon(Icons.done_all, color: Colors.brown[700], size: 20),
                      label: Text(
                        'View Completed Tasks',
                        style: TextStyle(
                          color: Colors.brown[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.brown[700]!, width: 2),
                        padding: EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToRequirementsChecklist() async {
    final result = await context.push('/requirements');
    
    if (result != null && result is Map<String, dynamic>) {
      _addNewReminderFromRequirements(result);
    }
  }

  void _showCompletedReminders() {
    final completedReminders = userReminders.where((reminder) => reminder['status'] == 'Completed').toList();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.done_all, color: Colors.green),
              SizedBox(width: 10),
              Text('Completed Tasks'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 300,
            child: completedReminders.isEmpty
              ? Center(
                  child: Text(
                    'No completed tasks yet',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : ListView.builder(
                  itemCount: completedReminders.length,
                  itemBuilder: (context, index) {
                    final reminder = completedReminders[index];
                    return Card(
                      child: ListTile(
                        leading: Icon(Icons.check_circle, color: Colors.green),
                        title: Text(reminder['title']),
                        subtitle: Text(reminder['dueDate']),
                      ),
                    );
                  },
                ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildReminderCard(Map<String, dynamic> reminder, int index) {
    Color statusColor;
    IconData statusIcon;

    switch (reminder['status']) {
      case 'Completed':
        statusColor = Colors.green;
        statusIcon = Icons.check_circle;
        break;
      case 'In Progress':
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case 'Todo':
        statusColor = Colors.orange;
        statusIcon = Icons.assignment;
        break;
      case 'Upcoming':
        statusColor = Colors.purple;
        statusIcon = Icons.upcoming;
        break;
      default:
        statusColor = Colors.grey;
        statusIcon = Icons.pending;
    }

    Color priorityColor;
    switch (reminder['priority']) {
      case 'High':
        priorityColor = Colors.red;
        break;
      case 'Medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            statusIcon,
            color: statusColor,
            size: 20,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                reminder['title'],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: priorityColor,
                shape: BoxShape.circle,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Text(
              reminder['description'],
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 6),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    reminder['status'],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    reminder['category'],
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    reminder['dueDate'],
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        children: [
          Container(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Tasks to Complete:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${reminder['priority']} Priority',
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                ...reminder['reminderTasks'].map<Widget>((task) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              task['completed'] = !task['completed'];
                              _updateReminderProgress(index);
                            });
                          },
                          child: Icon(
                            task['completed']
                                ? Icons.check_circle
                                : Icons.radio_button_unchecked,
                            color: task['completed'] ? Colors.green : Colors.grey,
                           size: 20,
                         ),
                       ),
                       SizedBox(width: 10),
                       Expanded(
                         child: Text(
                           task['task'],
                           style: TextStyle(
                             fontSize: 13,
                             color: task['completed']
                                 ? Colors.black87
                                 : Colors.grey[600],
                             decoration: task['completed']
                                 ? TextDecoration.lineThrough
                                 : null,
                           ),
                         ),
                       ),
                     ],
                   ),
                 );
               }).toList(),
               SizedBox(height: 15),
               Row(
                 children: [
                   Expanded(
                     child: ElevatedButton.icon(
                       onPressed: () {
                         Navigator.pop(context);
                         _showReminderDetails(reminder);
                       },
                       icon: Icon(Icons.info_outline, color: Colors.white, size: 16),
                       label: Text(
                         'View Details',
                         style: TextStyle(color: Colors.white, fontSize: 12),
                       ),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: statusColor,
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                   SizedBox(width: 10),
                   Expanded(
                     child: ElevatedButton.icon(
                       onPressed: () {
                         Navigator.pop(context);
                         _markReminderComplete(reminder, index);
                       },
                       icon: Icon(
                         reminder['status'] == 'Completed' ? Icons.done_all : Icons.done,
                         color: Colors.white,
                         size: 16,
                       ),
                       label: Text(
                         reminder['status'] == 'Completed' ? 'Completed' : 'Mark Done',
                         style: TextStyle(color: Colors.white, fontSize: 12),
                       ),
                       style: ElevatedButton.styleFrom(
                         backgroundColor: reminder['status'] == 'Completed'
                             ? Colors.green
                             : Colors.brown[700],
                         shape: RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(8),
                         ),
                       ),
                     ),
                   ),
                 ],
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }

 void _updateReminderProgress(int index) {
   final tasks = userReminders[index]['reminderTasks'] as List;
   final completedTasks = tasks.where((task) => task['completed']).length;
   
   if (completedTasks == tasks.length) {
     userReminders[index]['status'] = 'Completed';
   } else if (completedTasks > 0) {
     userReminders[index]['status'] = 'In Progress';
   } else {
     userReminders[index]['status'] = 'Todo';
   }
 }

 void _markReminderComplete(Map<String, dynamic> reminder, int index) {
   if (reminder['status'] == 'Completed') {
     _showReminderDetails(reminder);
     return;
   }

   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: Text(
           'Mark as Complete',
           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
         ),
         content: Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Icon(
               Icons.task_alt,
               color: Colors.green,
               size: 60,
             ),
             SizedBox(height: 15),
             Text(
               'Mark "${reminder['title']}" as completed?',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 16),
             ),
             SizedBox(height: 10),
             Text(
               'This will move the reminder to your completed tasks.',
               textAlign: TextAlign.center,
               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
             ),
           ],
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(),
             child: Text('CANCEL'),
           ),
           ElevatedButton(
             onPressed: () {
               Navigator.of(context).pop();
               setState(() {
                 userReminders[index]['status'] = 'Completed';
                 userReminders[index]['dueDate'] = 'Completed: ${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}';
                 for (var task in userReminders[index]['reminderTasks']) {
                   task['completed'] = true;
                 }
               });
               
               ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                   content: Text('Reminder marked as completed!'),
                   backgroundColor: Colors.green,
                   duration: Duration(seconds: 2),
                 ),
               );
             },
             child: Text('COMPLETE', style: TextStyle(color: Colors.white)),
             style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
           ),
         ],
       );
     },
   );
 }

 void _showReminderDetails(Map<String, dynamic> reminder) {
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         title: Text(
           reminder['title'],
           style: TextStyle(fontSize: 16),
         ),
         content: SingleChildScrollView(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisSize: MainAxisSize.min,
             children: [
               Text(
                 'Description:',
                 style: TextStyle(fontWeight: FontWeight.bold),
               ),
               SizedBox(height: 5),
               Text(reminder['description']),
               SizedBox(height: 15),
               Row(
                 children: [
                   Text(
                     'Status: ',
                     style: TextStyle(fontWeight: FontWeight.bold),
                   ),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                     decoration: BoxDecoration(
                       color: reminder['status'] == 'Completed' ? Colors.green : Colors.orange,
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Text(
                       reminder['status'],
                       style: TextStyle(color: Colors.white, fontSize: 12),
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 10),
               Row(
                 children: [
                   Text(
                     'Priority: ',
                     style: TextStyle(fontWeight: FontWeight.bold),
                   ),
                   Container(
                     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                     decoration: BoxDecoration(
                       color: reminder['priority'] == 'High' ? Colors.red : 
                              reminder['priority'] == 'Medium' ? Colors.orange : Colors.green,
                       borderRadius: BorderRadius.circular(10),
                     ),
                     child: Text(
                       reminder['priority'],
                       style: TextStyle(color: Colors.white, fontSize: 12),
                     ),
                   ),
                 ],
               ),
               SizedBox(height: 10),
               Text(reminder['dueDate']),
               SizedBox(height: 15),
               Text(
                 'Tips:',
                 style: TextStyle(fontWeight: FontWeight.bold),
               ),
               SizedBox(height: 5),
               Container(
                 padding: EdgeInsets.all(10),
                 decoration: BoxDecoration(
                   color: Colors.blue.withOpacity(0.1),
                   borderRadius: BorderRadius.circular(8),
                   border: Border.all(color: Colors.blue.withOpacity(0.3)),
                 ),
                 child: Text(
                   'Visit during office hours (8AM-5PM). Bring valid ID and required documents.',
                   style: TextStyle(fontSize: 13),
                 ),
               ),
             ],
           ),
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(),
             child: Text('CLOSE'),
           ),
         ],
       );
     },
   );
 }

 Widget _buildMapsTab() {
   return Column(
     children: [
       // Interactive Maps Section
       Expanded(
         child: Stack(
           children: [
             // Map Background - Always visible
             Container(
               width: double.infinity,
               height: double.infinity,
               child: CustomPaint(
                 painter: MapPainter(),
                 size: Size.infinite,
               ),
             ),

             // Current Location Marker
             Positioned(
               bottom: 120,
               left: MediaQuery.of(context).size.width * 0.45,
               child: Container(
                 width: 40,
                 height: 40,
                 decoration: BoxDecoration(
                   color: Colors.blue,
                   shape: BoxShape.circle,
                   border: Border.all(color: Colors.white, width: 2),
                   boxShadow: [
                     BoxShadow(
                       color: Colors.black26,
                       blurRadius: 6,
                       offset: Offset(0, 2),
                     ),
                   ],
                 ),
                 child: Icon(
                   Icons.my_location,
                   color: Colors.white,
                   size: 20,
                 ),
               ),
             ),

             // Quick Access Buttons
             Positioned(
               top: 10,
               left: 15,
               right: 15,
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   _buildQuickAccessButton(
                       'Mayor\'s Office', Icons.account_balance),
                   _buildQuickAccessButton('Registry', Icons.assignment),
                   _buildQuickAccessButton(
                       'Treasury', Icons.account_balance_wallet),
                 ],
               ),
             ),

             // Office Info Panel
             if (_showOfficeInfo && !_showNavigation)
               Positioned(
                 top: 60,
                 left: 15,
                 right: 15,
                 child: Container(
                   padding: EdgeInsets.all(14),
                   decoration: BoxDecoration(
                     color: Colors.brown[700],
                     borderRadius: BorderRadius.circular(10),
                     boxShadow: [
                       BoxShadow(
                         color: Colors.black26,
                         blurRadius: 8,
                         offset: Offset(0, 3),
                       ),
                     ],
                   ),
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Row(
                         children: [
                           Container(
                             width: 30,
                             height: 30,
                             decoration: BoxDecoration(
                               color: Colors.orange,
                               shape: BoxShape.circle,
                             ),
                             child: Icon(
                               Icons.location_city,
                               color: Colors.white,
                               size: 16,
                             ),
                           ),
                           SizedBox(width: 10),
                           Expanded(
                             child: Text(
                               _selectedOffice,
                               style: TextStyle(
                                 color: Colors.white,
                                 fontWeight: FontWeight.bold,
                                 fontSize: 14,
                               ),
                             ),
                           ),
                           IconButton(
                             icon: Icon(Icons.close,
                                 color: Colors.white, size: 20),
                             onPressed: () {
                               setState(() {
                                 _showOfficeInfo = false;
                               });
                             },
                           ),
                         ],
                       ),
                       SizedBox(height: 8),
                       Text(
                         'Available Routes',
                         style: TextStyle(
                           color: Colors.white,
                           fontWeight: FontWeight.bold,
                           fontSize: 12,
                         ),
                       ),
                       SizedBox(height: 6),
                       _buildRouteOption('5 mins walk', Icons.directions_walk),
                       SizedBox(height: 3),
                       _buildRouteOption('3 mins drive', Icons.directions_car),
                     ],
                   ),
                 ),
               ),

             // Navigation View Overlay
             if (_showNavigation) _buildNavigationView(),
           ],
         ),
       ),

       // Bottom Fixed Controls
       Container(
         color: Colors.white,
         padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
         child: Row(
           children: [
             // Search Bar
             Expanded(
               child: Container(
                 height: 45,
                 child: TextField(
                   controller: _searchController,
                   focusNode: _searchFocus,
                   onSubmitted: (value) {
                     if (value.trim().isNotEmpty) {
                       setState(() {
                         _selectedOffice = value.trim();
                         _showOfficeInfo = true;
                       });
                       _searchFocus.unfocus();
                     }
                   },
                   decoration: InputDecoration(
                     hintText: 'Search Manila City Hall Offices',
                     hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                     filled: true,
                     fillColor: Colors.brown[700],
                     prefixIcon:
                         Icon(Icons.search, color: Colors.white70, size: 20),
                     suffixIcon: _searchController.text.isNotEmpty
                         ? IconButton(
                             icon: Icon(Icons.clear,
                                 color: Colors.white70, size: 18),
                             onPressed: () {
                               _searchController.clear();
                               setState(() {});
                             },
                           )
                         : null,
                     border: OutlineInputBorder(
                       borderRadius: BorderRadius.circular(25),
                       borderSide: BorderSide.none,
                     ),
                     contentPadding: EdgeInsets.symmetric(horizontal: 15),
                   ),
                   style: TextStyle(color: Colors.white, fontSize: 13),
                   onChanged: (value) {
                     setState(() {});
                   },
                 ),
               ),
             ),
             SizedBox(width: 12),

             // AR Button
             Container(
               width: 45,
               height: 45,
               child: FloatingActionButton(
                 onPressed: _showARView,
                 backgroundColor: Colors.brown[700],
                 elevation: 3,
                 child: Icon(
                   Icons.view_in_ar,
                   color: Colors.white,
                   size: 20,
                 ),
               ),
             ),
           ],
         ),
       ),
     ],
   );
 }

 Widget _buildQuickAccessButton(String title, IconData icon) {
   bool isSelected = _selectedOffice == title;

   return GestureDetector(
     onTap: () {
       setState(() {
         _selectedOffice = title;
         _showOfficeInfo = true;
       });
     },
     child: Container(
       padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
       decoration: BoxDecoration(
         color: isSelected ? Colors.brown[700] : Colors.white.withOpacity(0.9),
         borderRadius: BorderRadius.circular(15),
         boxShadow: [
           BoxShadow(
             color: Colors.black26,
             blurRadius: 3,
             offset: Offset(0, 1),
           ),
         ],
       ),
       child: Row(
         mainAxisSize: MainAxisSize.min,
         children: [
           Icon(icon,
               size: 14, color: isSelected ? Colors.white : Colors.brown[700]),
           SizedBox(width: 3),
           Text(
             title,
             style: TextStyle(
               fontSize: 10,
               fontWeight: FontWeight.w500,
               color: isSelected ? Colors.white : Colors.brown[700],
             ),
           ),
         ],
       ),
     ),
   );
 }

 Widget _buildRouteOption(String duration, IconData icon) {
   return GestureDetector(
     onTap: () {
       _showARView();
     },
     child: Container(
       padding: EdgeInsets.all(8),
       decoration: BoxDecoration(
         color: Colors.white.withOpacity(0.2),
         borderRadius: BorderRadius.circular(6),
         border: Border.all(color: Colors.white30),
       ),
       child: Row(
         children: [
           Icon(icon, color: Colors.white, size: 16),
           SizedBox(width: 8),
           // Route dots
           Row(
             children: List.generate(
                 6,
                 (index) => Container(
                       margin: EdgeInsets.symmetric(horizontal: 1),
                       width: 4,
                       height: 4,
                       decoration: BoxDecoration(
                         color: Colors.orange,
                         shape: BoxShape.circle,
                       ),
                     )),
           ),
           Spacer(),
           Text(
             duration,
             style: TextStyle(
               color: Colors.white,
               fontWeight: FontWeight.w500,
               fontSize: 12,
             ),
           ),
           SizedBox(width: 4),
           Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 10),
         ],
       ),
     ),
   );
 }

 Widget _buildNavigationView() {
   return Container(
     color: Colors.black87,
     child: Column(
       children: [
         // Navigation Header
         Container(
           padding: EdgeInsets.all(15),
           child: Row(
             children: [
               IconButton(
                 icon: Icon(Icons.arrow_back, color: Colors.white),
                 onPressed: () {
                   setState(() {
                     _showNavigation = false;
                   });
                 },
               ),
               SizedBox(width: 10),
               Expanded(
                 child: Container(
                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                   decoration: BoxDecoration(
                     color: Colors.orange,
                     borderRadius: BorderRadius.circular(12),
                   ),
                   child: Text(
                     'AR NAVIGATION - Point camera to see office names',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.black,
                       fontWeight: FontWeight.bold,
                       fontSize: 10,
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),

         // AR Camera Simulation
         Expanded(
           child: Container(
             decoration: BoxDecoration(
               gradient: LinearGradient(
                 begin: Alignment.topCenter,
                 end: Alignment.bottomCenter,
                 colors: [
                   Colors.cyan.withOpacity(0.3),
                   Colors.blue.withOpacity(0.1)
                 ],
               ),
             ),
             child: Stack(
               children: [
                 // AR Labels
                 Positioned(
                   left: 40,
                   top: 80,
                   child: _buildARLabel('Registry Office'),
                 ),
                 Positioned(
                   right: 40,
                   top: 120,
                   child: _buildARLabel('Treasury'),
                 ),
                 Positioned(
                   left: 30,
                   bottom: 150,
                   child: _buildARLabel('Mayor\'s Office'),
                 ),
               ],
             ),
           ),
         ),

         // Navigation Instructions
         Container(
           padding: EdgeInsets.all(15),
           decoration: BoxDecoration(
             color: Colors.black,
             borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
           ),
           child: Row(
             children: [
               Container(
                 width: 40,
                 height: 40,
                 decoration: BoxDecoration(
                   color: Colors.blue,
                   borderRadius: BorderRadius.circular(8),
                 ),
                 child: Icon(Icons.turn_right, color: Colors.white, size: 20),
               ),
               SizedBox(width: 12),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'Navigate to $_selectedOffice',
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 14,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     Text(
                       'Turn right in 16 meters',
                       style: TextStyle(
                         color: Colors.white70,
                         fontSize: 12,
                       ),
                     ),
                   ],
                 ),
               ),
               Container(
                 width: 50,
                 height: 50,
                 decoration: BoxDecoration(
                   color: Colors.orange,
                   shape: BoxShape.circle,
                 ),
                 child: Center(
                   child: Text(
                     '45m',
                     style: TextStyle(
                       color: Colors.black,
                       fontWeight: FontWeight.bold,
                       fontSize: 12,
                     ),
                   ),
                 ),
               ),
             ],
           ),
         ),
       ],
     ),
   );
 }

 Widget _buildARLabel(String label) {
   return Container(
     padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
     decoration: BoxDecoration(
       color: Colors.black87,
       borderRadius: BorderRadius.circular(4),
       border: Border.all(color: Colors.cyan, width: 1),
     ),
     child: Text(
       label,
       style: TextStyle(
         color: Colors.cyan,
         fontSize: 12,
         fontWeight: FontWeight.bold,
       ),
     ),
   );
 }

 Widget _buildDepartmentsTab() {
   return SingleChildScrollView(
     child: Column(
       children: [
         SizedBox(height: 20),

         // Enhanced Header
         Container(
           margin: EdgeInsets.symmetric(horizontal: 15),
           padding: EdgeInsets.all(20),
           decoration: BoxDecoration(
             gradient: LinearGradient(
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
               colors: [Colors.brown[600]!, Colors.brown[800]!],
             ),
             borderRadius: BorderRadius.circular(15),
             boxShadow: [
               BoxShadow(
                 color: Colors.black26,
                 blurRadius: 8,
                 offset: Offset(0, 4),
               ),
             ],
           ),
           child: Row(
             children: [
               Container(
                 padding: EdgeInsets.all(12),
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.2),
                   borderRadius: BorderRadius.circular(12),
                 ),
                 child: Icon(
                   Icons.business,
                   color: Colors.white,
                   size: 30,
                 ),
               ),
               SizedBox(width: 15),
               Expanded(
                 child: Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                   children: [
                     Text(
                       'City Departments',
                       style: TextStyle(
                         color: Colors.white,
                         fontSize: 22,
                         fontWeight: FontWeight.bold,
                       ),
                     ),
                     SizedBox(height: 5),
                     Text(
                       'Browse offices and their services',
                       style: TextStyle(
                         color: Colors.white70,
                         fontSize: 14,
                       ),
                     ),
                   ],
                 ),
               ),
             ],
           ),
         ),

         SizedBox(height: 20),

         // Departments List
         ListView.builder(
           shrinkWrap: true,
           physics: NeverScrollableScrollPhysics(),
           itemCount: departments.length,
           itemBuilder: (context, index) {
             final dept = departments[index];
             return Container(
               margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
               child: Card(
                 elevation: 4,
                 shape: RoundedRectangleBorder(
                   borderRadius: BorderRadius.circular(12),
                 ),
                 color: dept['expanded'] ? Color(0xFFD4A574) : Colors.brown[700],
                 child: ExpansionTile(
                   title: Text(
                     dept['title'],
                     style: TextStyle(
                       color: dept['expanded'] ? Colors.black : Colors.white,
                       fontWeight: FontWeight.bold,
                       fontSize: 16,
                     ),
                   ),
                   trailing: Icon(
                     dept['expanded'] ? Icons.expand_less : Icons.expand_more,
                     color: dept['expanded'] ? Colors.black : Colors.white,
                     size: 28,
                   ),
                   children: dept['items'].isEmpty
                       ? [
                           Container(
                             padding: EdgeInsets.all(20),
                             child: Text(
                               'No departments available in this category.',
                               style: TextStyle(
                                 color: dept['expanded'] ? Colors.black54 : Colors.white70,
                                 fontStyle: FontStyle.italic,
                               ),
                             ),
                           )
                         ]
                       : dept['items'].map<Widget>((item) {
                           return Container(
                             margin: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                             child: Card(
                               color: Colors.white,
                               elevation: 2,
                               shape: RoundedRectangleBorder(
                                 borderRadius: BorderRadius.circular(8),
                               ),
                               child: ListTile(
                                 leading: Container(
                                   padding: EdgeInsets.all(8),
                                   decoration: BoxDecoration(
                                     color: Colors.brown[100],
                                     borderRadius: BorderRadius.circular(8),
                                   ),
                                   child: Icon(
                                     Icons.business_center,
                                     color: Colors.brown[700],
                                     size: 20,
                                   ),
                                 ),
                                 title: Text(
                                   item,
                                   style: TextStyle(
                                     color: Colors.black87,
                                     fontWeight: FontWeight.w600,
                                     fontSize: 14,
                                   ),
                                 ),
                                 trailing: Row(
                                   mainAxisSize: MainAxisSize.min,
                                   children: [
                                     Container(
                                       margin: EdgeInsets.only(right: 5),
                                       child: ElevatedButton(
                                         onPressed: () => _showDirectoryDialog(item),
                                         child: Text(
                                           'DIRECTORY',
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 10,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                         style: ElevatedButton.styleFrom(
                                           backgroundColor: Colors.blue[600],
                                           padding: EdgeInsets.symmetric(
                                             horizontal: 8,
                                             vertical: 4,
                                           ),
                                           minimumSize: Size(0, 30),
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(6),
                                           ),
                                         ),
                                       ),
                                     ),
                                     Container(
                                       child: ElevatedButton(
                                         onPressed: () => _navigateToOfficeServices(item),
                                         child: Text(
                                           'SERVICES',
                                           style: TextStyle(
                                             color: Colors.white,
                                             fontSize: 10,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                         style: ElevatedButton.styleFrom(
                                           backgroundColor: Colors.green[600],
                                           padding: EdgeInsets.symmetric(
                                             horizontal: 8,
                                             vertical: 4,
                                           ),
                                           minimumSize: Size(0, 30),
                                           shape: RoundedRectangleBorder(
                                             borderRadius: BorderRadius.circular(6),
                                           ),
                                         ),
                                       ),
                                     ),
                                   ],
                                 ),
                                 onTap: () => _showOfficeDetails(context, item),
                               ),
                             ),
                           );
                         }).toList(),
                   onExpansionChanged: (expanded) {
                     setState(() {
                       dept['expanded'] = expanded;
                     });
                   },
                 ),
               ),
             );
           },
         ),
         SizedBox(height: 20),
       ],
     ),
   );
 }

 void _showARView() {
   setState(() {
     _showNavigation = true;
   });
 }

 void _showOfficeDetails(BuildContext context, String officeName) {
   final officeInfo = departmentHeads[officeName];
   
   showDialog(
     context: context,
     builder: (BuildContext context) {
       return AlertDialog(
         shape: RoundedRectangleBorder(
           borderRadius: BorderRadius.circular(15),
         ),
         title: Container(
           padding: EdgeInsets.all(10),
           decoration: BoxDecoration(
             color: Colors.brown[700],
             borderRadius: BorderRadius.circular(10),
           ),
           child: Row(
             children: [
               Icon(Icons.location_city, color: Colors.white, size: 24),
               SizedBox(width: 10),
               Expanded(
                 child: Text(
                   'Office Details',
                   style: TextStyle(
                     color: Colors.white,
                     fontSize: 18,
                     fontWeight: FontWeight.bold,
                   ),
                 ),
               ),
             ],
           ),
         ),
         content: Container(
           width: double.maxFinite,
           child: Column(
             mainAxisSize: MainAxisSize.min,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(
                 officeName,
                 style: TextStyle(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                   color: Colors.brown[700],
                 ),
               ),
               SizedBox(height: 20),
               if (officeInfo != null) ...[
                 _buildDetailField('Head:', officeInfo['head']!),
                 SizedBox(height: 10),
                 _buildDetailField('Designation:', officeInfo['designation']!),
                 SizedBox(height: 10),
                 _buildDetailField('Contact No.:', officeInfo['contact']!),
                 SizedBox(height: 10),
                 _buildDetailField('Room No.:', officeInfo['room']!),
               ] else ...[
                 Container(
                   padding: EdgeInsets.all(15),
                   decoration: BoxDecoration(
                     color: Colors.grey[100],
                     borderRadius: BorderRadius.circular(8),
                     border: Border.all(color: Colors.grey[300]!),
                   ),
                   child: Text(
                     'Office details not available.',
                    style: TextStyle(
                       color: Colors.grey[600],
                       fontStyle: FontStyle.italic,
                     ),
                   ),
                 ),
               ],
             ],
           ),
         ),
         actions: [
           TextButton(
             onPressed: () => Navigator.of(context).pop(),
             child: Text(
               'CLOSE',
               style: TextStyle(
                 color: Colors.brown[700],
                 fontWeight: FontWeight.bold,
               ),
             ),
           ),
         ],
       );
     },
   );
 }

 Widget _buildDetailField(String label, String value) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: [
       Text(
         label,
         style: TextStyle(
           fontWeight: FontWeight.bold,
           color: Colors.brown[600],
           fontSize: 14,
         ),
       ),
       SizedBox(height: 5),
       Container(
         width: double.infinity,
         padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
         decoration: BoxDecoration(
           color: Colors.grey[50],
           border: Border.all(color: Colors.grey[300]!),
           borderRadius: BorderRadius.circular(8),
         ),
         child: Text(
           value.isEmpty ? 'Not available' : value,
           style: TextStyle(
             fontSize: 14,
             color: Colors.black87,
           ),
         ),
       ),
     ],
   );
 }
}

// Map Painter for the integrated maps
class MapPainter extends CustomPainter {
 @override
 void paint(Canvas canvas, Size size) {
   final paint = Paint();

   // Background
   paint.color = Color(0xFFE8E8E8);
   canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

   // Buildings
   paint.color = Colors.brown[300]!;

   // Mayor's Office
   canvas.drawRRect(
     RRect.fromRectAndRadius(
       Rect.fromLTWH(40, 60, 100, 80),
       Radius.circular(6),
     ),
     paint,
   );

   // Registry
   canvas.drawRRect(
     RRect.fromRectAndRadius(
       Rect.fromLTWH(160, 50, 80, 60),
       Radius.circular(6),
     ),
     paint,
   );

   // Treasury
   canvas.drawRRect(
     RRect.fromRectAndRadius(
       Rect.fromLTWH(260, 70, 70, 70),
       Radius.circular(6),
     ),
     paint,
   );

   // Additional buildings
   paint.color = Colors.brown[200]!;
   canvas.drawRRect(
     RRect.fromRectAndRadius(
       Rect.fromLTWH(25, 160, 120, 60),
       Radius.circular(6),
     ),
     paint,
   );

   canvas.drawRRect(
     RRect.fromRectAndRadius(
       Rect.fromLTWH(160, 140, 100, 80),
       Radius.circular(6),
     ),
     paint,
   );

   // Walkways
   paint.color = Colors.grey[300]!;
   paint.strokeWidth = 4;

   // Main paths
   canvas.drawLine(Offset(0, size.height * 0.4),
       Offset(size.width, size.height * 0.4), paint);

   canvas.drawLine(Offset(size.width * 0.35, 0),
       Offset(size.width * 0.35, size.height), paint);
   canvas.drawLine(Offset(size.width * 0.65, 0),
       Offset(size.width * 0.65, size.height), paint);
 }

 @override
 bool shouldRepaint(CustomPainter oldDelegate) => false;
}
