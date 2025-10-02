
// ...existing code...
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class OnboardingScreen extends StatefulWidget {
  final VoidCallback onComplete;

  const OnboardingScreen({Key? key, required this.onComplete}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int step = 1;
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final List<TextEditingController> otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> otpFocus = List.generate(6, (_) => FocusNode());

  @override
  void dispose() {
    phoneController.dispose();
    nameController.dispose();
    for (final c in otpControllers) c.dispose();
    for (final f in otpFocus) f.dispose();
    super.dispose();
  }

  void _handleOtpChange(int index, String val) {
    if (val.length > 1) val = val.substring(val.length - 1);
    otpControllers[index].text = val;
    if (val.isNotEmpty && index < otpFocus.length - 1) {
      otpFocus[index + 1].requestFocus();
    }
  }

  // Helper: common elegant background container
  Widget _withBackground(Widget child) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF0F172A), // deep slate
              Color(0xFF083344), // teal indigo mix
              Color(0xFF6D28D9), // violet accent
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.6, 1.0],
          ),
        ),
        child: SafeArea(child: child),
      ),
    );
  }

  Widget _buildStep1(BuildContext context, ThemeProvider? themeProvider) {
    final isDark = themeProvider?.isDarkMode ?? false;

    return _withBackground(
      Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(isDark ? Icons.dark_mode : Icons.light_mode, color: Colors.white70),
                onPressed: themeProvider == null ? null : () => themeProvider.toggleTheme(),
              ),
            ),
            const SizedBox(height: 8),

            // ===== Logo placeholder (user-supplied) =====
            // Place your logo image at: assets/images/ndalaflow_logo.png
            SizedBox(
              width: 96,
              height: 96,
              child: ClipOval(
                child: Image.asset(
                  'assets/images/ndalaflow_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // If asset not found, show a neutral fallback; user can replace asset later.
                    return Container(
                      color: Colors.white.withOpacity(0.06),
                      alignment: Alignment.center,
                      child: Icon(Icons.account_balance_wallet, size: 40, color: isDark ? Colors.white70 : Colors.white70),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            const Text('NdalaFlow', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(height: 8),
            const Text('Yendetsani ndalama zanu molingalira', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => step = 2),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: Colors.white.withOpacity(0.12),
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign up with Phone'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () => setState(() => step = 3),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(56),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                side: BorderSide(color: Colors.white.withOpacity(0.12)),
                foregroundColor: Colors.white,
              ),
              child: const Text('Sign up with Email'),
            ),
            TextButton(onPressed: widget.onComplete, child: const Text('Continue as Guest', style: TextStyle(color: Colors.white70))),
          ]),
        ),
      ),
    );
  }

  Widget _buildStep2(BuildContext context) {
    return _withBackground(
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [BackButton(color: Colors.white, onPressed: () => setState(() => step = 1)), const SizedBox(width: 8), const Text('Enter Phone Number', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))]),
          const SizedBox(height: 16),
          TextField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintText: '0881 234 567',
              filled: true,
              fillColor: Colors.white.withOpacity(0.06),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              hintStyle: TextStyle(color: Colors.white70),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: phoneController.text.trim().length >= 9 ? () => setState(() => step = 4) : null,
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), backgroundColor: Colors.white.withOpacity(0.12), foregroundColor: Colors.white),
            child: const Text('Send Code'),
          ),
        ]),
      ),
    );
  }

  Widget _buildStep3(BuildContext context) {
    return _withBackground(
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [BackButton(color: Colors.white, onPressed: () => setState(() => step = 1)), const SizedBox(width: 8), const Text('Create Account', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))]),
          const SizedBox(height: 16),
          TextField(controller: nameController, decoration: InputDecoration(hintText: 'Full Name', filled: true, fillColor: Colors.white.withOpacity(0.06), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), hintStyle: TextStyle(color: Colors.white70)), style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          TextField(decoration: InputDecoration(hintText: 'Email Address', filled: true, fillColor: Colors.white.withOpacity(0.06), border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none), hintStyle: TextStyle(color: Colors.white70)), keyboardType: TextInputType.emailAddress, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 12),
          ElevatedButton(onPressed: widget.onComplete, style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: Colors.white.withOpacity(0.12), foregroundColor: Colors.white), child: const Text('Create Account')),
        ]),
      ),
    );
  }

  Widget _buildStep4(BuildContext context) {
    return _withBackground(
      Padding(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          Row(children: [BackButton(color: Colors.white, onPressed: () => setState(() => step = 2)), const SizedBox(width: 8), const Text('Enter Verification Code', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))]),
          const SizedBox(height: 16),
          Text('Code sent to ${phoneController.text}', style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 16),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(6, (i) {
            return Container(
              width: 44,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: TextField(
                controller: otpControllers[i],
                focusNode: otpFocus[i],
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                decoration: const InputDecoration(counterText: ''),
                style: const TextStyle(color: Colors.white),
                onChanged: (v) => _handleOtpChange(i, v),
              ),
            );
          })),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: otpControllers.any((c) => c.text.isEmpty) ? null : widget.onComplete,
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(52), backgroundColor: Colors.white.withOpacity(0.12), foregroundColor: Colors.white),
            child: const Text('Verify & Continue'),
          ),
          TextButton(onPressed: () {/* resend */}, child: const Text('Resend Code', style: TextStyle(color: Colors.white70))),
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider?>(context, listen: false);
    switch (step) {
      case 1:
        return _buildStep1(context, themeProvider);
      case 2:
        return _buildStep2(context);
      case 3:
        return _buildStep3(context);
      case 4:
        return _buildStep4(context);
      default:
        return _buildStep1(context, themeProvider);
    }
  }
}
// ...existing code...