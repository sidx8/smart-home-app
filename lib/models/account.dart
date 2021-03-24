import 'dart:convert';

class Account {
  String userName;
  String emailId;
  String userId;
  String phoneNumber;
  String address;
  DateTime connectionDate;
  String authorizationDocumentId;
  int authorizationDocumentType;

  Account(
      {this.userName,
      this.emailId,
      this.userId,
      this.phoneNumber,
      this.address,
      this.connectionDate,
      this.authorizationDocumentId,
      this.authorizationDocumentType});

  Account copyWith({
    String userName,
    String emailId,
    String userId,
    String phoneNumber,
    String address,
    DateTime connectionDate,
  }) {
    return Account(
      userName: userName ?? this.userName,
      emailId: emailId ?? this.emailId,
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      connectionDate: connectionDate ?? this.connectionDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userName': userName,
      'emailId': emailId,
      'userId': userId,
      'phoneNumber': phoneNumber,
      'address': address,
      'connectionDate': connectionDate?.millisecondsSinceEpoch,
      'authorizationId': authorizationDocumentId,
      'authorizationType': authorizationDocumentType,
    };
  }

  factory Account.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return Account(
      userName: map['userName'] ?? '',
      emailId: map['emailId'] ?? '',
      userId: map['userId'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      address: map['address'] ?? '',
      connectionDate:
          DateTime.fromMillisecondsSinceEpoch(map['connectionDate']),
      authorizationDocumentType: map['authorizationType'] ?? 0,
      authorizationDocumentId: map['authorizationId'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Account.fromJson(String source) =>
      Account.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Account(userName: $userName, emailId: $emailId, userId: $userId, phoneNumber: $phoneNumber, address: $address, connectionDate: $connectionDate)';
  }
}
