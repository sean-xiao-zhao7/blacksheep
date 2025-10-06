import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class EmailService {
  static sendEmail(recipients, subject, body) async {
    try {
      // await send(body);
    } on MailerException catch (error) {
      return error;
    }
  }
}
