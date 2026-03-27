import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  SupabaseService._();

  static final SupabaseService instance = SupabaseService._();

  late SupabaseClient _client;

  SupabaseClient get client => _client;

  Future<void> initialize({
    required String supabaseUrl,
    required String supabaseAnonKey,
  }) async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
    _client = Supabase.instance.client;
  }

  // Upload file to storage
  Future<String> uploadFile({
    required String bucket,
    required String filePath,
    required Uint8List fileData,
  }) async {
    final path = await _client.storage
        .from(bucket)
        .uploadBinary(filePath, fileData);
    return path;
  }

  // Get public URL for file
  String getPublicUrl({required String bucket, required String filePath}) {
    final url = _client.storage.from(bucket).getPublicUrl(filePath);
    return url;
  }

  // Delete file from storage
  Future<void> deleteFile({
    required String bucket,
    required String filePath,
  }) async {
    await _client.storage.from(bucket).remove([filePath]);
  }
}
