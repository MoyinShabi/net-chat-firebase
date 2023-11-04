import 'package:ficonsax/ficonsax.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:net_chat_firebase/pages/chat_list_page.dart';
import 'package:net_chat_firebase/pages/upload_photo_page.dart';
import 'package:toastification/toastification.dart';

import '../widgets/auth_button.dart';
import '../widgets/custom_divider.dart';
import '../widgets/custom_textfield.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _firebase = FirebaseAuth.instance;

  final _form = GlobalKey<FormState>();
  bool _isLoginPage = true;
  bool _validate = false;
  bool _isSubmitting = false;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  void _submit() async {
    setState(() {
      _validate = true;
      _isSubmitting = true;
    });
    FocusManager.instance.primaryFocus?.unfocus();
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      setState(() {
        _isSubmitting = false;
      });
      return;
    }

    _form.currentState!.save();

    try {
      if (_isLoginPage) {
        final userCredentials = await _firebase.signInWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        print('LOGGED IN USER: $userCredentials');
        setState(() {
          _isSubmitting = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        toastification.show(
          context: context,
          alignment: Alignment.bottomCenter,
          icon: const Icon(
            IconsaxBold.shield_tick,
            color: Color(0xFF00B2FF),
          ),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          title: 'Logged in successfully!',
          autoCloseDuration: const Duration(seconds: 3),
          showProgressBar: false,
          borderRadius: BorderRadius.circular(12.0),
          closeButtonShowType: CloseButtonShowType.none,
          closeOnClick: false,
          dragToClose: true,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ChatListPage(),
          ),
        );
      } else {
        final userCredentials = await _firebase.createUserWithEmailAndPassword(
            email: _emailController.text, password: _passwordController.text);
        print('CREATED USER: $userCredentials');
        setState(() {
          _isSubmitting = false;
        });
        if (!mounted) return;
        ScaffoldMessenger.of(context).clearSnackBars();
        toastification.show(
          context: context,
          alignment: Alignment.bottomCenter,
          icon: const Icon(
            IconsaxBold.shield_tick,
            color: Color(0xFF00B2FF),
          ),
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          title: 'Account created successfully!',
          autoCloseDuration: const Duration(seconds: 3),
          showProgressBar: false,
          borderRadius: BorderRadius.circular(12.0),
          closeButtonShowType: CloseButtonShowType.none,
          closeOnClick: false,
          dragToClose: true,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                UploadPhotoPage(userCredentials: userCredentials),
          ),
        );
      }
    } on FirebaseAuthException catch (error) {
      setState(() {
        _isSubmitting = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).clearSnackBars();
      toastification.show(
        context: context,
        icon: const Icon(
          IconsaxBold.shield_cross,
          color: Colors.red,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.flat,
        title: error.message!,
        // description: 'Enter valid credentials',
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: false,
        borderRadius: BorderRadius.circular(12.0),
        closeButtonShowType: CloseButtonShowType.none,
        closeOnClick: false,
        dragToClose: true,
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
              child: Form(
                key: _form,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/logo.svg',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'NetChat',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    _isLoginPage
                        ? const SizedBox(height: 72)
                        : const SizedBox(height: 52),
                    Text(
                      _isLoginPage ? 'Welcome back!👋' : 'Create account',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _isLoginPage
                          ? 'Enter your details to continue'
                          : 'Enter your credentials to continue',
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (!_isLoginPage)
                      CustomTextField(
                        controller: _usernameController,
                        keyboard: TextInputType.name,
                        label: 'Username',
                        autovalidateMode: _validate
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        /*  validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Username can't be empty";
                          }
                          if (text.length < 6) {
                            return "Username must not be less than 6 characters";
                          }
                          return null;
                        }, */
                      ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailController,
                      keyboard: TextInputType.emailAddress,
                      label: 'Email address',
                      autovalidateMode: _validate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled,
                      validator: (text) {
                        // Regular expression to match a valid email address
                        final RegExp emailRegex = RegExp(
                          r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                        );
                        if (text == null || text.isEmpty) {
                          return "Email address can't be empty";
                        }
                        if (!emailRegex.hasMatch(text)) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordController,
                      keyboard: TextInputType.visiblePassword,
                      label: 'Password',
                      showVisibilityIcon: true,
                      /* autovalidateMode: _validate
                          ? AutovalidateMode.onUserInteraction
                          : AutovalidateMode.disabled, */
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (text) {
                        /* final lengthRegex = RegExp(r'^.{8,}$');
                        final upperAndLowerCaseRegex =
                            RegExp(r'^(?=.*[a-z])(?=.*[A-Z])');
                        final numberRegex = RegExp(r'^(?=.*\d)');
                        final specialCharacterRegex =
                            RegExp(r'^(?=.*[@$!%*?&])'); */
                        if (text == null || text.isEmpty) {
                          return "Password can't be empty";
                        }
                        if (text.length < 6) {
                          return "Password must not be less than 6 characters";
                        }
                        /* if (!lengthRegex.hasMatch(text)) {
                          return "Password must not be less than 8 characters";
                        }
                        if (!upperAndLowerCaseRegex.hasMatch(text)) {
                          return "Password must contain at least one uppercase and one lowercase letter";
                        }
                        if (!numberRegex.hasMatch(text)) {
                          return "Password must contain at least one number";
                        }
                        if (!specialCharacterRegex.hasMatch(text)) {
                          return "Password must contain at least one special character";
                        } */
                        return null;
                      },
                    ),
                    if (!_isLoginPage) const SizedBox(height: 16),
                    if (!_isLoginPage)
                      CustomTextField(
                        controller: _confirmPasswordController,
                        keyboard: TextInputType.visiblePassword,
                        label: 'Confirm Password',
                        showVisibilityIcon: true,
                        autovalidateMode: _validate
                            ? AutovalidateMode.onUserInteraction
                            : AutovalidateMode.disabled,
                        validator: (text) {
                          if (text == null || text.isEmpty) {
                            return "Password can't be empty";
                          }
                          if (text.length < 6) {
                            return "Password must not be less than 6 characters";
                          }
                          if (text != _passwordController.text) {
                            return "Password doesn't match";
                          }
                          return null;
                        },
                      ),
                    if (_isLoginPage)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              splashFactory: NoSplash.splashFactory,
                            ),
                            child: const Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Color(0xFF00B2FF),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    _isLoginPage
                        ? const SizedBox(height: 48)
                        : const SizedBox(height: 56),
                    AuthButton(
                      onPressed: _submit,
                      isSubmitting: _isSubmitting,
                      label: _isLoginPage ? 'Sign in' : 'Sign up',
                    ),
                    const SizedBox(height: 32),
                    const CustomDivider(),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {},
                          child: CircleAvatar(
                            radius: 32,
                            backgroundColor: const Color(0xFFF4F4F4),
                            child: SvgPicture.asset(
                              'assets/images/google_logo.svg',
                              width: 30,
                              height: 30,
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: const Color(0xFFF4F4F4),
                          child: SvgPicture.asset(
                            'assets/images/apple_logo.svg',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ],
                    ),
                    _isLoginPage
                        ? const SizedBox(height: 48)
                        : const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _isLoginPage
                              ? "Don't have an account?"
                              : 'Already have an account?',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _form.currentState!.reset();
                              _isSubmitting = false;
                              _isLoginPage = !_isLoginPage;
                              _validate = false;
                              _usernameController.clear();
                              _emailController.clear();
                              _passwordController.clear();
                              _confirmPasswordController.clear();
                            });
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            splashFactory: NoSplash.splashFactory,
                          ),
                          child: Text(
                            _isLoginPage ? 'Sign up' : 'Sign in',
                            style: const TextStyle(
                              color: Color(0xFF00B2FF),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
