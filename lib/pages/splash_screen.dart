import 'dart:async';
import 'package:flutter/material.dart';
import 'package:helaruth/constants/colors.dart';
import 'package:helaruth/constants/strings.dart';
import 'package:helaruth/constants/text_styles.dart';
import 'package:helaruth/services/version_api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String currentVersion = "1.0.0"; // App's current version (update manually)

  @override
  void initState() {
    super.initState();
    _checkVersionAndNavigate();
  }

  Future<void> _checkVersionAndNavigate() async {
    // Check for new version
    String? latestVersion = await VersionApiService().checkVersion();
    bool updateAvailable = latestVersion != null && latestVersion != currentVersion;

    // Navigate to HomePage after 3 seconds
    Timer(const Duration(seconds: 3), () {
      if (updateAvailable) {
        if (mounted) {
          _showUpdatePopup(latestVersion!);
        }
      } else {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      }
    });
  }

  void _showUpdatePopup(String newVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Update Available'),
        content: Text('A new version ($newVersion) is available. Update now to get the latest features!'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
            child: const Text('Later'),
          ),
          ElevatedButton(
            onPressed: () async {
              const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.example.helaruth'; // Replace with your Play Store URL
              if (await canLaunch(playStoreUrl)) {
                await launch(playStoreUrl);
              } else {
                print('Could not launch Play Store');
              }
              Navigator.pop(context);
              if (mounted) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            child: const Text('Update Now'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.spalshColor,
              AppColors.spalshColor,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 150,
                width: 150,
              ),
              const SizedBox(height: 20),
              Text(
                AppStrings.splashSubtitle,
                style: AppTextStyles.sinhala.copyWith(
                  fontSize: 35,
                  color: AppColors.spalshTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}