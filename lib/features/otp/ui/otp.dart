import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/mainlogo/ui/main_logo_page.dart';
import 'package:flutter_application_1/features/otp/service/otp_service.dart';

class OtpOverlay extends StatefulWidget {
  final String email;

  OtpOverlay({required this.email});

  @override
  _OtpOverlayState createState() => _OtpOverlayState();
}

class _OtpOverlayState extends State<OtpOverlay> {
  final TextEditingController _otpController = TextEditingController();
  final OtpService _otpService = OtpService();
  bool _isVerifying = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFFFF9933)),
        title: Text(
          'OTP Verification',
          style: TextStyle(
                                    fontSize: screenWidth * 0.06,
                                    fontWeight: FontWeight.normal,
                                    fontFamily: 'Inter',
                                    color: Color(0xFFFF9933),
                                  ),
                                ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please enter the OTP sent to your email:',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xFFFF9933),
                  fontFamily: 'Inter',
                  fontSize: screenWidth * 0.03,
                  fontWeight: FontWeight.normal,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _otpController,
                decoration: InputDecoration(
                  labelText: 'OTP',
                  labelStyle: TextStyle(color: Color(0xFFFF9933)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFFF9933), width: 2.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12, width: 2.0),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
                style: TextStyle(color: Colors.black87),
                maxLength: 6,
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFFF9933),
                    padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.05,
                        vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ),
                    fixedSize: Size(
                        screenWidth * 0.8, screenHeight * 0.07),
                    shadowColor: Colors.black,
                    elevation: 10,
                  ),
                  onPressed: _isVerifying ? null : _verifyOtp,
                  child: _isVerifying
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                          'Verify OTP',
                          style: TextStyle(
                            fontSize: screenWidth * 0.06,
                            fontFamily: 'Inter',
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOtp() async {
    String enteredOtp = _otpController.text;

    if (enteredOtp.isNotEmpty && enteredOtp.length == 6) {
      setState(() {
        _isVerifying = true;
      });

      try {
        bool isVerified =
            await _otpService.verifyOtp(enteredOtp, widget.email);

        if (isVerified) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainLogoPage()),
          );
          _otpController.clear();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid OTP. Please try again.')),
          );
          _otpController.clear();
        }
      } catch (e) {
        print('Error during OTP verification: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred. Please try again.')),
        );
      } finally {
        setState(() {
          _isVerifying = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid OTP')),
      );
    }
  }
}
