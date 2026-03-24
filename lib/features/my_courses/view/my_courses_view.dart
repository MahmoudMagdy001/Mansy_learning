import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/context_extensions.dart';
import '../../../core/router/app_router.dart';
import '../../my_courses/viewmodel/my_courses_cubit.dart';
import '../../my_courses/viewmodel/my_courses_state.dart';

/// Displays the authenticated user's enrolled courses.
class MyCoursesView extends StatefulWidget {
  const MyCoursesView({super.key});

  @override
  State<MyCoursesView> createState() => _MyCoursesViewState();
}

class _MyCoursesViewState extends State<MyCoursesView> {
  @override
  void initState() {
    super.initState();
    context.read<MyCoursesCubit>().getMyCourses();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: BlocBuilder<MyCoursesCubit, MyCoursesState>(
      builder: (context, state) {
        if (state.status == MyCoursesStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == MyCoursesStatus.error) {
          return Center(child: Text(state.message ?? 'Error'));
        }

        if (state.status == MyCoursesStatus.success) {
          final courses = state.courses;
          if (courses.isEmpty) {
            return const Center(child: Text('لم تشترك في أي دورات بعد.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'دوراتي',
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 4, bottom: 15),
                  height: 1.5,
                  width: 50,
                  color: const Color(0xff013567),
                ),
                ...courses.map(
                  (course) => Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: GestureDetector(
                      onTap: () {
                        context.push(AppRouter.course, extra: course.id);
                      },
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 200,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: (course.thumbnailUrl != null &&
                                        course.thumbnailUrl!.startsWith('http'))
                                    ? NetworkImage(course.thumbnailUrl!)
                                    : AssetImage(
                                        course.thumbnailUrl ??
                                            'assets/course/1.png',
                                      ) as ImageProvider,
                              ),
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            height: 80,
                            decoration: const BoxDecoration(
                              color: Color(0xff013567),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(5),
                                bottomRight: Radius.circular(5),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                course.title,
                                style: context.textTheme.titleSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    ),
  );
}
