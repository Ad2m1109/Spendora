import 'package:flutter/material.dart';
import 'package:frontend/custom_scaffold.dart';
import 'package:frontend/sign_up_page.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/home_screen.dart';
import 'package:frontend/utils/user_preferences.dart';
import 'package:frontend/forgot_password_page.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package

class SignInPage extends StatefulWidget {
  final String? initialEmail;
  final String? initialPassword;

  const SignInPage({super.key, this.initialEmail, this.initialPassword});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '1094534390706-bjt8nkpk9hfkq8thcma1kff64k1rb8v2.apps.googleusercontent.com', // Updated client ID
    scopes: [
      'email',
      'profile',
    ],
  );

  bool rememberPassword = true;
  String errorMessage = '';
  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialEmail != null) {
      _emailController.text = widget.initialEmail!;
    }
    if (widget.initialPassword != null) {
      _passwordController.text = widget.initialPassword!;
    }
  }

  Future<void> _loadSavedCredentials() async {
    final savedCredentials = await UserPreferences.getRememberedCredentials();

    setState(() {
      _emailController.text = savedCredentials['email'];
      _passwordController.text = savedCredentials['password'];
      rememberPassword = savedCredentials['rememberMe'];
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Modified method to handle sign-in action and store user info
  Future<void> signInUser() async {
    if (_formSignInKey.currentState!.validate()) {
      try {
        final response = await ApiService.signIn(
            _emailController.text.trim(), _passwordController.text);

        // Store user information
        final userId = response['userId'].toString();
        final name =
            response['name']; // Assuming the API returns the user's name
        final email = _emailController.text.trim();
        final token =
            response['token']; // Ensure this matches your API response

        // Save user info and token
        await UserPreferences.saveUserInfo(userId, name, email);
        await UserPreferences.saveUserToken(token); // Save the token

        // Save credentials if remember me is checked
        await UserPreferences.saveRememberedCredentials(
            _emailController.text.trim(),
            _passwordController.text,
            rememberPassword);

        // Debug logs
        print('UserId saved: $userId');
        print('Token saved: $token');

        // Show success snackbar
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login successful")));

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } catch (e) {
        // Set error message
        setState(() {
          errorMessage = e.toString();
        });

        // Show error snackbar instead of displaying as text
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: $errorMessage'),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-in was canceled')),
        );
        return;
      }

      // Get user details from Google account
      final String? email = googleUser.email;

      // Populate the email field with the Google account email
      setState(() {
        _emailController.text = email ?? '';
      });

      // Notify the user to enter their password
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter your password to continue.')),
      );

      // Focus on the password field
      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      child: Column(
        children: [
          const Expanded(
            flex: 1,
            child: SizedBox(height: 10),
          ),
          Expanded(
            flex: 7,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 50, 25, 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignInKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Welcome Back!",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Email TextField
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your E-mail';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('E-mail'),
                          hintText: "Enter E-mail",
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Password TextField
                      TextFormField(
                        controller: _passwordController,
                        obscureText:
                            !_isPasswordVisible, // Use the state variable
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: "Enter Password",
                          hintStyle: const TextStyle(color: Colors.black54),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black45),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black38),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Remember me and Forgot Password row
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Remember Me Checkbox
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Transform.scale(
                                  scale: 0.9, // Make checkbox slightly smaller
                                  child: Checkbox(
                                    value: rememberPassword,
                                    onChanged: (bool? value) {
                                      setState(() {
                                        rememberPassword = value!;
                                      });
                                    },
                                  ),
                                ),
                                const Text(
                                  "Remember me",
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            // Forgot Password text
                            GestureDetector(
                              onTap: () {
                                // Navigate to Forgot Password Page
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordPage(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.blue, // Highlight color
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Sign In Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: signInUser,
                          child: const Text("Sign In"),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Sign in with Google icon
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _signInWithGoogle,
                            child: Image.asset(
                              'assets/google.png',
                              width: 38,
                              height: 38,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Sign Up navigation
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SignUpPage(),
                                ),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
