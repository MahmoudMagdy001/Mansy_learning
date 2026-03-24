import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/helpers/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../models/terms_model.dart';
import '../viewmodels/terms_cubit.dart';

class TermsAndConditionsView extends StatefulWidget {
  const TermsAndConditionsView({super.key});

  @override
  State<TermsAndConditionsView> createState() => _TermsAndConditionsViewState();
}

class _TermsAndConditionsViewState extends State<TermsAndConditionsView> {
  @override
  void initState() {
    super.initState();
    context.read<TermsCubit>().getTerms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.brand,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'الشروط وسياسة الخصوصية',
          style: context.textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocBuilder<TermsCubit, TermsState>(
        builder: (context, state) {
          if (state is TermsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TermsSuccess) {
            final terms = state.terms;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end, // RTL support
                children: [
                  Text(
                    terms.lastUpdated,
                    style: context.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 16),
                  ...terms.sections.map((section) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildSection(context, section),
                    );
                  }),
                ],
              ),
            );
          } else if (state is TermsError) {
            return Center(child: Text(state.message));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildSection(BuildContext context, TermsSection section) {
    switch (section.type) {
      case TermsSectionType.header:
        return Text(
          section.content,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontSize: 18,
          ),
          textAlign: TextAlign.right,
        );
      case TermsSectionType.paragraph:
        return Text(
          section.content,
          style: context.textTheme.bodyMedium?.copyWith(
            height: 1.5,
            color: Colors.black,
          ),
          textAlign: TextAlign.right,
        );
      case TermsSectionType.bullet:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                section.content,
                style: context.textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                  color: Colors.black,
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const SizedBox(width: 8),
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: CircleAvatar(
                radius: 2,
                backgroundColor: Colors.black,
              ),
            ),
          ],
        );
    }
  }
}
