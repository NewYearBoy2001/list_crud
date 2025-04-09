import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_crud/src/bloc/user_bloc.dart';
import 'package:list_crud/src/constants/colors.dart';
import 'package:list_crud/src/ui/user_arguments.dart';
import 'package:list_crud/src/utils/network_connectivity/bloc/network_bloc.dart';
import 'package:list_crud/src/utils/widgets/button_widget.dart';
import 'package:list_crud/src/utils/widgets/customeHeader.dart';
import 'package:lottie/lottie.dart';

import '../../constants/assets.dart';

class UserDetailsScreen extends StatefulWidget {
  final UserArguments userArguments;
  const UserDetailsScreen({super.key, required this.userArguments,});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {

  bool networkSuccess = false;


  @override
  void initState() {
    BlocProvider.of<UserBloc>(context).add(UserDetailsEvent(id: widget.userArguments.id!.toInt()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NetworkBloc, NetworkState>(
  builder: (context, state) {
    if (state is NetworkSuccess) {
      networkSuccess = true;
      return BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserLoadingError) {
            Fluttertoast.showToast(
              msg: state.errorMsg,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              backgroundColor: AppColors.primaryWhiteColor,
              textColor: AppColors.primaryBlueColor,
            );
          }
        },
        builder: (context, state) {
          Widget? bottomButton;

          if (state is UserDetailsLoaded) {
            final user = state.userDetailsResponse;

            bottomButton = Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: PrimaryButton(
                text: "Edit Details",
                onPressed: () {
                  context.push(
                    "/edit_screen",
                    extra: UserArguments(
                      isEditMode: true,
                      id: user.id,
                      name: user.name,
                      email: user.email,
                      gender: user.gender,
                      status: user.status,
                    ),
                  );
                },
              ),
            );

            return PopScope(
              canPop: true,
              onPopInvoked: (didPop) {
                context.go('/homeScreen');
              },
              child: Scaffold(
                backgroundColor: AppColors.primaryWhiteColor,
                bottomNavigationBar: bottomButton,
                body: CustomScrollView(
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: CustomSliverHeader(
                        showAvatar: true,
                        expandedHeight: 200,
                        showBackButton: true,
                        onBack: () => context.pop(),
                        leadingIcon: Icons.arrow_back,
                        title: '',
                        subtitle: '',
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, left: 16, top: 100, bottom: 100),
                        child: Column(
                          children: [
                            Text(
                              user.name,
                              style: GoogleFonts.poppins(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryBlueColor,
                              ),
                            ),
                            const SizedBox(height: 30),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: AppColors.primaryBlackColor,
                                  width: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                              child: Column(
                                children: [
                                  _infoRow(Icons.email_outlined, "Email", user.email),
                                  const SizedBox(height: 20),
                                  _infoRow(Icons.female_outlined, "Gender", user.gender),
                                  const SizedBox(height: 20),
                                  _infoRow(Icons.info_outline, "Status", user.status),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is UserDetailsLoading) {
            return Scaffold(
              body: Center(
                child: Lottie.asset(
                  Assets.JUMBINGDOT,
                  height: 60,
                  width: 60,
                ),
              ),
            );
          }

          if (state is UserDetailsLoadingError) {
            return Scaffold(
              backgroundColor: AppColors.primaryWhiteColor,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(Assets.NO_DATA, height: 300, width: 300),
                    const SizedBox(height: 20),
                    Text(
                      "No Data",
                      style: GoogleFonts.roboto(
                        color: Theme.of(context).colorScheme.secondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox();
        },
      );
    }
    else if (state is NetworkFailure || state is NetworkInitial) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(Assets.NO_INTERNET),
            Text(
              "You are not connected to the internet",
              style: GoogleFonts.openSans(
                color: AppColors.primaryBlueColor,
                fontSize: 20,
              ),
            ).animate().scale(delay: 200.ms, duration: 300.ms),
          ],
        ),
      );
    }
    return const SizedBox();
  },
);
  }


  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          radius: 24,
          child: Icon(icon, color: AppColors.primaryBlueColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
