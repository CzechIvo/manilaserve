import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OfficeServicesScreen extends StatefulWidget {
  final String officeName;
  
  const OfficeServicesScreen({
    Key? key, 
    this.officeName = 'Office Name'
  }) : super(key: key);

  @override
  _OfficeServicesScreenState createState() => _OfficeServicesScreenState();
}

class _OfficeServicesScreenState extends State<OfficeServicesScreen> {
  int? expandedIndex = 0;
  late String officeName;

  // Sample services data - you can expand this based on office
  late List<Map<String, dynamic>> services;

  @override
  void initState() {
    super.initState();
    officeName = widget.officeName;
    _loadServicesForOffice();
  }

  void _loadServicesForOffice() {
    // Load different services based on office name
    if (officeName.toLowerCase().contains('registry') || 
        officeName.toLowerCase().contains('civil')) {
      services = [
        {
          'name': 'Birth Certificate Request',
          'requirements': [
            'Valid government-issued ID',
            'Properly accomplished application form',
            'Payment of processing fee (₱155)',
            'Authorization letter (if not the person named in the document)',
          ],
        },
        {
          'name': 'Marriage Certificate Request',
          'requirements': [
            'Valid government-issued ID',
            'Properly accomplished application form',
            'Payment of processing fee (₱210)',
            'Authorization letter (if requesting for others)',
          ],
        },
        {
          'name': 'Death Certificate Request',
          'requirements': [
            'Valid government-issued ID',
            'Properly accomplished application form',
            'Payment of processing fee (₱155)',
            'Relationship proof (if not immediate family)',
          ],
        },
      ];
    } else if (officeName.toLowerCase().contains('business')) {
      services = [
        {
          'name': 'New Business Permit Application',
          'requirements': [
            'DTI Business Name Registration',
            'Barangay Business Clearance',
            'Location Clearance/Zoning Compliance',
            'Fire Safety Inspection Certificate',
            'Sanitary Permit (if applicable)',
            'Payment of fees and taxes',
          ],
        },
        {
          'name': 'Business Permit Renewal',
          'requirements': [
            'Previous year business permit',
            'Updated DTI Business Name Registration',
            'Barangay Business Clearance',
            'Payment of renewal fees and taxes',
          ],
        },
      ];
    } else if (officeName.toLowerCase().contains('treasury')) {
      services = [
        {
          'name': 'Real Property Tax Payment',
          'requirements': [
            'Tax Declaration',
            'Previous tax receipts',
            'Valid ID',
          ],
        },
        {
          'name': 'Business Tax Payment',
          'requirements': [
            'Business Permit',
            'Previous tax receipts',
            'Financial statements (if applicable)',
          ],
        },
      ];
    } else {
      // Default services
      services = [
        {
          'name': 'General Document Request',
          'requirements': [
            'Valid government-issued ID',
            'Properly accomplished application form',
            'Payment of processing fee',
          ],
        },
        {
          'name': 'Consultation Service',
          'requirements': [
            'Valid ID',
            'Appointment schedule (if required)',
          ],
        },
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Office Services'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Fixed back navigation
        ),
      ),
      body: Column(
        children: [
          // Office Name Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(15),
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
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.business_center,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        officeName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Available Services',
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
          
          // Services List
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 15),
              itemCount: services.length,
              itemBuilder: (context, index) {
                final service = services[index];
                final isExpanded = expandedIndex == index;
                
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: isExpanded ? Color(0xFFD4A574) : Colors.brown[700],
                    child: Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          title: Text(
                            service['name'],
                            style: TextStyle(
                              color: isExpanded ? Colors.black : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded ? Icons.expand_less : Icons.expand_more,
                            color: isExpanded ? Colors.black : Colors.white,
                            size: 28,
                          ),
                          onTap: () {
                            setState(() {
                              expandedIndex = isExpanded ? null : index;
                            });
                          },
                        ),
                        
                        if (isExpanded && service['requirements'].isNotEmpty) ...[
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.checklist,
                                      color: Colors.black87,
                                      size: 20,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'List of Requirements',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 15),
                                
                                Container(
                                  padding: EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: Colors.brown[300]!,
                                      width: 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: service['requirements'].map<Widget>((req) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(vertical: 4),
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              margin: EdgeInsets.only(top: 6),
                                              width: 6,
                                              height: 6,
                                              decoration: BoxDecoration(
                                                color: Colors.brown[700],
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                            SizedBox(width: 12),
                                            Expanded(
                                              child: Text(
                                                req,
                                                style: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  height: 1.4,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                                
                                SizedBox(height: 20),
                                
                                // Action Button
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Navigate to requirements checklist
                                      context.push('/requirements', extra: {
                                        'serviceName': service['name'],
                                        'requirements': service['requirements'],
                                        'officeName': officeName,
                                      });
                                    },
                                    icon: Icon(Icons.add_task, size: 18),
                                    label: Text(
                                      'ADD TO CHECKLIST',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.brown[800],
                                      foregroundColor: Colors.white,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(25),
                                      ),
                                      elevation: 4,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        
                        if (isExpanded && service['requirements'].isEmpty) ...[
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              'No specific requirements available for this service. Please contact the office for more information.',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}