import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String uid;
  final String email;
  final String? fullName;
  final String? phoneNumber;
  final String? address;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? bloodType;
  final List<String>? allergies;
  final List<String>? medications;
  final List<String>? medicalConditions;
  final Map<String, dynamic>? emergencyContact;
  final Map<String, dynamic>? healthMetrics;
  final DateTime? lastTestDate;
  final List<Map<String, dynamic>>? healthHistory;

  UserModel({
    required this.uid,
    required this.email,
    this.fullName,
    this.phoneNumber,
    this.address,
    this.dateOfBirth,
    this.gender,
    this.bloodType,
    this.allergies,
    this.medications,
    this.medicalConditions,
    this.emergencyContact,
    this.healthMetrics,
    this.lastTestDate,
    this.healthHistory,
  });

  // Factory constructor to create a UserModel from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String,
      email: json['email'] as String,
      fullName: json['fullName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? (json['dateOfBirth'] is Timestamp
              ? (json['dateOfBirth'] as Timestamp).toDate()
              : (json['dateOfBirth'] is String
                  ? DateTime.parse(json['dateOfBirth'])
                  : null))
          : null,
      gender: json['gender'] as String?,
      bloodType: json['bloodType'] as String?,
      allergies: json['allergies'] != null
          ? List<String>.from(json['allergies'])
          : null,
      medications: json['medications'] != null
          ? List<String>.from(json['medications'])
          : null,
      medicalConditions: json['medicalConditions'] != null
          ? List<String>.from(json['medicalConditions'])
          : null,
      emergencyContact: json['emergencyContact'] as Map<String, dynamic>?,
      healthMetrics: json['healthMetrics'] as Map<String, dynamic>?,
      lastTestDate: json['lastTestDate'] != null
          ? (json['lastTestDate'] is Timestamp
              ? (json['lastTestDate'] as Timestamp).toDate()
              : DateTime.parse(json['lastTestDate'].toString()))
          : null,
      healthHistory: json['healthHistory'] != null
          ? List<Map<String, dynamic>>.from(json['healthHistory'])
          : null,
    );
  }

  // Method to convert UserModel to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'address': address,
      'dateOfBirth':
          dateOfBirth != null ? Timestamp.fromDate(dateOfBirth!) : null,
      'gender': gender,
      'bloodType': bloodType,
      'allergies': allergies,
      'medications': medications,
      'medicalConditions': medicalConditions,
      'emergencyContact': emergencyContact,
      'healthMetrics': healthMetrics,
      'lastTestDate':
          lastTestDate != null ? Timestamp.fromDate(lastTestDate!) : null,
      'healthHistory': healthHistory,
    };
  }

  // Create a copy of this UserModel with optional new values
  UserModel copyWith({
    String? uid,
    String? email,
    String? fullName,
    String? phoneNumber,
    String? address,
    DateTime? dateOfBirth,
    String? gender,
    String? bloodType,
    List<String>? allergies,
    List<String>? medications,
    List<String>? medicalConditions,
    Map<String, dynamic>? emergencyContact,
    Map<String, dynamic>? healthMetrics,
    DateTime? lastTestDate,
    List<Map<String, dynamic>>? healthHistory,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      address: address ?? this.address,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      bloodType: bloodType ?? this.bloodType,
      allergies: allergies ?? this.allergies,
      medications: medications ?? this.medications,
      medicalConditions: medicalConditions ?? this.medicalConditions,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      healthMetrics: healthMetrics ?? this.healthMetrics,
      lastTestDate: lastTestDate ?? this.lastTestDate,
      healthHistory: healthHistory ?? this.healthHistory,
    );
  }
}
