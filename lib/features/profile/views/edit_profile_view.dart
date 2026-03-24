import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../viewmodels/edit_profile_cubit.dart';
import '../viewmodels/edit_profile_state.dart';
import '../viewmodels/profile_cubit.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<EditProfileCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تعديل البيانات'),
      ),
      body: BlocConsumer<EditProfileCubit, EditProfileState>(
        listener: (context, state) {
          if (state.status == EditProfileStatus.success) {
             context.read<ProfileCubit>().getProfile();
             context.pop();
          }
          if (state.status == EditProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message ?? 'Error')),
            );
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 20),
                _inputField(context, 'الاسم الأول', 'الاسم الأول', cubit.firstNameController),
                const SizedBox(height: 20),
                _inputField(context, 'الاسم الأخير', 'الاسم الأخير', cubit.lastNameController),
                const SizedBox(height: 20),
                _inputField(context, 'رقم الهاتف', '01xxxxxxxxx', cubit.phoneController),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'حفظ',
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  isLoading: state.status == EditProfileStatus.loading,
                  onPressed: () => cubit.updateProfile(),
                ),
                const SizedBox(height: 15),
                CustomButton(
                  text: 'إلغاء',
                  backgroundColor: AppColors.secondColor,
                  foregroundColor: AppColors.brand,
                  onPressed: () => context.pop(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _inputField(BuildContext context, String label, String hint, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          label,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: controller,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Colors.grey),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
      ],
    );
  }
}
