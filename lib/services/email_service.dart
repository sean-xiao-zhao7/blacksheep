import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static sendEmail(recipients, subject, body) async {
    final message = Message()
      ..from = 'contact.us.blacksheep@gmail.com'
      ..recipients.add(recipients[0])
      ..subject = subject
      ..text = body;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (error) {
      print('Message not sent.');
      for (var p in error.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }
}
