class UserModel {
  final String phone;
  final int balance;
  final bool loggedIn;

  const UserModel({
    required this.phone,
    required this.balance,
    required this.loggedIn,
  });

  UserModel copyWith({
    String? phone,
    int? balance,
    bool? loggedIn,
  }) {
    return UserModel(
      phone: phone ?? this.phone,
      balance: balance ?? this.balance,
      loggedIn: loggedIn ?? this.loggedIn,
    );
  }
}
