import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transit_seoul/controllers/public_method.dart';
import 'package:transit_seoul/database/general_db_helper.dart';
import 'package:transit_seoul/models/common/general_db_data_model.dart';
import 'package:transit_seoul/models/common/user_login_model.dart';
import 'package:transit_seoul/services/user_service.dart';
import 'package:transit_seoul/styles/logger.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit(this._repository) : super(UserState());

  final UserService _repository;

  Future<void> initUser() async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      String? token = await secureStorage.read(key: 'token');

      if (token == null) {
        throw Exception('no token');
      }

      UserModel userData = await _repository.fetchUserInfo(token);

      GeneralDbDataModel user = GeneralDbDataModel(
        isLogin: true,
        userName: userData.name,
        email: userData.email,
        userId: userData.userId,
        picture: userData.picture,
      );

      await GeneralDbHelper.instance.saveData(user);

      GeneralDbDataModel? newUserData =
          await GeneralDbHelper.instance.retrieveData();

      emit(state.copyWith(userData: newUserData, status: UserStatus.loggedIn));
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: UserStatus.fail));
    }
  }

  Future<void> getUserLogin(String accessToken) async {
    emit(state.copyWith(status: UserStatus.loading));
    try {
      UserLoginModel userModel = await _repository.getUserLogin(accessToken);

      userModel.token;

      if (userModel.token == null) {
        emit(state.copyWith(status: UserStatus.done));
        return;
      }

      secureStorage.write(key: 'token', value: userModel.token);

      GeneralDbDataModel user = GeneralDbDataModel(
        isLogin: true,
        userName: userModel.user?.name,
        email: userModel.user?.email,
        userId: userModel.user?.userId,
        picture: userModel.user?.picture,
      );

      await GeneralDbHelper.instance.saveData(user);

      GeneralDbDataModel? newUserData =
          await GeneralDbHelper.instance.retrieveData();

      emit(state.copyWith(userData: newUserData, status: UserStatus.loggedIn));
    } catch (e) {
      emit(state.copyWith(status: UserStatus.fail));
    }
  }

  Future<void> getUserDataFromDb() async {
    emit(state.copyWith(status: UserStatus.loading));

    try {
      GeneralDbDataModel? userData =
          await GeneralDbHelper.instance.retrieveData();

      emit(
        state.copyWith(
          userData: userData,
          status:
              userData?.isLogin == true ? UserStatus.loggedIn : UserStatus.done,
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: UserStatus.fail));
    }
  }

  Future<void> saveUserData(GeneralDbDataModel entryData) async {
    try {
      await GeneralDbHelper.instance.saveData(entryData);

      GeneralDbDataModel? newUserData =
          await GeneralDbHelper.instance.retrieveData();

      emit(
        state.copyWith(
          userData: newUserData,
          status: newUserData?.isLogin == true
              ? UserStatus.loggedIn
              : UserStatus.done,
        ),
      );
    } catch (e) {
      logger.e(e);
      emit(state.copyWith(status: UserStatus.fail));
    }
  }
}
