import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/order_request_model.dart';

class DraftRepository {
  static const String _draftKey = 'bhumipun_order_draft_v1';
  final SharedPreferences? _prefsInstance;

  DraftRepository([this._prefsInstance]);

  Future<SharedPreferences> _getPrefs() async {
    return _prefsInstance ?? await SharedPreferences.getInstance();
  }

  /// Persists current order request form fields and document metadata.
  Future<bool> saveDraft(OrderRequestModel draft) async {
    try {
      final prefs = await _getPrefs();
      final jsonString = jsonEncode(draft.toJson());
      return await prefs.setString(_draftKey, jsonString);
    } catch (e) {
      debugPrint('Error saving draft: $e');
      return false;
    }
  }

  /// Restores saved draft and verifies file accessibility on disk.
  Future<OrderRequestModel?> loadDraft() async {
    try {
      final prefs = await _getPrefs();
      final jsonString = prefs.getString(_draftKey);
      if (jsonString == null || jsonString.isEmpty) {
        return null;
      }

      final Map<String, dynamic> jsonMap =
          jsonDecode(jsonString) as Map<String, dynamic>;
      var draft = OrderRequestModel.fromJson(jsonMap);

      // Verify accessibility of documents on device filesystem
      if (!kIsWeb) {
        if (draft.aadhaarDoc != null) {
          final isAccessible = _checkFileAccessible(draft.aadhaarDoc!.path);
          draft = draft.copyWith(
            aadhaarDoc: draft.aadhaarDoc!.copyWith(isAccessible: isAccessible),
          );
        }
        if (draft.supportingDoc != null) {
          final isAccessible = _checkFileAccessible(draft.supportingDoc!.path);
          draft = draft.copyWith(
            supportingDoc: draft.supportingDoc!.copyWith(
              isAccessible: isAccessible,
            ),
          );
        }
      }

      return draft;
    } catch (e) {
      debugPrint('Error loading draft: $e');
      return null;
    }
  }

  /// Clears the stored draft from local storage.
  Future<bool> clearDraft() async {
    try {
      final prefs = await _getPrefs();
      return await prefs.remove(_draftKey);
    } catch (e) {
      debugPrint('Error clearing draft: $e');
      return false;
    }
  }

  /// Checks if draft data exists in storage.
  Future<bool> hasDraft() async {
    try {
      final prefs = await _getPrefs();
      return prefs.containsKey(_draftKey);
    } catch (e) {
      return false;
    }
  }

  bool _checkFileAccessible(String? path) {
    if (path == null || path.isEmpty) return false;
    try {
      final file = File(path);
      return file.existsSync();
    } catch (_) {
      return false;
    }
  }
}
