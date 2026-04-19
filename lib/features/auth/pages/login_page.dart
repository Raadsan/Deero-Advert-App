import 'package:deero_enterprise_app/core/constant.dart';
import 'package:deero_enterprise_app/features/auth/controllers/user_provider.dart';
import 'package:deero_enterprise_app/features/auth/pages/forgot_password_page.dart';
import 'package:deero_enterprise_app/features/auth/pages/register_page.dart';
import 'package:deero_enterprise_app/features/client/Advert%20Features/pages/advert_navigationpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final Color primaryColor = const Color(0xff660E0D);
    final Color secondaryColor = const Color(0xffEF7044);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  primaryColor.withOpacity(0.08),
                  secondaryColor.withOpacity(0.05),
                  Colors.white,
                ],
              ),
            ),
          ),
          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Image.asset(fullAdvertLogo, height: 80),
                  const SizedBox(height: 30),
                  Text(
                    "Welcome Back",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  Text(
                    "Login to continue your journey",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  // Form Container
                  _buildInputField(
                    label: "Email",
                    hint: "Enter your email",
                    icon: LineIcons.envelope,
                    primaryColor: primaryColor,
                    onChanged: (value) => userProvider.setEmail(value),
                  ),
                  const SizedBox(height: 20),
                  _buildInputField(
                    label: "Password",
                    hint: "Enter your password",
                    icon: LineIcons.lock,
                    isPassword: true,
                    obscureText: _obscureText,
                    primaryColor: primaryColor,
                    onChanged: (value) => userProvider.setPassword(value),
                    onToggleVisibility: () => setState(() => _obscureText = !_obscureText),
                  ),
                  
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
                        );
                      },
                      child: Text(
                        "Forgot password?",
                        style: GoogleFonts.poppins(color: secondaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: userProvider.isLoading ? null : () async {
                        final success = await userProvider.login(context);
                        if (!context.mounted) return;
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Successful!"), backgroundColor: Colors.green),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) =>  AdvertNavigationpage()),
                            (route) => false,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(userProvider.loginError ?? "Login Failed"), backgroundColor: Colors.red),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        elevation: 0,
                      ),
                      child: userProvider.isLoading
                          ? const SizedBox(
                              height: 22,
                              width: 22,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              "Sign In",
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 25),
                  Row(
                    children: [
                       Expanded(child: Divider(color: Colors.grey.shade300)),
                       Padding(
                         padding: const EdgeInsets.symmetric(horizontal: 16),
                         child: Text("OR", style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 12)),
                       ),
                       Expanded(child: Divider(color: Colors.grey.shade300)),
                    ],
                  ),
                  const SizedBox(height: 25),
                  
                  // Google Sign In Button
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: OutlinedButton(
                      onPressed: userProvider.isLoading ? null : () async {
                        final success = await userProvider.signInWithGoogle(context);
                        if (!context.mounted) return;
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Signed in with Google!"), backgroundColor: Colors.green),
                          );
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => AdvertNavigationpage()),
                            (route) => false,
                          );
                        } else if (userProvider.loginError != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(userProvider.loginError!), backgroundColor: Colors.red),
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                        backgroundColor: Colors.white,
                      ),
                      child: userProvider.isLoading 
                        ? SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(color: secondaryColor, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.g_mobiledata_rounded, color: secondaryColor, size: 30),
                              const SizedBox(width: 8),
                              Text(
                                "Sign in with Google",
                                style: GoogleFonts.poppins(color: Colors.black, fontWeight: FontWeight.w600, fontSize: 15),
                              ),
                            ],
                          ),
                    ),
                  ),
                  
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have an account?", style: GoogleFonts.poppins(color: Colors.grey.shade600, fontSize: 13)),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterPage()),
                          );
                        },
                        child: Text(
                          "Now Sign Up",
                          style: GoogleFonts.poppins(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    required Color primaryColor,
    required Function(String) onChanged,
    VoidCallback? onToggleVisibility,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        TextField(
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.poppins(fontSize: 14, color: Colors.grey),
            prefixIcon: Icon(icon, color: Colors.grey.shade500, size: 20),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      obscureText ? LineIcons.eyeSlash : LineIcons.eye,
                      color: Colors.grey,
                    ),
                    onPressed: onToggleVisibility,
                  )
                : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: primaryColor, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
