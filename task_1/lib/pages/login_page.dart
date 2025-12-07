import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:icons_plus/icons_plus.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final focusNode = FocusNode();
  bool isObscure = true;
  bool isChecked = false;
  final formKey = GlobalKey<FormState>();
  bool emailValid = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text('Welcome Back!', style: Theme.of(context).textTheme.headlineLarge),
                SizedBox(height: 10),
                Text("Let's Login to explore more", style: Theme.of(context).textTheme.bodyMedium),
                SizedBox(height: 10),
                Image.asset(
                  'assets/img.png',
                  height: 100,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 10),
                Text('ScaleUp Ads Agency', style: GoogleFonts.asapCondensed(fontSize: 32, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onPrimary)),
                SizedBox(height: 20),
                Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email or Phone Number', style: Theme.of(context).textTheme.labelLarge),
                      SizedBox(height: 10),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          final emailRegex = RegExp(
                              r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$'
                          );
                          if (emailRegex.hasMatch(value)) {
                            setState(() {
                              emailValid = true;
                            });
                          } else {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                        onFieldSubmitted: (value) {
                          focusNode.requestFocus();
                        },
                        onChanged: (value) {
                          setState(() {
                            final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
                            emailValid = value.isNotEmpty && emailRegex.hasMatch(value);
                          });
                        },
                        decoration: InputDecoration(
                          fillColor: Theme.of(context).colorScheme.onSurface,
                          filled: true,
                          hintText: 'Enter your email',
                          hintStyle: Theme.of(context).textTheme.bodyMedium,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                          ),
                          prefixIcon: Icon(Icons.email_outlined, color: Theme.of(context).colorScheme.primary),
                          suffixIcon: emailValid ? Icon(Icons.check_circle, color: Theme.of(context).colorScheme.primary) : null
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 10),
                      Text('Password', style: Theme.of(context).textTheme.labelLarge),
                      SizedBox(height: 10),
                      TextFormField(
                        focusNode: focusNode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a password';
                          }
                          if (value.length < 6) {
                            return 'Password must be at least 6 characters';
                          }
                          if (!value.contains(RegExp(r'[0-9]'))) {
                            return 'Password must contain a number';
                          }
                          if (!value.contains(RegExp(r'[A-Z]'))) {
                            return 'Password must contain uppercase letter';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            fillColor: Theme.of(context).colorScheme.onSurface,
                            filled: true,
                            hintText: 'Enter your password',
                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                            ),
                            prefixIcon: Icon(Icons.lock_outline, color: Theme.of(context).colorScheme.primary),
                            suffixIcon: IconButton(
                              icon: Icon(isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined, color: Theme.of(context).colorScheme.error,),
                              onPressed: () {
                                setState(() {
                                  isObscure = !isObscure;
                                });
                              },
                            )
                        ),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.black),
                        keyboardType: TextInputType.emailAddress,
                        obscureText: isObscure,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Checkbox(value: isChecked,
                            onChanged: (value) {
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Colors.white,
                            side: BorderSide(width: 1, color: Theme.of(context).colorScheme.error),
                            visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                          ),
                          Text('Remember Me', style: Theme.of(context).textTheme.labelMedium),
                          Spacer(),
                          TextButton(
                            onPressed: () {},
                            child: Text('Forgot Password?', style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                            )),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 15),
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                  title: Text('Login Successful', style: Theme.of(context).textTheme.headlineMedium),
                                  content: Text('You have successfully logged in. You are ready to explore.', style: Theme.of(context).textTheme.bodyMedium),
                                  actions: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        padding: EdgeInsets.symmetric(vertical: 15),
                                        minimumSize: Size(double.infinity, 50),
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text('OK', style: Theme.of(context).textTheme.labelLarge)
                                    )
                                  ],
                                );
                              }
                            );
                            formKey.currentState!.reset();
                          }
                        },
                        child: Text('Login', style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    Text(
                      'You can connect with', style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: Brand(Brands.facebook, size: 56,),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 16),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Brand(Brands.google, size: 56,),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 16),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Brand(Brands.apple_logo, size: 56,),
                      padding: EdgeInsets.symmetric(horizontal: 2, vertical: 16),
                    ),
                  ],
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Don\'t have an account?', style: Theme.of(context).textTheme.labelLarge),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 2, vertical: 0),
                          minimumSize: Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text('Sign Up here', style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        )),
                      )
                    ]
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
