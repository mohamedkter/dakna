import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String email;
  final String? name;

  const UserModel({
    required this.id,
    required this.email,
    this.name,
  });

  @override
  List<Object?> get props => [id, email, name];

  factory UserModel.fromSupabase(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['user_metadata']?['full_name'] as String?,
    );
  }
}