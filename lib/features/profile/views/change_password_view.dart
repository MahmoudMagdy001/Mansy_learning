import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/helpers/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../viewmodels/change_password_cubit.dart';
import '../viewmodels/change_password_state.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  bool _obscureCurrent = true;
  bool _obscureNew = true;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ChangePasswordCubit>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('تغيير كلمة المرور'),
      ),
      body: BlocConsumer<ChangePasswordCubit, ChangePasswordState>(
        listener: (context, state) {
          if (state.status == ChangePasswordStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('تم تغيير كلمة المرور بنجاح')),
            );
            context.pop();
          }
          if (state.status == ChangePasswordStatus.error) {
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
                _passwordField(
                  context,
                  'كلمة المرور الحالية',
                  controller: cubit.currentPasswordController,
                  obscure: _obscureCurrent,
                  onToggle: () => setState(() => _obscureCurrent = !_obscureCurrent),
                ),
                const SizedBox(height: 20),
                _passwordField(
                  context,
                  'كلمة المرور الجديدة',
                  controller: cubit.newPasswordController,
                  obscure: _obscureNew,
                  onToggle: () => setState(() => _obscureNew = !_obscureNew),
                ),
                const SizedBox(height: 20),
                _passwordField(
                  context,
                  'تأكيد كلمة المرور',
                  controller: cubit.confirmPasswordController,
                  obscure: true, // No toggle for confirm? Screenshot shows none.
                ),
                const SizedBox(height: 50),
                CustomButton(
                  text: 'حفظ',
                  backgroundColor: AppColors.brand,
                  foregroundColor: Colors.white,
                  isLoading: state.status == ChangePasswordStatus.loading,
                  onPressed: () => cubit.updatePassword(),
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

  Widget _passwordField(
    BuildContext context,
    String label, {
    required TextEditingController controller,
    required bool obscure,
    VoidCallback? onToggle,
  }) {
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
          obscureText: obscure,
          textAlign: TextAlign.right,
          decoration: InputDecoration(
            prefixIcon: onToggle != null
                ? IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                      color: AppColors.brand,
                    ),
                    onPressed: onToggle,
                  )
                : null,
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
