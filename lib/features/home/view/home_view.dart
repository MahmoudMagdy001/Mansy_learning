import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../viewmodel/home_cubit.dart';
import 'widgets/courses_section.dart';
import 'widgets/header_section.dart';
import 'widgets/why_mansy_section.dart';

/// Home tab — always accessible to both authenticated and guest users.
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().getCourses();
  }

  @override
  Widget build(BuildContext context) => const Scaffold(
    body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            HeaderSection(),
            SizedBox(height: 5),
            CoursesSection(),
            SizedBox(height: 5),
            WhyMansySection(),
          ],
        ),
      ),
    ),
  );
}
