import 'package:flutter/material.dart';
import 'package:frontend/custom_scaffold.dart';
import 'package:frontend/sign_up_page.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/home_screen.dart';
import 'package:frontend/utils/user_preferences.dart'; 

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formSignInKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool rememberPassword = true;
  String errorMessage = '';

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
        final userId = response['userId'];
        final name = response['name']; // Assuming the API returns the user's name
        final email = _emailController.text.trim();

        // Save user info
        await UserPreferences.saveUserInfo(userId, name, email);

        // Clear any previous error messages
        setState(() {
          errorMessage = '';
        });

        // Show success snackbar
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Login successful")));

        // Navigate to HomeScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      } catch (e) {
        setState(() {
          errorMessage = e.toString();
        });

        // Show error snackbar
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: $errorMessage'),
          backgroundColor: Colors.red,
        ));
      }
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
                  )),
              child: Form(
                key: _formSignInKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
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
                            borderSide:
                            const BorderSide(color: Colors.black38)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Password TextField
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
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
                            borderSide:
                            const BorderSide(color: Colors.black38)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    // Remember me and Forgot Password row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Checkbox(
                          value: rememberPassword,
                          onChanged: (bool? value) {
                            setState(() {
                              rememberPassword = value!;
                            });
                          },
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 100, 0),
                          child: const Text(
                            "Remember me",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            // TODO: Implement forgot password functionality
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
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
                    // Error Message
                    if (errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          errorMessage,
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
          )
        ],
      ),
    );
  }
}