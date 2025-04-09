import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:list_crud/src/bloc/user_bloc.dart';
import 'package:list_crud/src/constants/assets.dart';
import 'package:list_crud/src/constants/colors.dart';
import 'package:list_crud/src/model/user_list_response/user_list_response.dart';
import 'package:list_crud/src/ui/user_arguments.dart';
import 'package:list_crud/src/utils/network_connectivity/bloc/network_bloc.dart';
import 'package:list_crud/src/utils/widgets/customeHeader.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool isLoading = false;
  bool hasMoreData = true;
  List<UserListResponse> usersList = [];
  Set<int> userIds = {};
  bool networkSuccess = false;


  int? deleteLoadingIndex;
  Set<int> deleteListIndices = {};

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _scrollController.addListener(() {
      if (hasMoreData &&
          !isLoading &&
          _scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100) {
        _fetchUsers();
      }
    });
  }

  void _fetchUsers() {
    if (isLoading || !hasMoreData) return;
    setState(() => isLoading = true);
    BlocProvider.of<UserBloc>(context).add(UserListEvent(page: page, perPage: 5));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryWhiteColor,
      body: BlocBuilder<NetworkBloc, NetworkState>(
        builder: (context, state) {
      if (state is NetworkSuccess) {
        networkSuccess = true;
        return BlocConsumer<UserBloc, UserState>(
          listener: (context, state) {
            if (state is UserLoaded) {
              final newUsers = state.userListResponse;
              final newUserIds = newUsers.map((u) => u.id).toSet();

              setState(() {
                final filteredUsers = newUsers.where((u) => !userIds.contains(u.id)).toList();
                usersList.addAll(filteredUsers);
                userIds.addAll(newUserIds);
                isLoading = false;
                hasMoreData = filteredUsers.length == 5;
                if (hasMoreData) page++;
              });

            } else if (state is UserLoadingError) {
              setState(() {
                isLoading = false;
                hasMoreData = false;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Failed to load users. Try again."),
                  action: SnackBarAction(
                    label: "Retry",
                    onPressed: () {
                      _fetchUsers();
                    },
                  ),
                ),
              );
            }

            else if (state is DeleteUserLoaded) {
              Fluttertoast.showToast(
                msg: state.message,
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primaryWhiteColor,
                textColor: AppColors.primaryBlueColor,
              );
              setState(() {
                page = 1;
                usersList.clear();
                userIds.clear();
                hasMoreData = true;
                deleteLoadingIndex = null;
              });
              _fetchUsers();
            } else if (state is DeleteUserLoadingError) {
              setState(() => deleteLoadingIndex = null);

              Fluttertoast.showToast(
                msg: "Failed to delete user.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: AppColors.primaryWhiteColor,
                textColor: AppColors.primaryBlueColor,
              );

            }

          },

          builder: (context, state) {
            if (state is UserLoading && usersList.isEmpty) {
              return Center(
                child: Lottie.asset(
                  Assets.JUMBINGDOT,
                  height: 60,
                  width: 60,
                ),
              );
            }

            return usersList.isEmpty
                ? Center(
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
            )
                : CustomScrollView(
              controller: _scrollController,
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  delegate: CustomSliverHeader(
                    showAvatar: false,
                    expandedHeight: 167,
                    title: 'My Profile',
                    subtitle: 'Users List',
                    buttonLabel: 'Load User Data',
                    leadingIcon: Icons.person,
                    onReload: () {
                      setState(() {
                        page = 1;
                        usersList.clear();
                        userIds.clear();
                        hasMoreData = true;
                      });
                      _fetchUsers();
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 25.0, top: 60, bottom: 10),
                    child: Text(
                      "No of Users: ${usersList.length}",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.secondaryBlackColor,
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (context, index) {
                      final user = usersList[index];
                      return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColors.primaryWhiteColor,
                              borderRadius: BorderRadius.circular(4),
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              leading: CircleAvatar(
                                backgroundColor: Colors.grey.shade200,
                                radius: 24,
                                child: Icon(Icons.person),
                              ),
                              title: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  user.name,
                                  style: GoogleFonts.poppins(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.primaryBlackColor,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      _buildActionBtn(Assets.PENCIL_SVG, "Edit", () {
                                        context.push(
                                          '/edit_screen',
                                          extra: UserArguments(
                                            isEditMode: true,
                                            id: user.id ?? 0,
                                            name: user.name ?? "",
                                            email: user.email ?? "",
                                            gender: user.gender?.name ?? "",
                                            status: user.status?.name ?? "",
                                          ),
                                        );
                                      }),
                                      const SizedBox(width: 8),
                                      _buildActionBtn(Assets.EYE_SVG, "View", () {
                                        context.push(
                                          '/details_screen',
                                          extra: UserArguments(isEditMode: false, id: user.id ?? 0),
                                        );
                                      }),
                                      const SizedBox(width: 8),
                                      BlocBuilder<UserBloc, UserState>(
                                        builder: (context, state) {
                                          if (deleteLoadingIndex == index) {
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Lottie.asset(
                                                Assets.JUMBINGDOT,
                                                height: 60,
                                                width: 60,
                                              ),
                                            );
                                          }
                                          return _buildActionBtn(Assets.TRASH_SVG, "Delete", () {
                                            setState(() {
                                              deleteLoadingIndex = index;
                                            });
                                            context.read<UserBloc>().add(DeleteUserEvent(id: user.id));
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )

                      );
                    },
                    childCount: usersList.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding:  EdgeInsets.only(left: 24, right: 24, bottom: isLoading ? 30 : 80,top: 10),
                    child: Center(
                      child: isLoading
                          ?  RefreshProgressIndicator(
                        color: AppColors.primaryWhiteColor,
                        backgroundColor: AppColors.primaryBlueColor,
                      )
                          : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.shade200,
                            radius: 10,
                            child: SvgPicture.asset(
                              Assets.SPINNER_SVG,
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            hasMoreData ? "Load More" : "All data fetched",
                            style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: AppColors.primaryBlueColor
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            );
          },
        );
      }else if (state is NetworkFailure || state is NetworkInitial) {
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
      floatingActionButtonLocation: networkSuccess ? FloatingActionButtonLocation.endFloat : null,
      floatingActionButton: networkSuccess
          ? Padding(
        padding: const EdgeInsets.only(right: 16.0, bottom: 16),
        child: FloatingActionButton(
          onPressed: () {
            context.push(
              '/edit_screen',
              extra: UserArguments(
                id: 0,
                name: "",
                email: "",
                gender: "",
                status: "",
                isEditMode: false,
              ),
            );
          },
          backgroundColor: AppColors.primaryBlueColor,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 28, color: Colors.white),
        ),
      )
          : null,


    );
  }


  Widget _buildActionBtn(String svgIconPath, String label, VoidCallback onPressed) {
    return SizedBox(
      height: 32,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: AppColors.primaryBlackColor, width: 0.1),
          ),
          textStyle: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.secondaryButtonTextRedColor
          ),
        ),
        icon: SvgPicture.asset(
          svgIconPath,
        ),
        label: Text(label),
      ),
    );
  }
}
