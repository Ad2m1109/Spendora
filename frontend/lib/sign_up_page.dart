import 'package:flutter/material.dart';
import 'package:frontend/custom_scaffold.dart';
import 'package:frontend/sign_in_page.dart';
import 'package:frontend/services/api_service.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign In package

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formSignupKey = GlobalKey<FormState>();
  bool agreePersonalData = true;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Initialize GoogleSignIn
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    clientId:
        '1094534390706-bjt8nkpk9hfkq8thcma1kff64k1rb8v2.apps.googleusercontent.com', // Updated client ID
    scopes: [
      'email',
      'profile',
    ],
  );

  String errorMessage = '';
  String nameError = '';
  String emailError = '';
  String passwordError = '';
  bool _isPasswordVisible = false; // Add this state variable

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Pre-fill data if provided via arguments
    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args != null) {
      _fullNameController.text = args['name'] ?? '';
      _emailController.text = args['email'] ?? '';
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool isValidName(String name) {
    return name.length > 5;
  }

  bool isValidEmail(String email) {
    return email.contains('@') && email.contains('.') && email.length > 9;
  }

  bool isValidPassword(String password) {
    final hasUppercase = password.contains(RegExp(r'[A-Z]'));
    final hasLowercase = password.contains(RegExp(r'[a-z]'));
    final hasDigits = password.contains(RegExp(r'[0-9]'));
    return hasUppercase && hasLowercase && hasDigits && password.length > 7;
  }

  // Updated method to handle Google sign-up
  Future<void> _signUpWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in process
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Google sign-up was canceled')),
        );
        return;
      }

      // Get user details from Google account
      final String? displayName = googleUser.displayName;
      final String? email = googleUser.email;

      // Check if the user already exists
      final userExists = await ApiService.checkUserExists(email!);

      if (userExists) {
        // Navigate to SignInPage and pre-fill the email field
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Complete your password.')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(initialEmail: email),
          ),
        );
        return;
      }

      // Populate the form fields with Google account data
      setState(() {
        _fullNameController.text = displayName ?? 'Google User';
        _emailController.text = email;
        _passwordController.text = ''; // Leave password empty for user to fill
      });

      // Notify the user to complete the form
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete your password.')),
      );
    } catch (e) {
      setState(() {
        errorMessage = 'Google sign-up error: ${e.toString()}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google sign-up error: $e')),
      );
    }
  }

  Future<void> _verifyEmail(
      String email, String code, String expectedCode) async {
    try {
      final response = await ApiService.verifyEmail(
          email, code, expectedCode); // Pass all required arguments
      if (response) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Email verified successfully')),
        );
        // Proceed to the next step or navigate to the sign-in page
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid verification code')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Verification failed: $e')),
      );
    }
  }

  Future<String> _sendVerificationEmail(String email) async {
    try {
      // Generate a random 6-character verification code
      final verificationCode = List.generate(6, (index) {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
        return chars[
            (DateTime.now().millisecondsSinceEpoch + index) % chars.length];
      }).join();

      await ApiService.sendVerificationEmail(email, verificationCode);
      return verificationCode;
    } catch (e) {
      throw Exception('Failed to send verification email: $e');
    }
  }

  Future<void> _showVerificationDialog(
      String email, String expectedCode) async {
    final TextEditingController _codeController = TextEditingController();
    bool isVerified = false;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Email Verification'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Enter the 6-digit code sent to your email.'),
              TextField(
                controller: _codeController,
                keyboardType: TextInputType.number,
                decoration:
                    const InputDecoration(hintText: 'Verification Code'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                try {
                  final isValid = await ApiService.verifyEmail(
                    email,
                    _codeController.text.trim(),
                    expectedCode, // Pass expectedCode here
                  );
                  if (isValid) {
                    isVerified = true;
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Invalid verification code')),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Verification failed: $e')),
                  );
                }
              },
              child: const Text('Verify'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );

    if (!isVerified) {
      throw Exception('Verification failed or canceled');
    }
  }

  Future<void> _signUp() async {
    setState(() {
      nameError = '';
      emailError = '';
      passwordError = '';
    });

    if (_formSignupKey.currentState!.validate() && agreePersonalData) {
      if (!isValidName(_fullNameController.text.trim())) {
        setState(() {
          nameError = 'Name must be more than 5 characters';
        });
        return;
      }

      if (!isValidEmail(_emailController.text.trim())) {
        setState(() {
          emailError = 'Invalid email format';
        });
        return;
      }

      if (!isValidPassword(_passwordController.text.trim())) {
        setState(() {
          passwordError =
              'Password must contain upper and lower case letters, numbers, and be more than 7 characters';
        });
        return;
      }

      try {
        // Check if the user already exists
        final userExists = await ApiService.checkUserExists(
          _emailController.text.trim(),
        );

        if (userExists) {
          // Redirect to SignInPage
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('You already have an account.')),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => SignInPage(
                initialEmail: _emailController.text,
              ),
            ),
          );
          return;
        }

        // Send verification email and show dialog
        final verificationCode =
            await _sendVerificationEmail(_emailController.text.trim());
        await _showVerificationDialog(
            _emailController.text.trim(), verificationCode);

        // Proceed with signup if verification is successful
        await ApiService.addUser({
          'fullName': _fullNameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sign-up successful!')),
        );

        // Navigate to SignInPage and populate inputs
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInPage(
              initialEmail: _emailController.text,
            ),
          ),
        );
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign-up failed: $e')),
        );
      }
    } else if (!agreePersonalData) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please agree to the Terms and Conditions')),
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
            flex: 10,
            child: Container(
              padding: const EdgeInsets.fromLTRB(25.0, 50.0, 25.0, 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40.0),
                  topRight: Radius.circular(40.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _formSignupKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 40),
                      // Full name
                      TextFormField(
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Full name';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Full Name'),
                          hintText: 'Enter Full Name',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: nameError.isNotEmpty ? nameError : null,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Email
                      TextFormField(
                        controller: _emailController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Email';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Email'),
                          hintText: 'Enter Email',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText: emailError.isNotEmpty ? emailError : null,
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText:
                            !_isPasswordVisible, // Use the state variable
                        obscuringCharacter: '*',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter Password';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: 'Enter Password',
                          hintStyle: const TextStyle(color: Colors.black26),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.black12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorText:
                              passwordError.isNotEmpty ? passwordError : null,
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
                      // Agree to terms
                      Row(
                        children: [
                          Checkbox(
                            value: agreePersonalData,
                            onChanged: (bool? value) {
                              setState(() {
                                agreePersonalData = value!;
                              });
                            },
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'I agree to the Terms and ',
                            style: TextStyle(color: Colors.black45),
                          ),
                          Text(
                            'Conditions',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Signup button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signUp,
                          child: const Text('Sign up'),
                        ),
                      ),
                      const SizedBox(height: 30),
                      // Sign up with dividers
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              'Sign up with',
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Expanded(
                            child: Divider(
                              thickness: 0.7,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      // Social media logos with tap functionality
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Google logo with tap functionality
                          GestureDetector(
                            onTap: _signUpWithGoogle,
                            child: Image.asset(
                              'assets/google.png',
                              width: 38,
                              height: 38,
                            ),
                          ),
                          // Removed Facebook logo
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Already have an account
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Already have an account? ',
                              style: TextStyle(color: Colors.black45)),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const SignInPage()),
                              );
                            },
                            child: Text('Sign in',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
