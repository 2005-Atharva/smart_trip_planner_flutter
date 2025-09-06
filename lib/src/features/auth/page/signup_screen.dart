import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_trip_planner_flutter/src/core/constants/images.dart';
import 'package:smart_trip_planner_flutter/src/core/device/device.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/bloc/auth_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/bloc/obscuretext_bloc.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/widgets/auth_button.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/widgets/google_auth_button.dart';
import 'package:smart_trip_planner_flutter/src/features/auth/widgets/spacer_widget.dart';
import 'package:smart_trip_planner_flutter/src/features/chat/pages/chat_screen.dart';
import 'package:smart_trip_planner_flutter/src/features/home/pages/home_screeen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailControllers = TextEditingController();
  final TextEditingController _password1 = TextEditingController();
  final TextEditingController _password2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final height = MyDevices.getScreenHeight(context);
    final width = MyDevices.getScreenWidth(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 245, 245, 247),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.err),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 3),
              ),
            );
          }

          if (state is AuthSuccessState) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => HomeScreeen()),
            );
          }
        },
        builder: (context, state) {
          bool _isLoading2 = false;

          if (state is AuthLoading) {
            _isLoading2 = true;
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: height * 0.10), // 10%
                //header part
                HeaderS(width: width),
                SizedBox(height: height * 0.025), // 2.5%
                // title text
                Text(
                  "Create your Account",
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: height * 0.01), // 1%
                // subtitle text
                Text(
                  'Lets get started',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.blueGrey,
                  ),
                ),

                SizedBox(height: height * 0.04), // 7%
                // google button
                GoogleButton(
                  width: width,
                  onTap: () {},
                  title: "Sign in with Google",
                ),

                SizedBox(height: height * 0.03), // 4%
                // space widget
                SpacerWidget(title: "or Sign in with Email"),

                SizedBox(height: height * 0.04), // 10%
                // formfiled
                // Email Field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email address",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 3, 10, 23),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _emailControllers,
                        decoration: InputDecoration(
                          hintText: "john@example.com",
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Color.fromARGB(255, 143, 149, 178),
                          ),
                          hintStyle: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: const Color.fromARGB(255, 8, 23, 53),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                        ),
                      ),

                      SizedBox(height: height * 0.03),

                      // Password Field
                      Text(
                        "Password",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 3, 10, 23),
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<ObscuretextBloc, ObscuretextState>(
                        builder: (context, state) {
                          final obscureValue =
                              (state as ObscuretextInitial).value;
                          return TextFormField(
                            controller: _password1,
                            obscureText: obscureValue,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 8, 23, 53),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter your password",
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color.fromARGB(255, 143, 149, 178),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureValue
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color.fromARGB(
                                    255,
                                    143,
                                    149,
                                    178,
                                  ),
                                ),
                                onPressed: () {
                                  context.read<ObscuretextBloc>().add(
                                    ObscureButtonTapEvent(),
                                  );
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                            ),
                          );
                        },
                      ),

                      ////************************ */
                      SizedBox(height: height * 0.03),

                      // Password Field
                      Text(
                        "Confirm Password",
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: const Color.fromARGB(255, 3, 10, 23),
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<ObscuretextBloc, ObscuretextState>(
                        builder: (context, state) {
                          final obscureValue =
                              (state as ObscuretextInitial).value;
                          return TextFormField(
                            controller: _password2,
                            obscureText: obscureValue,
                            decoration: InputDecoration(
                              hintStyle: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: const Color.fromARGB(255, 8, 23, 53),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              hintText: "Enter your password",
                              prefixIcon: const Icon(
                                Icons.lock_outline,
                                color: Color.fromARGB(255, 143, 149, 178),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  obscureValue
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: const Color.fromARGB(
                                    255,
                                    143,
                                    149,
                                    178,
                                  ),
                                ),
                                onPressed: () {
                                  context.read<ObscuretextBloc>().add(
                                    ObscureButtonTapEvent(),
                                  );
                                },
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 2,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade400,
                                  width: 1,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16,
                                horizontal: 12,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: height * 0.03), // 6%
                // remember and forget

                // login
                AuthButton(
                  onTap: () {
                    context.read<AuthBloc>().add(
                      CreateWithMailButtonPressed(
                        email: _emailControllers.text.trim(),
                        password: _password1.text.trim(),
                        password2: _password2.text.trim(),
                      ),
                    );
                  },
                  title: "Sign Up",
                  loading: _isLoading2,
                ),

                SizedBox(height: height * 0.02), // 6%

                LowerSection(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class LowerSection extends StatelessWidget {
  const LowerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have a account? ",
          style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            'Sign In',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
      ],
    );
  }
}

class HeaderS extends StatelessWidget {
  const HeaderS({super.key, required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(MyImages.flightIcon),
        SizedBox(width: width * 0.03), // 3%
        Text(
          'Itinera AI',
          style: GoogleFonts.inter(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: const Color.fromARGB(255, 6, 95, 70),
          ),
        ),
      ],
    );
  }
}
