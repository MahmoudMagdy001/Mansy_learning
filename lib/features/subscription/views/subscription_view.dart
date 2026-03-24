import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/helpers/context_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../course/models/course_model.dart';
import '../viewmodels/subscription_cubit.dart';
import '../viewmodels/subscription_state.dart';

class SubscriptionView extends StatelessWidget {
  final CourseModel course;

  const SubscriptionView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (context, state) {
          if (state.status == SubscriptionStatus.success &&
              state.isSubscribed) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم الاشتراك بنجاح!'),
                backgroundColor: Colors.green,
                behavior: SnackBarBehavior.floating,
              ),
            );
            context.pop(true);
          } else if (state.status == SubscriptionStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message ?? 'خطأ في الاشتراك'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
        builder: (context, state) {
          return CustomScrollView(
            slivers: [
              // Custom Header with Image
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (course.thumbnailUrl != null)
                        Image.network(course.thumbnailUrl!, fit: BoxFit.cover)
                      else
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.brand,
                                AppColors.brand.withValues(alpha: 0.7),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: const Icon(
                            Icons.school_outlined,
                            size: 100,
                            color: Colors.white24,
                          ),
                        ),
                      // Gradient Overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.pop(),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Course Info Card
                      Transform.translate(
                        offset: const Offset(0, 5),
                        child: Card(
                          elevation: 10,
                          shadowColor: Colors.black26,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Text(
                                  'تأكيد الاشتراك في الدورة',
                                  style: context.textTheme.labelMedium
                                      ?.copyWith(
                                        color: AppColors.brand,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  course.title,
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                const Divider(height: 30),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'إجمالي الدفع:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '${course.price ?? 0} جنيه',
                                      style: context.textTheme.headlineSmall
                                          ?.copyWith(
                                            color: Colors.green[700],
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Benefits Section
                      const SizedBox(height: 25),

                      Text(
                        'ما الذي ستحصل عليه؟',
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 25),
                      _buildBenefitItem(
                        context,
                        Icons.play_circle_outline,
                        'وصول كامل لمحتوى الفيديوهات',
                      ),
                      _buildBenefitItem(
                        context,
                        Icons.description_outlined,
                        'ملفات PDF ومراجع للدراسة',
                      ),
                      _buildBenefitItem(
                        context,
                        Icons.quiz_outlined,
                        'اختبارات تقييمية بعد كل درس',
                      ),
                      _buildBenefitItem(
                        context,
                        Icons.all_inclusive,
                        'وصول مدى الحياة للمحتوى',
                      ),

                      const SizedBox(height: 40),

                      // Action Buttons
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.brand,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 5,
                        ),
                        onPressed: state.status == SubscriptionStatus.loading
                            ? null
                            : () => context.read<SubscriptionCubit>().subscribe(
                                course.id,
                              ),
                        child: state.status == SubscriptionStatus.loading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'تأكيد ودفع الآن',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(height: 15),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: Text(
                          'إلغاء العملية',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBenefitItem(BuildContext context, IconData icon, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.brand.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: AppColors.brand),
          ),
          const SizedBox(width: 15),
          Expanded(child: Text(label, style: context.textTheme.bodyLarge)),
        ],
      ),
    );
  }
}
