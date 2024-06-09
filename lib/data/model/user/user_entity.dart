import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? image;
  final String? address;
  final int? balance;

  const UserEntity({
    required this.id,
    required this.name,
    required this.email,
    this.image,
    this.address,
    this.balance
  });

  Map<String, Object?> toDocument() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'image': image,
      'address': address,
      'balance': balance,
    };
  }

  static UserEntity fromDocument(Map<String, dynamic> doc) {
    return UserEntity(
      id: doc['id'] as String,
      name: doc['name'] as String,
      email: doc['email'] as String,
      image: doc['image'] as String?,
      address: doc['address'] as String?,
      balance: doc['balance'],
    );
  }

  @override
  List<Object?> get props => [id, name, email, image, address, balance];

  @override
  String toString() {
    return '''UserEntity: {
      id: $id
      name: $name
      email: $email
      image: $image
      address: $address
      balance: $balance
    }''';
  }
}