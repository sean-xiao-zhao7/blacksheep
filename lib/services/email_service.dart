import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Static class to send emails
class EmailService {
  /*
    Construct email data and metadata using Mailgun.
  */
  static Future sendEmail(recipients, subject, body) async {
    final message = Message()
      ..from = Address(dotenv.env['EMAIL_FROM_MAILGUN']!, 'BlackSheep')
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

  /*
    Mentee chat list initiates a connection between a new mentee and an existing mentor.
    This connection requires admin to approve from his/her single chat screen.
  */
  static sendNewMatchEmailAdmin({
    newMenteeName = 'Test mentee name',
    newMentorName = 'Test mentor name',
  }) {
    sendEmail(
      // [dotenv.env['EMAIL_ADMIN_RAY'], dotenv.env['EMAIL_ADMIN_SEAN']],
      [dotenv.env['EMAIL_ADMIN_SEAN']],
      'Approval needed for new connection',
      'Please log into the app as admin and apporve/reject this new connection:\n\nMentor: $newMentorName\nMentee: $newMenteeName\n\nFor admin username/password, please see Google Drive.',
    );
  }

  /*    
    Sent when admin approves a new phone connection, or changes a phone connection to another mentor.
  */
  static sendNewMatchPhoneMentor({
    newMenteeName = 'Asif Sajid (Test mentee)',
    phone = '416-123-1234',
    age = 42,
    mentorEmail = '',
  }) {
    sendEmail(
      [mentorEmail, dotenv.env['EMAIL_ADMIN_SEAN']],
      'Someone near you is in search of community',
      'Please contact:\n\nName: $newMenteeName\nPhone: $phone\nAge: $age\n\nPlease contact them within 48 hours of receiving this message.\n\nif you have any question, email: contact.us.blacksheep@gmail.com',
    );
  }
}
