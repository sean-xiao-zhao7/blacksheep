import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EmailService {
  static Future sendEmail(recipients, subject, body) async {
    final message = Message()
      ..from = Address(
        dotenv.env['EMAIL_FROM_MAILGUN']!,
        'BlackSheep Customer Support',
      )
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
    } on MailerException catch (_) {
      // print(error);
    }
  }

  static sendNewMatchEmailAdmin({
    newMenteeName = 'Test mentee name',
    newMentorName = 'Test mentor name',
  }) {
    sendEmail(
      // [dotenv.env['EMAIL_ADMIN_RAY'], dotenv.env['EMAIL_ADMIN_SEAN']],
      [dotenv.env['EMAIL_ADMIN_SEAN']],
      'New Connection in BlackSheep',
      'A new connection has been made in BlackSheep:\n\nMentor:$newMentorName\nMentee:$newMenteeName\n\nIf this is ok, nothing needs to be done. If not, you may sign into BlackSheep as Admin to change this connection.',
    );
  }

  static sendNewMatchPhoneMentor({
    newMenteeName = 'Asif Sajid (Test mentee)',
    phone = '416-123-1234',
    age = 42,
    mentorEmail = '',
  }) {
    sendEmail(
      // [dotenv.env['EMAIL_ADMIN_RAY'], dotenv.env['EMAIL_ADMIN_SEAN']],
      mentorEmail == ''
          ? [dotenv.env['EMAIL_ADMIN_SEAN'], dotenv.env['EMAIL_ADMIN_RAY']]
          : [mentorEmail],
      'Someone near you is in search of community',
      'Please contact:\n\nName: $newMenteeName\nPhone: $phone\nAge: $age\n\nPlease contact them within 48 hours of receiving this message.\n\nif you have any question, email: contact.us.blacksheep@gmail.com',
    );
  }
}
