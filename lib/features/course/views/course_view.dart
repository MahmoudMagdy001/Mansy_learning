import 'package:e_learning/features/my_courses/viewmodel/my_courses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_typography.dart';
import '../../subscription/viewmodels/subscription_cubit.dart';
import '../../subscription/viewmodels/subscription_state.dart';
import '../models/file_model.dart';
import '../models/quiz_model.dart';
import '../models/video_model.dart';
import '../viewmodels/course_cubit.dart';
import '../viewmodels/course_state.dart';
import 'widgets/video_placeholder_widget.dart';

class CourseView extends StatefulWidget {
  final String courseId;

  const CourseView({super.key, required this.courseId});

  @override
  State<CourseView> createState() => _CourseViewState();
}

class _CourseViewState extends State<CourseView> {
  @override
  void initState() {
    super.initState();
    context.read<CourseCubit>().getCourseDetails(widget.courseId);
    context.read<SubscriptionCubit>().checkSubscriptionStatus(widget.courseId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<CourseCubit, CourseState>(
          builder: (context, state) {
            if (state is CourseSuccess) {
              return Text(
                state.course.title,
                style: AppTypography.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              );
            }
            return const Text('تحميل...');
          },
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<CourseCubit, CourseState>(
        builder: (context, state) {
          if (state is CourseLoading || state is CourseInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CourseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, color: Colors.red, size: 64),
                  const SizedBox(height: 16),
                  Text(state.message, style: AppTypography.bodyLarge),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<CourseCubit>().getCourseDetails(
                        widget.courseId,
                      );
                    },
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            );
          }

          if (state is CourseSuccess) {
            return DefaultTabController(
              length: 3,
              child: Column(
                children: [
                  const VideoPlaceholderWidget(),
                  _buildTabBar(context, [
                    'الفيديوهات',
                    'الملفات',
                    'الاختبارات',
                  ]),
                  Expanded(
                    child: BlocBuilder<SubscriptionCubit, SubscriptionState>(
                      builder: (context, subState) {
                        return TabBarView(
                          children: [
                            _buildVideosList(
                              state.videos,
                              subState.isSubscribed,
                            ),
                            _buildFilesList(state.files, subState.isSubscribed),
                            _buildQuizzesList(
                              state.quizzes,
                              subState.isSubscribed,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      bottomNavigationBar: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (context, subState) {
          final courseState = context.watch<CourseCubit>().state;
          if (courseState is! CourseSuccess) return const SizedBox.shrink();

          if (subState.status == SubscriptionStatus.loading) {
            return const SizedBox(
              height: 60,
              child: Center(child: CircularProgressIndicator()),
            );
          }

          if (!subState.isSubscribed) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0F3663),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () async {
                  final result = await context.push(
                    AppRouter.subscription,
                    extra: courseState.course,
                  );
                  if (result == true) {
                    // Refresh status
                    if (context.mounted) {
                      context.read<SubscriptionCubit>().checkSubscriptionStatus(
                        widget.courseId,
                      );
                      context.read<MyCoursesCubit>().getMyCourses();
                    }
                  }
                },
                child: const Text(
                  'اشترك الآن في الدورة',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildTabBar(BuildContext context, List<String> tabTitles) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final selectedColor = isDark
        ? theme.colorScheme.primary
        : const Color(0xFF0F3663);
    final unselectedColor = isDark ? theme.colorScheme.surface : Colors.white;

    return Container(
      decoration: BoxDecoration(
        color: unselectedColor,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300, width: 1.0),
        ),
      ),
      child: TabBar(
        isScrollable: false,
        indicator: BoxDecoration(color: selectedColor),
        labelColor: Colors.white,
        unselectedLabelColor: selectedColor,
        indicatorSize: TabBarIndicatorSize.tab,
        labelStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: AppTypography.bodyMedium.copyWith(
          fontWeight: FontWeight.bold,
        ),
        tabs: tabTitles.map((title) => Tab(child: Text(title))).toList(),
      ),
    );
  }

  Widget _buildVideosList(List<VideoModel> videos, bool isSubscribed) {
    if (videos.isEmpty) {
      return const Center(child: Text('لا يوجد فيديوهات في هذه الدورة.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return _buildListItem(
          title: video.title,
          icon: Icons.play_circle_fill,
          isSubscribed: isSubscribed,
          onTap: () async {
            if (isSubscribed) {
              final url = Uri.parse(video.videoUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.inAppWebView);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر تشغيل الفيديو')),
                  );
                }
              }
            } else {
              _showSubscriptionPrompt(context);
            }
          },
        );
      },
    );
  }

  Widget _buildFilesList(List<FileModel> files, bool isSubscribed) {
    if (files.isEmpty) {
      return const Center(child: Text('لا يوجد ملفات في هذه الدورة.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: files.length,
      itemBuilder: (context, index) {
        final file = files[index];
        return _buildListItem(
          title: file.title,
          icon: Icons.picture_as_pdf,
          isSubscribed: isSubscribed,
          onTap: () async {
            if (isSubscribed) {
              final url = Uri.parse(file.fileUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تعذر فتح الملف')),
                  );
                }
              }
            } else {
              _showSubscriptionPrompt(context);
            }
          },
        );
      },
    );
  }

  Widget _buildQuizzesList(List<QuizModel> quizzes, bool isSubscribed) {
    if (quizzes.isEmpty) {
      return const Center(child: Text('لا يوجد اختبارات في هذه الدورة.'));
    }
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: quizzes.length,
      itemBuilder: (context, index) {
        final quiz = quizzes[index];
        return _buildListItem(
          title: quiz.title,
          icon: Icons.assignment_turned_in,
          isSubscribed: isSubscribed,
          onTap: () {
            if (isSubscribed) {
              context.push(AppRouter.quiz, extra: quiz);
            } else {
              _showSubscriptionPrompt(context);
            }
          },
        );
      },
    );
  }

  Widget _buildListItem({
    required String title,
    required IconData icon,
    required bool isSubscribed,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final itemBgColor = isDark
        ? theme.colorScheme.surfaceContainerHighest
        : const Color(0xFFF2F4F7);
    final itemTextColor = isDark
        ? theme.colorScheme.onSurface
        : const Color(0xFF0F3663);

    return Container(
      margin: const EdgeInsets.only(bottom: 8.0, left: 16.0, right: 16.0),
      decoration: BoxDecoration(
        color: isSubscribed ? itemBgColor : itemBgColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 8.0,
        ),
        title: Text(
          title,
          style: AppTypography.titleMedium.copyWith(
            color: isSubscribed
                ? itemTextColor
                : itemTextColor.withValues(alpha: 0.6),
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 18,
          child: Icon(
            isSubscribed ? icon : Icons.lock,
            size: 20,
            color: isSubscribed ? itemTextColor : Colors.grey,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  void _showSubscriptionPrompt(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'يرجى الاشتراك في الدورة أولاً للوصول إلى هذا المحتوى',
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
