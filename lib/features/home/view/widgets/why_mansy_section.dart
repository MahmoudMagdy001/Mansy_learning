import 'package:flutter/material.dart';

import '../../../../core/helpers/context_extensions.dart';

class WhyMansySection extends StatelessWidget {
  const WhyMansySection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: [
      Container(
        width: double.infinity,
        height: 300,
        decoration: const BoxDecoration(
          color: Color(0xff013567),
          image: DecorationImage(image: AssetImage('assets/home/big_logo.png')),
        ),
      ),
      const SizedBox(height: 20),
      Row(
        children: [
          const Expanded(child: Divider(thickness: 1, color: Color(0xff013567))),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              'لماذا منصة المنسي',
              style: context.textTheme.titleMedium?.copyWith(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Expanded(child: Divider(thickness: 1, color: Color(0xff013567))),
        ],
      ),
      const SizedBox(height: 20),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            FeatureItem(text: 'منصة شاملة تغنيك عن أي منصة أخرى'),
            FeatureItem(
              text:
                  'منصة تبدأ معك من الصفر وتوصلك إلى القمة خطوة بخطوة فكرة بفكرة',
            ),
            FeatureItem(
              text:
                  'كل ما تحتاجه جاهز على المنصة تقدر تذاكره من أي مكان وفي أي وقت',
            ),
            FeatureItem(
              text:
                  'اختبارات محاكية تقدر من خلالها تتابع مستواك لحظة بلحظة وتعيشك أجواء الاختبار',
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/home/whatsapp.png', scale: 4),
            const SizedBox(width: 15),
            Image.asset('assets/home/facebook.png', scale: 4),
            const SizedBox(width: 15),
            Image.asset('assets/home/instgram.png', scale: 4),
            const SizedBox(width: 15),
            Image.asset('assets/home/youtube.png', scale: 4),
          ],
        ),
      ),
    ],
  );
}

class FeatureItem extends StatelessWidget {
  const FeatureItem({required this.text, super.key});
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: RichText(
            textDirection: TextDirection.rtl,
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                const TextSpan(
                  text: '■  ',
                  style: TextStyle(color: Colors.black, fontSize: 8),
                ),
                TextSpan(
                  text: text,
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: Colors.black,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
