import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  String _generateResetCode() {
    Random random = Random();
    return (100000 + random.nextInt(900000)).toString();
  }

  // Enhanced email sending function
  Future<bool> _sendResetCodeToEmail(String email, String code) async {
    try {
      // Simulate email sending process
      print('Sending reset code $code to $email');
      
      // In a real app, you would use a service like:
      // - Firebase Auth
      // - SendGrid
      // - AWS SES
      // - Your own backend API
      
      // Simulate network delay
      await Future.delayed(Duration(seconds: 2));
      
      // For demo purposes, always return true
      // In real implementation, handle actual email sending here
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }

  void _sendResetCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      String email = _emailController.text.trim();
      String resetCode = _generateResetCode();

      // Attempt to send email
      bool emailSent = await _sendResetCodeToEmail(email, resetCode);

      setState(() => _isLoading = false);

      if (emailSent) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.check_circle, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Reset code sent to your email!'),
                ),
              ],
            ),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );

        // Navigate to verification screen with proper GoRouter navigation
        context.push('/verify-reset-code', extra: {
          'email': email,
          'resetCode': resetCode,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(Icons.error, color: Colors.white),
                SizedBox(width: 8),
                Expanded(
                  child: Text('Failed to send email. Please try again.'),
                ),
              ],
            ),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenHeight < 700;

    return Scaffold(
      backgroundColor: Color(0xFFF5E6D3),
      appBar: AppBar(
        backgroundColor: Color(0xFFF5E6D3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => context.pop(), // Fixed navigation
        ),
        title: Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.08,
            vertical: 20,
          ),
          child: Column(
            children: [
              SizedBox(height: isSmallScreen ? 40 : 60),
              
              // Icon
              Container(
                width: isSmallScreen ? 120 : 140,
                height: isSmallScreen ? 120 : 140,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.black, width: 2),
                  color: Color(0xFFF5E6D3),
                ),
                child: Icon(Icons.lock_reset, size: isSmallScreen ? 60 : 70),
              ),
              
              SizedBox(height: isSmallScreen ? 20 : 30),
              
              // Title
              Text(
                'Reset Your Password',
                style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 28,
                    fontWeight: FontWeight.bold),
              ),
              
              SizedBox(height: 10),
              
              // Description
              Text(
                'Enter your email address and we\'ll send you a 6-digit verification code to reset your password',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: isSmallScreen ? 12 : 14, 
                    color: Colors.black54),
              ),
              
              SizedBox(height: isSmallScreen ? 40 : 60),
              
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // Email input
                    TextFormField(
                      controller: _emailController,
                      enabled: !_isLoading,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'EMAIL ADDRESS',
                        hintStyle: TextStyle(color: Colors.white54),
                        filled: true,
                        fillColor: Colors.grey[800],
                        prefixIcon: Icon(Icons.email_outlined,
                            color: Colors.white54),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        if (!_isValidEmail(value)) {
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: isSmallScreen ? 20 : 30),
                    
                    // Send button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendResetCode,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isLoading ? Colors.grey : Color(0xFFD4A574),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                          padding: EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: _isLoading
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                      strokeWidth: 2,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'SENDING...',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              )
                            : Text(
                                'SEND RESET CODE',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 40),
              
              // Help text
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue),
                    SizedBox(height: 8),
                    Text(
                      'Make sure to check your spam/junk folder if you don\'t receive the email within a few minutes.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.blue[800],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}