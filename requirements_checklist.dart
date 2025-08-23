import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RequirementsChecklistScreen extends StatefulWidget {
  final Map<String, dynamic>? serviceData;
  
  const RequirementsChecklistScreen({Key? key, this.serviceData}) : super(key: key);

  @override
  _RequirementsChecklistScreenState createState() =>
      _RequirementsChecklistScreenState();
}

class _RequirementsChecklistScreenState
    extends State<RequirementsChecklistScreen> {
  List<Map<String, dynamic>> checklists = [];

  @override
  void initState() {
    super.initState();
    
    // Add new checklist from service data if provided
    if (widget.serviceData != null) {
      _addNewChecklist(widget.serviceData!);
    }
    
    // Add default checklists if none exist
    if (checklists.isEmpty) {
      checklists = [
        {
          'id': '1',
          'officeName': 'Office/Department Name',
          'serviceName': '[Specific Request]',
          'requirements': ['Requirement 1', 'Requirement 2', 'Requirement 3'],
          'checkedItems': [false, false, false],
          'color': Colors.grey,
        },
        {
          'id': '2',
          'officeName': 'Registry Office',
          'serviceName': 'Birth Certificate Request',
          'requirements': ['Valid ID', 'Application Form', 'Processing Fee'],
          'checkedItems': [false, false, false],
          'color': Color(0xFFD4A574),
        },
        {
          'id': '3',
          'officeName': 'Business Office',
          'serviceName': 'Business Permit Renewal',
          'requirements': ['Previous Permit', 'DTI Registration', 'Barangay Clearance'],
          'checkedItems': [false, false, false],
          'color': Colors.green,
        },
      ];
    }
  }

  void _addNewChecklist(Map<String, dynamic> serviceData) {
    final newChecklist = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'officeName': serviceData['officeName'] ?? 'Office/Department Name',
      'serviceName': serviceData['serviceName'] ?? '[Specific Request]',
      'requirements': List<String>.from(
          serviceData['requirements'] ?? ['Requirement 1', 'Requirement 2', 'Requirement 3']),
      'checkedItems': List<bool>.filled(
        (serviceData['requirements'] as List<String>?)?.length ?? 3,
        false,
      ),
      'color': _getRandomColor(),
    };

    setState(() {
      checklists.insert(0, newChecklist); // Add at the beginning
    });
  }

  Color _getRandomColor() {
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Color(0xFFD4A574),
      Colors.purple,
      Colors.teal,
    ];
    return colors[checklists.length % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Requirements Checklist'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Fixed navigation
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: checklists.length,
        itemBuilder: (context, index) {
          return _buildChecklistCard(checklists[index], index);
        },
      ),
    );
  }

  Widget _buildChecklistCard(Map<String, dynamic> checklist, int index) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Card(
        color: checklist['color'],
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Office Name Header
              Container(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  checklist['officeName'],
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
              
              SizedBox(height: 12),
              
              // Service Name
              Text(
                'Requesting For: ${checklist['serviceName']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: checklist['color'] == Colors.grey ? Colors.black : Colors.black87,
                ),
              ),
              
              SizedBox(height: 8),
              
              Text(
                'Requirements to be accomplished',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                  fontStyle: FontStyle.italic,
                ),
              ),
              
              SizedBox(height: 12),
              
              // Requirements Checklist
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: List.generate(checklist['requirements'].length, (reqIndex) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 2),
                      child: CheckboxListTile(
                        title: Text(
                          checklist['requirements'][reqIndex],
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            decoration: checklist['checkedItems'][reqIndex] 
                                ? TextDecoration.lineThrough 
                                : null,
                          ),
                        ),
                        value: checklist['checkedItems'][reqIndex],
                        onChanged: (bool? value) {
                          setState(() {
                            checklist['checkedItems'][reqIndex] = value ?? false;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        activeColor: Colors.green,
                        checkColor: Colors.white,
                      ),
                    );
                  }),
                ),
              ),
              
              SizedBox(height: 16),
              
              // Progress Indicator
              Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: _getProgress(checklist['checkedItems']),
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text(
                    '${(_getProgress(checklist['checkedItems']) * 100).round()}%',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 16),
              
              // Action Buttons - Simplified
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      _saveToReminders(checklist);
                    },
                    icon: Icon(Icons.bookmark, size: 16),
                    label: Text('SAVE TO TODO'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () {
                      _showDeleteDialog(checklist['id']);
                    },
                    icon: Icon(Icons.delete, size: 16),
                    label: Text('DELETE'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _getProgress(List<bool> checkedItems) {
    if (checkedItems.isEmpty) return 0.0;
    int completed = checkedItems.where((item) => item).length;
    return completed / checkedItems.length;
  }

  void _saveToReminders(Map<String, dynamic> checklist) {
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Checklist saved to your reminders!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: Colors.white,
          onPressed: () {
            // Navigate back to home and open drawer
            context.go('/home');
          },
        ),
      ),
    );
    
    // Return the checklist data to the home screen
    context.pop({
      'action': 'save_reminder',
      'data': checklist,
    });
  }

  void _showDeleteDialog(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 10),
            Text('Delete Checklist'),
          ],
        ),
        content: Text(
          'Are you sure you want to delete this checklist permanently? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                checklists.removeWhere((item) => item['id'] == id);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Checklist deleted successfully!'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('DELETE'),
          ),
        ],
      ),
    );
  }
}