import 'package:equatable/equatable.dart';
import 'package:kopma/data/model/user/user_entity.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String? address;
  final int? balance;


  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.address,
    this.balance
  });

  /// Empty user which represents an unauthenticated user.
  static const empty = UserModel(
    id: '',
    name: '',
    email: '',
    image: '',
    address: '',
    balance: 0,
  );

  /// Modify MyUser parameters
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? image,
    String? address,
    int? balance,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      image: image ?? this.image,
      address: address ?? this.address,
      balance: balance ?? this.balance,
    );
  }

  /// Convenience getter to determine whether the current user is empty.
  bool get isEmpty => this == UserModel.empty;

  /// Convenience getter to determine whether the current user is not empty.
  bool get isNotEmpty => this != UserModel.empty;

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      email: email,
      image: image,
      address: address,
      balance: balance,
    );
  }

  static UserModel fromEntity(UserEntity entity) {
    return UserModel(
        id: entity.id,
        name: entity.name,
        email: entity.email,
        image: entity.image,
        address: entity.address,
        balance: entity.balance
    );
  }

  @override
  List<Object?> get props => [id, name, email, image, address, balance];
}