import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:list_crud/src/api_providers/user_providers.dart';
import 'package:list_crud/src/model/inser_user/insert_user_request.dart';
import 'package:list_crud/src/model/inser_user/insert_user_response.dart';
import 'package:list_crud/src/model/state_model.dart';
import 'package:list_crud/src/model/update_user/update_user_request.dart';
import 'package:list_crud/src/model/update_user/update_user_response.dart';
import 'package:list_crud/src/model/user_details/user_details_response.dart';
import 'package:list_crud/src/model/user_list_response/user_list_response.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserProvider userProvider;
  UserBloc({required this.userProvider}) : super(UserInitial()) {
    on<UserListEvent>((event, emit) async{
      emit(UserLoading());
      final StateModel? stateModel = await userProvider.userListProvider(event.page,event.perPage);
      if(stateModel is SuccessState){
        emit(UserLoaded(userListResponse: stateModel.value));
      }
      if(stateModel is ErrorState){
        emit(UserLoadingError(errorMsg: stateModel.msg));
        emit(UserLoadingRequestResourceNotFound(errorMsg: stateModel.msg));
        emit(UserLoadingConnectionRefused(errorMsg: stateModel.msg));
      }
    });


    /// insert
    on<InsertUserEvent>((event, emit) async{
      emit(InsertUserLoading());
      final StateModel? stateModel = await userProvider.insertUserProvider(event.insertUserRequest);
      if(stateModel is SuccessState){
        emit(InsertUserLoaded(insertUserResponse: stateModel.value));
      }
      if(stateModel is ErrorState){
        emit(InsertUserLoadingError(errorMsg: stateModel.msg));
        emit(InsertUserLoadingResourceNotFound(errorMsg: stateModel.msg));
        emit(InsertUserLoadingConnectionRefused(errorMsg: stateModel.msg));
      }
    });


    /// Update
    on<UpdateUserEvent>((event, emit) async{
      emit(UpdateUserLoading());
      final StateModel? stateModel = await userProvider.updateUserProvider(event.id,event.updateUserRequest);
      if(stateModel is SuccessState){
        emit(UpdateUserLoaded(updateUserResponse: stateModel.value));
      }
      if(stateModel is ErrorState){
        emit(UpdateUserLoadingError(errorMsg: stateModel.msg));
        emit(UpdateUserLoadingResourceNotFound(errorMsg: stateModel.msg));
        emit(UpdateUserLoadingConnectionRefused(errorMsg: stateModel.msg));
      }
    });

    /// Details
    on<UserDetailsEvent>((event, emit) async{
      emit(UserDetailsLoading());
      final StateModel? stateModel = await userProvider.userDetailsProvider(event.id);
      if(stateModel is SuccessState){
        emit(UserDetailsLoaded(userDetailsResponse: stateModel.value));
      }
      if(stateModel is ErrorState){
        emit(UserDetailsLoadingError(errorMsg: stateModel.msg));
        emit(UserDetailsLoadingResourceNotFound(errorMsg: stateModel.msg));
        emit(UserDetailsConnectionRefused(errorMsg: stateModel.msg));
      }
    });

    /// Delete
    on<DeleteUserEvent>((event, emit) async{
      emit(DeleteUserLoading());
      final StateModel? stateModel = await userProvider.deleteUserProvider(event.id);
      if(stateModel is SuccessState){
        emit(DeleteUserLoaded(message: stateModel.value));
      }
      if(stateModel is ErrorState){
        emit(DeleteUserLoadingError(errorMsg: stateModel.msg));
        emit(DeleteUserLoadingResourceNotFound(errorMsg: stateModel.msg));
        emit(DeleteUserLoadingConnectionRefused(errorMsg: stateModel.msg));
      }
    });
  }
}
