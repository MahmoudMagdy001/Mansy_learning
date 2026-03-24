import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/helpers/context_extensions.dart';
import '../../../core/theme/app_colors.dart';
import '../models/contact_us_model.dart';
import '../viewmodels/contact_us_cubit.dart';
import '../viewmodels/contact_us_state.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  @override
  void initState() {
    super.initState();
    context.read<ContactUsCubit>().getContactOptions();
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
          'تواصل معنا',
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
      body: BlocBuilder<ContactUsCubit, ContactUsState>(
        builder: (context, state) {
          if (state is ContactUsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ContactUsSuccess) {
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              itemCount: state.contacts.length,
              itemBuilder: (context, index) {
                final contact = state.contacts[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _ContactItem(
                    contact: contact,
                    onTap: () => context.read<ContactUsCubit>().launchContact(contact),
                  ),
                );
              },
            );
          } else if (state is ContactUsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.message),
                  ElevatedButton(
                    onPressed: () => context.read<ContactUsCubit>().getContactOptions(),
                    child: const Text('إعادة المحاولة'),
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
}

class _ContactItem extends StatelessWidget {
  final ContactUsModel contact;
  final VoidCallback onTap;

  const _ContactItem({required this.contact, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xffF5F7F9), // Light grayish background
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
             const SizedBox(width: 16),
            const Icon(
              Icons.arrow_back_ios,
              color: AppColors.brand,
              size: 20,
            ),
            const Spacer(),
            Text(
              contact.title,
              style: context.textTheme.bodyLarge?.copyWith(
                color: AppColors.brand,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16),
            _buildIcon(),
            const SizedBox(width: 16),
            Container(
              width: 10,
              decoration: const BoxDecoration(
                color: AppColors.brand,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIcon() {
    // If it's a phone, we might not have a png asset, so we use an Icon with color
    if (contact.type == ContactType.phone) {
       return Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xffFFC107), // Yellow
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Icon(Icons.phone_in_talk, color: Colors.white, size: 24),
      );
    }

    return Image.asset(
      contact.iconPath,
      width: 32,
      height: 32,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(Icons.error, size: 32);
      },
    );
  }
}
