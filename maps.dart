import 'package:flutter/material.dart';

class MapsScreen extends StatefulWidget {
  @override
  _MapsScreenState createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _showOfficeInfo = false;
  bool _showNavigation = false;
  String _selectedOffice = 'Office of the Mayor';
  FocusNode _searchFocus = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
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
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle, color: Colors.black),
            onPressed: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Open drawer functionality
          },
        ),
      ),
      body: Column(
        children: [
          // Stable Tab Bar
          Container(
            color: Color(0xFFF5E6D3),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.black, width: 2),
                      ),
                    ),
                    child: Text(
                      'Maps',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Departments',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Main Map Area
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
                
                // Current Location Marker - Always visible
                Positioned(
                  bottom: 150,
                  left: MediaQuery.of(context).size.width * 0.45,
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.my_location,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                
                // Quick Access Buttons - Always visible at top
                Positioned(
                  top: 20,
                  left: 20,
                  right: 20,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildQuickAccessButton('Mayor\'s Office', Icons.account_balance),
                      _buildQuickAccessButton('Registry', Icons.assignment),
                      _buildQuickAccessButton('Treasury', Icons.account_balance_wallet),
                    ],
                  ),
                ),
                
                // Office Info Panel - Appears when office is selected
                if (_showOfficeInfo && !_showNavigation)
                  Positioned(
                    top: 80,
                    left: 20,
                    right: 20,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.brown[700],
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
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
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.location_city,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  _selectedOffice,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.close, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _showOfficeInfo = false;
                                  });
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: 12),
                          Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white70, size: 18),
                              SizedBox(width: 8),
                              Text(
                                'Your Current Location → $_selectedOffice',
                                style: TextStyle(color: Colors.white70, fontSize: 14),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Available Routes',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 8),
                          _buildRouteOption('5 mins walk', Icons.directions_walk),
                          SizedBox(height: 4),
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
          
          // Bottom Fixed Controls - Always visible
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: [
                // Search Bar - Always visible
                Expanded(
                  child: Container(
                    height: 50,
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
                        hintStyle: TextStyle(color: Colors.white70, fontSize: 14),
                        filled: true,
                        fillColor: Colors.brown[700],
                        prefixIcon: Icon(Icons.search, color: Colors.white70),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: Icon(Icons.clear, color: Colors.white70),
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
                        contentPadding: EdgeInsets.symmetric(horizontal: 20),
                      ),
                      style: TextStyle(color: Colors.white, fontSize: 14),
                      onChanged: (value) {
                        setState(() {}); // Update to show/hide clear button
                      },
                    ),
                  ),
                ),
                SizedBox(width: 15),
                
                // AR Button - Always visible
                Container(
                  width: 50,
                  height: 50,
                  child: FloatingActionButton(
                    onPressed: _showARView,
                    backgroundColor: Colors.brown[700],
                    elevation: 4,
                    child: Icon(
                      Icons.view_in_ar,
                      color: Colors.white,
                      size: 24,
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? Colors.brown[700] 
              : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon, 
              size: 16, 
              color: isSelected ? Colors.white : Colors.brown[700]
            ),
            SizedBox(width: 4),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
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
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 12),
            // Route line dots
            Row(
              children: List.generate(8, (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 1),
                width: 6,
                height: 6,
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
                fontSize: 14,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 14),
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
            padding: EdgeInsets.all(20),
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
                SizedBox(width: 20),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'AR NAVIGATION - Point camera to see office names',
                      textAlign: TextAlign.center,
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
                  // AR Office Labels
                  Positioned(
                    left: 50,
                    top: 100,
                    child: _buildARLabel('Registry Office'),
                  ),
                  Positioned(
                    right: 50,
                    top: 150,
                    child: _buildARLabel('Treasury'),
                  ),
                  Positioned(
                    left: 30,
                    bottom: 200,
                    child: _buildARLabel('Mayor\'s Office'),
                  ),
                  
                  // AR Navigation Path
                  Positioned(
                    bottom: 120,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      child: CustomPaint(
                        painter: ARPathPainter(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Navigation Instructions
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.turn_right, color: Colors.white, size: 28),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Navigate to $_selectedOffice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Turn right in 16 meters',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 60,
                  height: 60,
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
                        fontSize: 14,
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
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.cyan, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.cyan,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showARView() {
    setState(() {
      _showNavigation = true;
    });
  }
}

// Map Painter - Simplified and more stable
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
        Rect.fromLTWH(50, 80, 120, 100),
        Radius.circular(8),
      ),
      paint,
    );
    
    // Registry
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(190, 60, 100, 80),
        Radius.circular(8),
      ),
      paint,
    );
    
    // Treasury
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(310, 90, 80, 90),
        Radius.circular(8),
      ),
      paint,
    );
    
    // Additional buildings
    paint.color = Colors.brown[200]!;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(30, 200, 150, 80),
        Radius.circular(8),
      ),
      paint,
    );
    
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(200, 180, 120, 100),
        Radius.circular(8),
      ),
      paint,
    );
    
    // Walkways
    paint.color = Colors.grey[300]!;
    paint.strokeWidth = 6;
    
    // Main horizontal path
    canvas.drawLine(
      Offset(0, size.height * 0.5), 
      Offset(size.width, size.height * 0.5), 
      paint
    );
    
    // Vertical connectors
    canvas.drawLine(
      Offset(size.width * 0.3, 0), 
      Offset(size.width * 0.3, size.height), 
      paint
    );
    canvas.drawLine(
      Offset(size.width * 0.7, 0), 
      Offset(size.width * 0.7, size.height), 
      paint
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

// AR Path Painter
class ARPathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyan
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;

    final path = Path();
    path.moveTo(size.width * 0.5, size.height);
    path.quadraticBezierTo(
      size.width * 0.3, size.height * 0.6,
      size.width * 0.2, 0,
    );
    
    canvas.drawPath(path, paint);
    
    // Arrow indicator
    paint.style = PaintingStyle.fill;
    final arrowPath = Path();
    arrowPath.moveTo(size.width * 0.2 - 8, 12);
    arrowPath.lineTo(size.width * 0.2, 0);
    arrowPath.lineTo(size.width * 0.2 + 8, 12);
    arrowPath.close();
    canvas.drawPath(arrowPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}