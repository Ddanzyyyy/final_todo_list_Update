import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:to_do_list_app/main.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();

  static isFirstTime() {}
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Welcome to To-Do List App!',
      'description': 'Atur tugas Anda dan pantau aktivitas harian Anda.',
      'images': 'assets/images/New notifications.gif',
    },
    {
      'title': 'Tambahkan Tugas dengan Mudah',
      'description': 'Buat tugas baru, tetapkan tanggal jatuh tempo, dan tandai sebagai selesai.',
      'images': 'assets/images/Profile Interface.gif',
    },
    {
      'title': 'Lihat Kemajuan Anda',
      'description': 'Lacak produktivitas Anda dan lihat tugas yang telah Anda selesaikan.',
      'images': 'assets/images/Mobile inbox.gif',
    },
  ];

  // Static method to check if this is the first time the app is opened
  static Future<bool> isFirstTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? firstTime = prefs.getBool('first_time');
    
    if (firstTime == null) {
      await prefs.setBool('first_time', false);
      return true;
    }
    return false;
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ToDoListScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          _onboardingData[index]['images'] ?? 'assets/images/default_image.png',
                          width: 450,
                          height: 450,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          _onboardingData[index]['title']!,
                          style: GoogleFonts.poppins(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20.0),
                        Text(
                          _onboardingData[index]['description']!,
                          style: GoogleFonts.poppins(
                            fontSize: 16.0,
                            color: Colors.grey,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => _buildIndicator(index == _currentPage),
              ),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _nextPage,
              child: Text(
                _currentPage == _onboardingData.length - 1 ? 'Mulai' : 'Next',
                style: GoogleFonts.poppins(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: isActive ? 12.0 : 8.0,
        height: 8.0,
        decoration: BoxDecoration(
          color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          borderRadius: BorderRadius.circular(4.0),
        ),
      ),
    );
  }
}
