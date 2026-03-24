import '../models/terms_model.dart';

abstract class TermsRepository {
  TermsAndConditionsModel getTerms();
}

class TermsRepositoryImpl implements TermsRepository {
  @override
  TermsAndConditionsModel getTerms() {
    return const TermsAndConditionsModel(
      title: 'الشروط وسياسة الخصوصية',
      lastUpdated: 'تم التحديث لآخر مرة: 29 يناير 2023',
      sections: [
        TermsSection(
          content: 'توضح سياسة الخصوصية هذه سياساتنا وإجراءاتنا بشأن جمع معلوماتك واستخدامها والكشف عنها عند استخدامك للخدمة وتخبرك بحقوق الخصوصية الخاصة بك وكيفية حمايتك وفقا للقانون.',
          type: TermsSectionType.paragraph,
        ),
        TermsSection(
          content: 'نستخدم بياناتك الشخصية لتوفير الخدمة وتحسينها. باستخدام الخدمة، فإنك توافق على جمع واستخدام المعلومات وفقا لهذه سياسة الخصوصية.',
          type: TermsSectionType.paragraph,
        ),
        TermsSection(
          content: 'التفسير والتعاريف',
          type: TermsSectionType.header,
        ),
        TermsSection(
          content: 'التفسير',
          type: TermsSectionType.header,
        ),
        TermsSection(
          content: 'الكلمات التي يبدأ حرفها الأول بحرف كبير لها معان محددة في الظروف التالية. يتعين أن تكون هذه التعاريف ذات المعنى الواحد سواء كانت في صيغة المفرد أم الجمع.',
          type: TermsSectionType.paragraph,
        ),
        TermsSection(
          content: 'التعاريف',
          type: TermsSectionType.header,
        ),
        TermsSection(
          content: 'لأغراض هذه سياسة الخصوصية:',
          type: TermsSectionType.paragraph,
        ),
        TermsSection(
          content: 'الحساب يعني حسابا فريدا تم إنشاؤه لك للوصول إلى خدمتنا أو أجزاء من خدمتنا.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'الشركاء تعني كيانا يتحكم فيه الطرف أو يتحكم فيه أو يكون تحت السيطرة المشتركة مع الطرف، حيث يعني "التحكم" امتلاك %50 أو أكثر من الأسهم أو حصة الملكية أو الأوراق المالية الأخرى المخولة بالتصويت لانتخاب مديرين أو سلطة إدارية أخرى.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'التطبيق يشير إلى "nagaah"، البرنامج البرمجي الذي يقدمه الشركة.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'الشركة (التي يشار إليها بـ "الشركة" أو "نحن" أو "لنا" في هذا الاتفاق) تشير إلى nagaah.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'الدولة تشير إلى: مصر',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'الجهاز يعني أي جهاز يمكنه الوصول إلى الخدمة مثل الكمبيوتر أو الهاتف المحمول أو الجهاز اللوحي الرقمي.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'البيانات الشخصية هي أي معلومات تتعلق بشخص محدد أو قابل للتحديد.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'الخدمة تشير إلى التطبيق.',
          type: TermsSectionType.bullet,
        ),
        TermsSection(
          content: 'مقدم الخدمة يعني أي شخص طبيعي أو معنوي يعالج البيانات نيابة عن الشركة. يشير إلى الشركات أو الأفراد من الطرف الثالث الذين يعملون لصالح الشركة لتيسير الخدمة، أو تقديم الخدمة نيابة عن الشركة، أو أداء الخدمات المتعلقة بالخدمة، أو مساعدة الشركة في تحليل كيفية استخدام الخدمة.',
          type: TermsSectionType.bullet,
        ),
      ],
    );
  }
}
