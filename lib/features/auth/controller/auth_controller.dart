import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:twitter_clone/apis/auth_api.dart';
import 'package:twitter_clone/core/core.dart';
import 'package:twitter_clone/models/user_model.dart';
import '../../home/view/home_view.dart';
import 'package:appwrite/models.dart' as model;
import '../view/login_view.dart';
import '/apis/user_api.dart';

final authControllerProvider =
@@ -22,14 +24,12 @@ final currentUserAccountProvider = FutureProvider((ref) {
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
    authAPI: ref.watch(authAPIProvider),
    userAPI: ref.watch(userAPIProvider),
  );
});

final currentUserDetailsProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});

final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});

final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});
class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({
    required AuthAPI authAPI, 
    required UserAPI userAPI
    })  : _authAPI = authAPI,
          _userAPI = userAPI,

  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  // state = isLoading
   Future<model.Account?> currentUser() => _authAPI.currentUserAccount();
  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();

  void signUp({
    required String email,
    required String password,
@@ -41,11 +41,26 @@ class AuthController extends StateNotifier<bool> {
    required BuildContext context,
  }) async {
    state = true;
    final res = await _authAPI.signUp(
      email: email,
      password: password,
    );
    state = false;
    res.fold(
      (l) => showSnackbar(context, l.message),
      // ignore: avoid_print
      (r) => print(r.email),
    );

    res.fold((l) => showSnackbar(context, l.message),
        // ignore: avoid_print
        (r) async {
@@ -47,15 +64,15 @@ class AuthController extends StateNotifier<bool> {
          following: const [],
          profilePic: '',
          bannerPic: '',
          uid: '',
          uid: r.$id,
          bio: '',
          isTwitterBlue: false);
      final res2 = await _userAPI.saveUserData(userModel);
      res2.fold((l) => showSnackbar(context, l.message), (r) {
        showSnackbar(context, 'Account created! please login');
        Navigator.push(context, LoginView.route());
      });

   
    });
  }

@@ -75,4 +92,10 @@ class AuthController extends StateNotifier<bool> {
      (r) => Navigator.push(context, HomeView.route()),
    );
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getUserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}