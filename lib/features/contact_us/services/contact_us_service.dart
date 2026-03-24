import 'package:url_launcher/url_launcher.dart';
import '../models/contact_us_model.dart';

class ContactUsService {
  Future<void> launchContact(ContactUsModel contact) async {
    final Uri url;
    switch (contact.type) {
      case ContactType.phone:
        url = Uri.parse('tel:${contact.value}');
        break;
      case ContactType.whatsapp:
        // For WhatsApp, we use the specific whatsapp:// scheme or https://wa.me/
        url = Uri.parse('https://wa.me/${contact.value}');
        break;
      case ContactType.facebook:
      case ContactType.instagram:
      case ContactType.youtube:
        url = Uri.parse(contact.value);
        break;
    }

    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }
}
