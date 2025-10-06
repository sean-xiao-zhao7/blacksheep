import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static Future sendEmail(recipients, subject, body) async {
    final message = Message()
      ..from = 'contact.us.blacksheep@gmail.com'
      ..recipients.add(recipients[0])
      ..subject = subject
      ..text = body;
    print(
      dotenv.env['EMAIL_FROM_MAILGUN']! + " " + dotenv.env['EMAIL_PW_MAILGUN']!,
    );

    final smtpServer = mailgun(
      dotenv.env['EMAIL_FROM_MAILGUN']!,
      dotenv.env['EMAIL_PW_MAILGUN']!,
    );

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (error) {
      print(error);
    }
  }
}
