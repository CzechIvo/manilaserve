import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final List<Map<String, dynamic>> departments = [
    {
      'title': 'Departments Under the Office of the Mayor',
      'icon': Icons.account_balance,
      'color': Color(0xFF8B4513),
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
      'icon': Icons.supervised_user_circle,
      'color': Color(0xFF6B4423),
      'items': [],
      'expanded': false,
    },
    {
      'title': 'Departments under the City Council',
      'icon': Icons.groups,
      'color': Color(0xFF5B3A21),
      'items': [],
      'expanded': false,
    },
    {
      'title': 'Departments under the City Administrator',
      'icon': Icons.admin_panel_settings,
      'color': Color(0xFF4B2F1A),
      'items': [],
      'expanded': false,
    },
    {
      'title': 'City Universities',
      'icon': Icons.school,
      'color': Color(0xFF3B2515),
      'items': [],
      'expanded': false,
    },
    {
      'title': 'City Hospitals',
      'icon': Icons.local_hospital,
      'color': Color(0xFF2B1A0F),
      'items': [],
      'expanded': false,
    },
    {
      'title': 'Health Centers',
      'icon': Icons.health_and_safety,
      'color': Color(0xFF1B0F0A),
      'items': [],
      'expanded': false,
    },
  ];

  // Statistics data
  final Map<String, dynamic> statistics = {
    'totalDepartments': 7,
    'totalOffices': 9,
    'activeServices': 45,
    'pendingUpdates': 3,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: Color(0xFF8B4513),
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.dashboard, color: Colors.white, size: 24),
            SizedBox(width: 10),
            Text(
              'ManilaServe Admin Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.notifications, color: Colors.white, size: 22),
            ),
            onPressed: () {
              _showNotificationsDialog();
            },
          ),
          SizedBox(width: 8),
          IconButton(
            icon: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.account_circle, color: Colors.white, size: 24),
            ),
            onPressed: () {
              context.push('/admin-profile');
            },
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: _buildAdminDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Cards
            Container(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Dashboard Overview',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF8B4513),
                    ),
                  ),
                  SizedBox(height: 20),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 15,
                    mainAxisSpacing: 15,
                    children: [
                      _buildStatCard(
                        'Total Departments',
                        statistics['totalDepartments'].toString(),
                        Icons.business,
                        Color(0xFF8B4513),
                      ),
                      _buildStatCard(
                        'Total Offices',
                        statistics['totalOffices'].toString(),
                        Icons.door_front_door,
                        Color(0xFF6B4423),
                      ),
                      _buildStatCard(
                        'Active Services',
                        statistics['activeServices'].toString(),
                        Icons.miscellaneous_services,
                        Color(0xFF5B3A21),
                      ),
                      _buildStatCard(
                        'Pending Updates',
                        statistics['pendingUpdates'].toString(),
                        Icons.pending_actions,
                        Color(0xFF4B2F1A),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Department Management Section
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Department Management',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF8B4513),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddDepartmentDialog,
                        icon: Icon(Icons.add, color: Colors.white, size: 20),
                        label: Text(
                          'Add Department',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF8B4513),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Manage all city hall departments and offices',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: departments.length,
              itemBuilder: (context, index) {
                final dept = departments[index];
                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color: dept['expanded'] ? Color(0xFFD4A574) : Colors.white,
                    child: ExpansionTile(
                      leading: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: dept['color'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          dept['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      title: Text(
                        dept['title'],
                        style: TextStyle(
                          color: dept['expanded'] ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                      ),
                      subtitle: Text(
                        '${dept['items'].length} offices',
                        style: TextStyle(
                          color: dept['expanded'] ? Colors.white70 : Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                      trailing: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: dept['expanded'] 
                            ? Colors.white.withOpacity(0.2)
                            : Colors.grey.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          dept['expanded'] ? Icons.expand_less : Icons.expand_more,
                          color: dept['expanded'] ? Colors.white : Color(0xFF8B4513),
                        ),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                          ),
                          padding: EdgeInsets.all(15),
                          child: Column(
                            children: [
                              if (dept['items'].isEmpty) 
                                Container(
                                  padding: EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.inbox,
                                        color: Colors.grey[400],
                                        size: 48,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'No offices added yet',
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 14,
                                        ),
                                      ),
                                      SizedBox(height: 15),
                                      ElevatedButton.icon(
                                        onPressed: () => _showAddOfficeDialog(index),
                                        icon: Icon(Icons.add, color: Colors.white, size: 18),
                                        label: Text(
                                          'Add First Office',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Color(0xFF8B4513),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                ...dept['items'].map<Widget>((item) {
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey[50],
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(color: Colors.grey[200]!),
                                    ),
                                    child: ListTile(
                                      leading: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(0xFF8B4513).withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Icon(
                                          Icons.business_center,
                                          color: Color(0xFF8B4513),
                                          size: 20,
                                        ),
                                      ),
                                      title: Text(
                                        item,
                                        style: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.info_outline,
                                              color: Colors.blue[600],
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _showOfficeDetailsDialog(item);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: Colors.orange[600],
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _showEditOfficeDialog(item, index);
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: Colors.red[600],
                                              size: 20,
                                            ),
                                            onPressed: () {
                                              _showDeleteOfficeDialog(item, index);
                                            },
                                          ),
                                        ],
                                      ),
                                      onTap: () {
                                        context.push('/admin-office-services?office=${Uri.encodeComponent(item)}');
                                      },
                                    ),
                                  );
                                }).toList(),
                                if (dept['items'].isNotEmpty)
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    child: OutlinedButton.icon(
                                      onPressed: () => _showAddOfficeDialog(index),
                                      icon: Icon(Icons.add, color: Color(0xFF8B4513), size: 18),
                                      label: Text(
                                        'Add Office',
                                        style: TextStyle(color: Color(0xFF8B4513)),
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        side: BorderSide(color: Color(0xFF8B4513)),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ],
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
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminDrawer() {
    return Drawer(
      child: Container(
        color: Color(0xFFF5E6D3),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B4513), Color(0xFF6B4423)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.admin_panel_settings,
                      color: Color(0xFF8B4513),
                      size: 35,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Admin Dashboard',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'ManilaServe Management',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            _buildDrawerItem(Icons.dashboard, 'Dashboard', true, () {}),
            _buildDrawerItem(Icons.business, 'Departments', false, () {}),
            _buildDrawerItem(Icons.miscellaneous_services, 'Services', false, () {}),
            _buildDrawerItem(Icons.people, 'Users', false, () {}),
            _buildDrawerItem(Icons.analytics, 'Analytics', false, () {}),
            _buildDrawerItem(Icons.settings, 'Settings', false, () {}),
            Divider(),
            _buildDrawerItem(Icons.logout, 'Logout', false, () {
              _showLogoutDialog();
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, bool selected, VoidCallback onTap) {
    return ListTile(
      leading: Icon(
        icon,
        color: selected ? Color(0xFF8B4513) : Colors.grey[700],
      ),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? Color(0xFF8B4513) : Colors.grey[700],
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      selected: selected,
      selectedTileColor: Color(0xFF8B4513).withOpacity(0.1),
      onTap: onTap,
    );
  }

  void _showNotificationsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.notifications, color: Color(0xFF8B4513)),
              SizedBox(width: 10),
              Text('Notifications'),
            ],
          ),
          content: Container(
            width: double.maxFinite,
            height: 200,
            child: ListView(
              children: [
                _buildNotificationItem(
                  'New service added',
                  'Birth Certificate Request was added',
                  '2 hours ago',
                  Icons.add_circle,
                  Colors.green,
                ),
                _buildNotificationItem(
                  'Office updated',
                  'Treasury office information updated',
                  '5 hours ago',
                  Icons.edit,
                  Colors.blue,
                ),
                _buildNotificationItem(
                  'Pending approval',
                  '3 new services require approval',
                  '1 day ago',
                  Icons.pending,
                  Colors.orange,
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

  Widget _buildNotificationItem(String title, String subtitle, String time, IconData icon, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey[500],
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDepartmentDialog() {
    final departmentController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFF8B4513),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.add_business, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Add New Department',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: departmentController,
                decoration: InputDecoration(
                  labelText: 'Department Name',
                  prefixIcon: Icon(Icons.business, color: Color(0xFF8B4513)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF8B4513), width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (departmentController.text.isNotEmpty) {
                  setState(() {
                    departments.add({
                      'title': departmentController.text,
                      'icon': Icons.business,
                      'color': Color(0xFF8B4513),
                      'items': [],
                      'expanded': false,
                    });
                    statistics['totalDepartments']++;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Department added successfully!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B4513),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ADD', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddOfficeDialog(int departmentIndex) {
    final officeController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Color(0xFF8B4513),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.add_location_alt, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Add New Office',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: officeController,
                decoration: InputDecoration(
                  labelText: 'Office Name',
                  prefixIcon: Icon(Icons.door_front_door, color: Color(0xFF8B4513)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color(0xFF8B4513), width: 2),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (officeController.text.isNotEmpty) {
                  setState(() {
                    departments[departmentIndex]['items'].add(officeController.text);
                    statistics['totalOffices']++;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(Icons.check_circle, color: Colors.white),
                          SizedBox(width: 10),
                          Text('Office added successfully!'),
                        ],
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF8B4513),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('ADD', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showOfficeDetailsDialog(String officeName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8B4513), Color(0xFF6B4423)],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    officeName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailField('Head:', 'Not specified'),
              SizedBox(height: 10),
              _buildDetailField('Designation:', 'Not specified'),
              SizedBox(height: 10),
              _buildDetailField('Contact No.:', 'Not specified'),
              SizedBox(height: 10),
              _buildDetailField('Room No.:', 'Not specified'),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    context.push('/admin-office-services?office=${Uri.encodeComponent(officeName)}');
                  },
                  icon: Icon(Icons.settings, color: Colors.white),
                  label: Text(
                    'MANAGE SERVICES',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B4513),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
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

  void _showEditOfficeDialog(String officeName, int deptIndex) {
    final officeNameController = TextEditingController(text: officeName);
    final headController = TextEditingController();
    final designationController = TextEditingController();
    final contactController = TextEditingController();
    final roomController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: Colors.white,
          title: Container(
            padding: EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.orange[600],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.edit, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'Edit Office',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildEditField('Office Name:', officeNameController, Icons.business),
                SizedBox(height: 15),
                _buildEditField('Head:', headController, Icons.person),
                SizedBox(height: 15),
                _buildEditField('Designation:', designationController, Icons.badge),
                SizedBox(height: 15),
                _buildEditField('Contact No.:', contactController, Icons.phone),
                SizedBox(height: 15),
                _buildEditField('Room No.:', roomController, Icons.room),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                if (officeNameController.text.isNotEmpty && officeNameController.text != officeName) {
                  setState(() {
                    int itemIndex = departments[deptIndex]['items'].indexOf(officeName);
                    if (itemIndex != -1) {
                      departments[deptIndex]['items'][itemIndex] = officeNameController.text;
                    }
                  });
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Office updated successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.orange,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[600],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('SAVE', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteOfficeDialog(String officeName, int deptIndex) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red[600],
                  size: 40,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Delete Office',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Are you sure you want to delete "$officeName"?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                'This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red[400],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('CANCEL', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  departments[deptIndex]['items'].remove(officeName);
                  statistics['totalOffices']--;
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.white),
                        SizedBox(width: 10),
                        Text('Office deleted successfully!'),
                      ],
                    ),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text('DELETE', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 10),
              Text('Confirm Logout'),
            ],
          ),
          content: Text('Are you sure you want to log out from the admin panel?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.go('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: Text('Logout'),
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
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(height: 5),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value.isEmpty ? 'Not specified' : value,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildEditField(String label, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF8B4513), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF8B4513), width: 2),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      ),
    );
  }
}