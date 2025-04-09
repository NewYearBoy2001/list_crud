import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_crud/src/bloc/user_bloc.dart';
import 'package:list_crud/src/constants/assets.dart';
import 'package:list_crud/src/constants/colors.dart';
import 'package:list_crud/src/model/inser_user/insert_user_request.dart';
import 'package:list_crud/src/model/update_user/update_user_request.dart';
import 'package:list_crud/src/ui/user_arguments.dart';
import 'package:list_crud/src/utils/network_connectivity/bloc/network_bloc.dart';
import 'package:list_crud/src/utils/widgets/button_widget.dart';
import 'package:list_crud/src/utils/widgets/customeHeader.dart';
import 'package:lottie/lottie.dart';

class EditUserScreen extends StatefulWidget {
  final UserArguments editUserArguments;
  const EditUserScreen({super.key, required this.editUserArguments});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;

  final List<String> genderOptions = ['male', 'female'];
  final List<String> statusOptions = ['active', 'inactive'];

  String? selectedGender;
  String? selectedStatus;
  bool networkSuccess = false;

  late bool isEditMode;

  @override
  void initState() {
    super.initState();

    isEditMode = widget.editUserArguments.name!.isNotEmpty ||
        widget.editUserArguments.email!.isNotEmpty ||
        widget.editUserArguments.gender!.isNotEmpty ||
        widget.editUserArguments.status!.isNotEmpty;

    nameController = TextEditingController(text: widget.editUserArguments.name);
    emailController = TextEditingController(text: widget.editUserArguments.email);

    selectedGender = _normalizeGender(widget.editUserArguments.gender);
    selectedStatus = _normalizeStatus(widget.editUserArguments.status);
  }

  String? _normalizeGender(String? gender) {
    if (gender == null) return null;
    return genderOptions.firstWhere(
            (option) => option.toLowerCase() == gender.toLowerCase().trim(),
        orElse: () => '');
  }

  String? _normalizeStatus(String? status) {
    if (status == null) return null;
    return statusOptions.firstWhere(
            (option) => option.toLowerCase() == status.toLowerCase().trim(),
        orElse: () => '');
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isFormValid() {
    final email = emailController.text.trim();
    return nameController.text.trim().isNotEmpty &&
        email.isNotEmpty &&
        _isValidEmail(email) &&
        selectedGender != null &&
        selectedGender!.isNotEmpty &&
        selectedStatus != null &&
        selectedStatus!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        context.go('/homeScreen');
      },
      child: Scaffold(
        backgroundColor: AppColors.primaryWhiteColor,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: BlocBuilder<NetworkBloc, NetworkState>(
            builder: (context, state) {
              if (state is NetworkSuccess) {
                networkSuccess = true;
                return BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is InsertUserLoading || state is UpdateUserLoading) {
            return Center(
              child: RefreshProgressIndicator(
                color: AppColors.primaryWhiteColor,
                backgroundColor: AppColors.primaryBlueColor,
              ),
            );
          }
          return PrimaryButton(
            text: isEditMode ? "Update Details" : "Insert User",
            onPressed: () {
              final name = nameController.text.trim();
              final email = emailController.text.trim();

              if (!_isFormValid() && !isEditMode) {
                String errorMsg = "Please fill out all fields";
                if (email.isEmpty) {
                  errorMsg = "Email is required";
                }
                else if (!_isValidEmail(email) && !isEditMode) {
                  errorMsg = "Please enter a valid email address";
                }

                Fluttertoast.showToast(
                  msg: errorMsg,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: AppColors.primaryWhiteColor,
                  textColor: AppColors.primaryRedColor,
                );
                return;
              }

              final gender = selectedGender!;
              final status = selectedStatus!;

              widget.editUserArguments.name = name;
              widget.editUserArguments.email = email;
              widget.editUserArguments.gender = gender;
              widget.editUserArguments.status = status;

              if (isEditMode) {
                final currentUser = UpdateUserRequest(
                  name: name,
                  email: email,
                  gender: gender,
                  status: status,
                );
                context.read<UserBloc>().add(UpdateUserEvent(updateUserRequest: currentUser, id: widget.editUserArguments.id!.toInt()));
              } else {
                final newUser = InsertUserRequest(
                  name: name,
                  email: email,
                  gender: gender,
                  status: status,
                );
                context.read<UserBloc>().add(
                  InsertUserEvent(insertUserRequest: newUser),
                );
              }
            },
          );
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
      ),
        ),
        body: BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is InsertUserLoaded) {
              Fluttertoast.showToast(
                msg: "Inserted successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primaryWhiteColor,
                textColor: AppColors.primaryBlueColor,
              );
            }
            if (state is InsertUserLoadingError) {
              Fluttertoast.showToast(
                msg: state.errorMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primaryWhiteColor,
                textColor: AppColors.primaryRedColor,
              );
            }

            if (state is UpdateUserLoaded) {
              Fluttertoast.showToast(
                msg: "Update successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primaryWhiteColor,
                textColor: AppColors.primaryBlueColor,
              );
            }

            if (state is UpdateUserLoadingError) {
              Fluttertoast.showToast(
                msg: state.errorMsg,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primaryWhiteColor,
                textColor: AppColors.primaryRedColor,
              );
            }

          },
          builder: (context, state) {
            return CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomSliverHeader(
                    showAvatar: false,
                    expandedHeight: 167,
                    title: isEditMode ? 'Edit Details' : 'Add New User',
                    subtitle:
                    isEditMode ? 'Edit Details' : 'Enter user details',
                    showBackButton: true,
                    onBack: () => context.go('/homeScreen'),
                    leadingIcon: isEditMode ? Icons.edit : Icons.person_add_alt_1,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        top: 70.0, left: 16, right: 16, bottom: 20),
                    child: Column(
                      children: [
                        _inputField("Name", nameController),
                        _inputField("Email", emailController),
                        _dropdownField("Gender", genderOptions, selectedGender,
                                (val) {
                              setState(() => selectedGender = val);
                            }),
                        _dropdownField("Status", statusOptions, selectedStatus,
                                (val) {
                              setState(() => selectedStatus = val);
                            }),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _inputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
            GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500,color: AppColors.primaryBlackColor),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: AppColors.primaryBlackColor
              ),
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dropdownField(String label, List<String> items, String? value,
      ValueChanged<String?> onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style:
            GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value?.isEmpty ?? true ? null : value,
            onChanged: onChanged,
            items: items
                .map((item) => DropdownMenuItem<String>(
              value: item,
              child: Text(item,
                  style: GoogleFonts.poppins(fontSize: 14)),
            ))
                .toList(),
            decoration: InputDecoration(
              contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.blue),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

