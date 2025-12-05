import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Static class to send emails
class EmailService {
  static Future sendEmail(recipients, subject, body) async {
    // Construct email data and metadata using Mailgun.

    final message = Message()
      ..from = Address(
        dotenv.env['EMAIL_FROM_MAILGUN']!,
        dotenv.env['APP_NAME'],
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
    // Mentee chat list initiates a connection between a new mentee and an existing mentor.
    // This connection requires admin to approve from his/her single chat screen.
    newMenteeName = 'Test mentee name',
    newMentorName = 'Test mentor name',
  }) {
    sendEmail(
      [dotenv.env['EMAIL_ADMIN_RAY'], dotenv.env['EMAIL_ADMIN_SEAN']],
      'Approval needed for new connection',
      'Please log into the app as admin and apporve/reject this new connection:\n\nMentor: $newMentorName\nMentee: $newMenteeName\n\nFor admin username/password, please see Google Drive.',
    );
  }

  static sendNewMatchPhoneMentor({
    //  Sent when admin approves a new phone connection, or changes a phone connection to another mentor.
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

  static sendReportEmail(
    String menteeFirstName,
    String mentorFirstName,
    String message,
  ) {
    // mentee reports mentor to admin

    final recipients = [
      dotenv.env['EMAIL_FROM_GMAIL'],
      [dotenv.env['EMAIL_ADMIN_RAY'], dotenv.env['EMAIL_ADMIN_SEAN']],
    ];
    final subject = 'Mentor reported by mentee';
    final emailBody =
        'Mentee $menteeFirstName has reported mentor $mentorFirstName\n\nMessage from mentee:\n\n$message';
    EmailService.sendEmail(recipients, subject, emailBody);
  }
}
