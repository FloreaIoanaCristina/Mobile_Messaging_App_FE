import 'package:flutter/material.dart';
import 'package:messaging_mobile_app/sign_up_page.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'conversation_page.dart';

class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
          textTheme: const  TextTheme(
            headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textColor),
            bodyMedium: TextStyle(fontFamily: 'Inter',fontSize: 16, fontWeight: FontWeight.normal),
          ),

    ),
      home: LogInPage(),
    );
  }
}

class  LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              const Text(
                "Welcome\nBack!",
                style: TextStyle(
                  color: AppColors.textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              // Username/Email Field
              const TextField(
                  style: TextStyle(color: AppColors.textColor),
                  decoration: InputDecoration(
                hintText: "Username or Email",
                prefixIcon: Icon(Icons.person)
              )),
              const SizedBox(height: 20),
              // Password Field
              const TextField(
                style: TextStyle(color: AppColors.textColor),
                decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
              ),
                obscureText: true,
              ),
              const SizedBox(height: 10),
              // Forgot Password
              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: AppColors.accentColor,
                    fontSize: 14,
                  ),
                ),
              ),
              const Spacer(),
              // Sign In Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   TextButton(
                     onPressed:() => Navigator.push(context, MaterialPageRoute(builder:(context) => new SignUpPage())),
                   child: Text("Sign In",
                      style: TextStyle(
                        color: AppColors.textColor,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),)

                  ),
                  CircleAvatar(
                    backgroundColor: AppColors.accentColor,
                    radius: 25,
                    child: IconButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder:(context) => new ChatPage())),
                      icon: const Icon(
                        Icons.arrow_forward,
                        color:  AppColors.textColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
