import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:messaging_mobile_app/repos/accounts_repo.dart';
import 'package:messaging_mobile_app/repos/conversations_repo.dart';
import 'package:messaging_mobile_app/services/messaging_service.dart';
import 'package:messaging_mobile_app/style/colors.dart';
import 'package:provider/provider.dart';
import 'log_in_page.dart';

Future<void> main() async{
  await dotenv.load(fileName: ".env"); // Load .env file
  final baseUrl = dotenv.env['API_BASE_URL'] ?? 'http://default_base_url';
  if (baseUrl == 'http://default_base_url') {
    print('API_BASE_URL is missing from the .env file!');
  }
  final authService = AuthService(baseUrl: baseUrl);
  final conversationsService = ConversationsService(baseUrl: baseUrl);// Initialize AuthService with baseUrl

  runApp(

    MultiProvider(
      providers: [
        Provider<AuthService>.value(value: authService),
        Provider<ConversationsService>.value(value: conversationsService),
        ChangeNotifierProvider(create: (context) => MessagingService())
      ],
      child:  MessagingApp(),
    ),
  );
}


class MessagingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final messagingService = Provider.of<MessagingService>(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Messaging App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: const  TextTheme(
          headlineLarge: TextStyle(fontFamily: 'Inter', fontSize: 40, fontWeight: FontWeight.bold, color: AppColors.textColor),
          bodyMedium: TextStyle(fontFamily: 'Inter',fontSize: 16, fontWeight: FontWeight.normal,color: AppColors.textColor),
        ),

      ),
      home: LogInPage(),
    );
  }
}
