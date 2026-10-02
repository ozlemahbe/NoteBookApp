/// User model representing the authenticated user state
class UserModel {
  final String email;
  final String displayName;
  final bool isLoggedIn;
  final String? avatarUrl;

  const UserModel({
    required this.email,
    required this.displayName,
    this.isLoggedIn = true,
    this.avatarUrl,
  });

  UserModel copyWith({
    String? email,
    String? displayName,
    bool? isLoggedIn,
    String? avatarUrl,
  }) {
    return UserModel(
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }
}
