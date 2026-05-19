import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String name;
  final String photoUrl;
  final String role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final DateTime? lastLogoutAt;

  UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl = '',
    this.role = 'user',
    this.isActive = true,
    required this.createdAt,
    required this.lastLoginAt,
    this.lastLogoutAt,
  });

  factory UserModel.fromMap(
    Map<String, dynamic> data,
    String id,
  ) {
    return UserModel(
      uid: id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      photoUrl: data['photoUrl'] ?? '',
      role: data['role'] ?? 'user',
      isActive: data['isActive'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      lastLoginAt: (data['lastLoginAt'] as Timestamp).toDate(),
      lastLogoutAt: data['lastLogoutAt'] != null
          ? (data['lastLogoutAt'] as Timestamp).toDate()
          : null,
    );
  }

  factory UserModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    return UserModel.fromMap(
      doc.data() as Map<String, dynamic>,
      doc.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'role': role,
      'isActive': isActive,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'lastLogoutAt': lastLogoutAt,
    };
  }

  UserModel copyWith({
    String? name,
    String? photoUrl,
    String? role,
    bool? isActive,
    DateTime? lastLoginAt,
    DateTime? lastLogoutAt,
  }) {
    return UserModel(
      uid: uid,
      email: email,
      name: name ?? this.name,
      photoUrl: photoUrl ?? this.photoUrl,
      role: role ?? this.role,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      lastLogoutAt: lastLogoutAt ?? this.lastLogoutAt,
    );
  }

  static UserModel fromFirebaseUser(
    User user,
    String name,
  ) {
    final now = DateTime.now();

    return UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: name,
      photoUrl: user.photoURL ?? '',
      createdAt: now,
      lastLoginAt: now,
    );
  }
}

class UserService {
  static final _firestore = FirebaseFirestore.instance;

  static final _auth = FirebaseAuth.instance;

  static CollectionReference get _users => _firestore.collection('users');

  static String? get _uid => _auth.currentUser?.uid;

  static DocumentReference get _doc => _users.doc(_uid);

  // حفظ مستخدم
  static Future<void> saveUser(
    UserModel user,
  ) async {
    await _users.doc(user.uid).set(user.toMap());
  }

  // إنشاء مستخدم جديد
  static Future<void> createUser(
    User firebaseUser,
    String name,
  ) async {
    final user = UserModel.fromFirebaseUser(
      firebaseUser,
      name,
    );

    await saveUser(user);
  }

  // جلب المستخدم الحالي
  static Future<UserModel?> getCurrentUser() async {
    if (_uid == null) return null;

    final doc = await _doc.get();

    if (!doc.exists) return null;

    return UserModel.fromFirestore(doc);
  }

  // تحديث الاسم
  static Future<void> updateName(
    String name,
  ) async {
    if (_uid == null) return;

    await _auth.currentUser?.updateDisplayName(name);

    await _doc.update({
      'name': name,
    });
  }

  // تحديث وقت الدخول
  static Future<void> updateLoginTime() async {
    if (_uid == null) return;

    await _doc.update({
      'lastLoginAt': Timestamp.now(),
    });
  }

  // تحديث وقت الخروج
  static Future<void> updateLogoutTime() async {
    if (_uid == null) return;

    await _doc.update({
      'lastLogoutAt': Timestamp.now(),
    });
  }

  // بث مباشر للمستخدم
  static Stream<UserModel?> userStream() {
    if (_uid == null) {
      return Stream.value(null);
    }

    return _doc.snapshots().map((doc) {
      if (!doc.exists) return null;

      return UserModel.fromFirestore(doc);
    });
  }
}
