import '../models/contact_us_model.dart';

abstract class ContactUsRepository {
  List<ContactUsModel> getContactOptions();
}

class ContactUsRepositoryImpl implements ContactUsRepository {
  @override
  List<ContactUsModel> getContactOptions() {
    return const [
      ContactUsModel(
        title: 'اتصل بنا',
        value: '0123456789',
        type: ContactType.phone,
        iconPath: 'assets/home/phone.png', // I'll assume this exists or use a fallback
      ),
      ContactUsModel(
        title: 'للتواصل واتس اب',
        value: '20123456789',
        type: ContactType.whatsapp,
        iconPath: 'assets/home/whatsapp.png',
      ),
      ContactUsModel(
        title: 'تابعنا على الفيسبوك',
        value: 'https://facebook.com/elebtkar',
        type: ContactType.facebook,
        iconPath: 'assets/home/facebook.png',
      ),
      ContactUsModel(
        title: 'تابعنا على الانستجرام',
        value: 'https://instagram.com/elebtkar',
        type: ContactType.instagram,
        iconPath: 'assets/home/instgram.png', // matching the typo in assets
      ),
      ContactUsModel(
        title: 'تابعنا على اليوتيوب',
        value: 'https://youtube.com/elebtkar',
        type: ContactType.youtube,
        iconPath: 'assets/home/youtube.png',
      ),
    ];
  }
}
