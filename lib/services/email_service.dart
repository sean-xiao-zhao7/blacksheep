import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static Future sendEmail(recipients, subject, body) async {
    final message = Message()
      ..from = Address('contact.us.blacksheep@gmail.com', 'BlackSheep')
      ..recipients.addAll(recipients)
      ..subject = subject
      ..text = body;

    final smtpServer = mailgun(
      dotenv.env['EMAIL_FROM_MAILGUN']!,
      dotenv.env['EMAIL_PW_MAILGUN']!,
    );

    try {
      await send(message, smtpServer);
      // print('Message sent: ${sendReport.toString()}');
    } on MailerException catch (error) {
      // print(error);
    }
  }

  static sendNewMatchEmail({
    newMenteeName = 'Test mentee name',
    newMentorName = 'Test mentor name',
  }) {
    sendEmail(
      // [dotenv.env['EMAIL_ADMIN_RAY'], dotenv.env['EMAIL_ADMIN_SEAN']],
      [dotenv.env['EMAIL_ADMIN_SEAN']],
      'New Match in Blacksheep',
      'A new match has been made in Blacksheep between the following 2 people:\n\nMentor:$newMentorName\nMentee:$newMenteeName\n\nIf this is ok, nothing needs to be done. If not, you may sign into Blacksheep as Admin to change this match.',
    );
  }
}
