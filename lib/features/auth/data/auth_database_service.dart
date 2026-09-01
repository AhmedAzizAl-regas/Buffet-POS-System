import 'package:buffet_app/core/database/database_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthDatabaseService {
  final DatabaseService _dbService;

  AuthDatabaseService(this._dbService);

  /// Find a user record by email address.
  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = _dbService.db;
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email.trim().toLowerCase()],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  /// Get the first (and usually only) registered user.
  Future<Map<String, dynamic>?> getFirstUser() async {
    final db = _dbService.db;
    final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
    if (maps.isNotEmpty) return maps.first;
    return null;
  }

  /// Registers a new user in the database.
  Future<int> registerUser({
    required String fullName,
    required String phoneNumber,
    required String countryCode,
    required String email,
    required String password,
  }) async {
    final db = _dbService.db;
    return await db.insert('users', {
      'full_name': fullName.trim(),
      'phone_number': phoneNumber.trim(),
      'country_code': countryCode.trim(),
      'email': email.trim().toLowerCase(),
      'password': password, // Store password (plaintext or basic hash is fine for simple local offline db)
    });
  }

  /// Updates the account info (name, phone, email). Does NOT touch password.
  Future<void> updateUser({
    required int id,
    required String fullName,
    required String phoneNumber,
    required String countryCode,
    required String email,
  }) async {
    final db = _dbService.db;
    await db.update(
      'users',
      {
        'full_name': fullName.trim(),
        'phone_number': phoneNumber.trim(),
        'country_code': countryCode.trim(),
        'email': email.trim().toLowerCase(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Changes the password for a given user ID.
  Future<bool> changePassword({
    required int id,
    required String currentPassword,
    required String newPassword,
  }) async {
    final db = _dbService.db;
    // Verify current password first
    final maps = await db.query('users', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return false;
    final storedPwd = maps.first['password'] as String? ?? '';
    if (storedPwd != currentPassword) return false;
    // Update password
    await db.update('users', {'password': newPassword}, where: 'id = ?', whereArgs: [id]);
    return true;
  }
}

final authDatabaseServiceProvider = Provider<AuthDatabaseService>((ref) {
  final dbService = ref.watch(databaseServiceProvider);
  return AuthDatabaseService(dbService);
});

/// Provider to reactively read the first account (invalidated after save)
final accountInfoProvider = FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final svc = ref.watch(authDatabaseServiceProvider);
  return await svc.getFirstUser();
});

