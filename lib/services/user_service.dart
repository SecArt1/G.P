import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bio_track/models/user_model.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('users');

  // Cached user data
  final Map<String, UserModel> _cachedUserData = {};

  // Create new user document with better debugging
  Future<void> createUser(User user, String displayName) async {
    try {
      print("Creating Firestore user document for uid: ${user.uid}");
      final userData = {
        'fullName': displayName,
        'email': user.email ?? '',
        'createdAt': Timestamp.now(),
      };

      print("Data to save: $userData");
      await _firestore.collection('users').doc(user.uid).set(userData);
      print("User document created successfully");
    } catch (e) {
      print("Error creating user document: $e");
      throw e;
    }
  }

  // Get current user data with better debugging
  Future<UserModel> getCurrentUser({bool forceRefresh = false}) async {
    // Get the current Firebase user
    final firebaseUser = FirebaseAuth.instance.currentUser;

    // Check if we have a logged-in user
    if (firebaseUser == null) {
      throw Exception('No user logged in');
    }

    // Clear any cached user data if force refresh is requested
    if (forceRefresh) {
      _cachedUserData.remove(firebaseUser.uid);
    }

    // Try to get user data from Firestore
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        // Create UserModel from Firestore data
        final userData = userDoc.data()!;

        // Store in cache for future use
        final user = UserModel.fromJson({
          'uid': firebaseUser.uid,
          'email': firebaseUser.email,
          ...userData,
        });

        _cachedUserData[firebaseUser.uid] = user;
        return user;
      } else {
        // Return basic user if Firestore profile doesn't exist yet
        return UserModel(
          uid: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          fullName: firebaseUser.displayName,
        );
      }
    } catch (e) {
      print('Error fetching user data: $e');
      // Return basic user on error
      return UserModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        fullName: firebaseUser.displayName,
      );
    }
  }

  // Update user profile
  Future<void> updateUserProfile(Map<String, dynamic> data) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _usersCollection.doc(user.uid).update(data);
  }

  // Add medical information
  Future<void> addMedicalInfo(Map<String, dynamic> medicalData) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _usersCollection.doc(user.uid).update({
      'medicalInfo': medicalData,
    });
  }

  // Update health metrics
  Future<void> updateHealthMetrics(Map<String, dynamic> metrics) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(user.uid);

      // Get current data to update history
      final docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        final userData = docSnapshot.data() as Map<String, dynamic>;

        // Add timestamp to metrics
        metrics['recordedAt'] = Timestamp.now();

        // Create/update health history
        List<Map<String, dynamic>> healthHistory = [];
        if (userData['healthHistory'] != null) {
          healthHistory =
              List<Map<String, dynamic>>.from(userData['healthHistory']);
        }
        healthHistory.add(metrics);

        // Update document with new metrics and history
        await docRef.update({
          'healthMetrics': metrics,
          'healthHistory': healthHistory,
          'lastUpdated': Timestamp.now(),
        });
      } else {
        // If document doesn't exist, create it
        await docRef.set({
          'healthMetrics': metrics,
          'healthHistory': [metrics],
          'createdAt': Timestamp.now(),
          'lastUpdated': Timestamp.now(),
        });
      }
    } catch (e) {
      print("Error updating health metrics: $e");
      throw e;
    }
  }

  // Update medical information
  Future<void> updateMedicalInfo(Map<String, dynamic> medicalInfo) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        ...medicalInfo,
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      print("Error updating medical info: $e");
      throw e;
    }
  }

  // Update user profile with timestamp
  Future<void> updateUserProfileWithTimestamp(
      Map<String, dynamic> profileData) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        ...profileData,
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      print("Error updating user profile: $e");
      throw e;
    }
  }

  // Add fitness goals
  Future<void> setFitnessGoals(Map<String, dynamic> goals) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'fitnessGoals': goals,
        'lastUpdated': Timestamp.now(),
      });
    } catch (e) {
      print("Error setting fitness goals: $e");
      throw e;
    }
  }
}
