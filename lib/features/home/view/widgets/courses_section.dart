import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/helpers/context_extensions.dart';
import '../../viewmodel/home_cubit.dart';
import '../../viewmodel/home_state.dart';
import 'package:e_learning/features/my_courses/viewmodel/my_courses_cubit.dart';
import 'package:e_learning/features/my_courses/viewmodel/my_courses_state.dart';

class CoursesSection extends StatelessWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 15.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'دورات المنسي',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          height: 1.5,
          width: 110,
          color: const Color(0xff013567),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 250,
          child: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state.status == HomeStatus.loading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.status == HomeStatus.error) {
                return Center(child: Text(state.message ?? 'Error loading courses'));
              }
              if (state.courses.isEmpty) {
                return const Center(child: Text('لا يوجد دورات متاحة حالياً'));
              }

              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: state.courses.length,
                separatorBuilder: (context, index) => const SizedBox(width: 10),
                itemBuilder: (context, index) {
                  final course = state.courses[index];
                  return BlocBuilder<MyCoursesCubit, MyCoursesState>(
                    builder: (context, myCoursesState) {
                      final isEnrolled = myCoursesState.courses
                          .any((c) => c.id == course.id);

                      return GestureDetector(
                        onTap: () {
                          context.push(AppRouter.course,
                              extra: course.id.toString());
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 250,
                              height: 150,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(5),
                                  topRight: Radius.circular(5),
                                ),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: (course.thumbnailUrl != null &&
                                          course.thumbnailUrl!
                                              .startsWith('http'))
                                      ? NetworkImage(course.thumbnailUrl!)
                                      : AssetImage(
                                          course.thumbnailUrl ??
                                              'assets/course/1.png',
                                        ) as ImageProvider,
                                ),
                              ),
                            ),
                            Container(
                              width: 250,
                              height: 80,
                              decoration: const BoxDecoration(
                                color: Color(0xff013567),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  bottomRight: Radius.circular(5),
                                ),
                              ),
                              child: Column(
                                children: [
                                  const SizedBox(height: 5),
                                  Text(
                                    course.title,
                                    style:
                                        context.textTheme.titleSmall?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 5),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: Row(
                                      children: [
                                        Text(
                                          '${course.price} LE',
                                          style: context.textTheme.titleSmall
                                              ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: isEnrolled
                                                ? Colors.green
                                                : const Color(0xffFFE569),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 12,
                                            ),
                                            minimumSize: const Size(70, 35),
                                          ),
                                          onPressed: isEnrolled
                                              ? null
                                              : () async {
                                                  final result = await context
                                                      .push(AppRouter.subscription,
                                                          extra: course);
                                                  if (result == true &&
                                                      context.mounted) {
                                                    context
                                                        .read<MyCoursesCubit>()
                                                        .getMyCourses();
                                                  }
                                                },
                                          child: Text(
                                            isEnrolled
                                                ? 'مشترك بالفعل'
                                                : 'أشتراك',
                                            style: context.textTheme.titleSmall
                                                ?.copyWith(
                                              color: isEnrolled
                                                  ? Colors.white
                                                  : const Color(0xff013567),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    ),
  );
}

