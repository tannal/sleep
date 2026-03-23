// lib/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// ─── Supabase Client ──────────────────────────────────────────────────────────

final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ─── Auth State ───────────────────────────────────────────────────────────────

final authStateProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

final currentUserProvider = Provider<User?>((ref) {
  return Supabase.instance.client.auth.currentUser;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// ─── User Profile ─────────────────────────────────────────────────────────────

final userProfileProvider =
    FutureProvider.autoDispose<Map<String, dynamic>?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  final data = await Supabase.instance.client
      .from('user_profiles')
      .select()
      .eq('id', user.id)
      .maybeSingle();

  return data as Map<String, dynamic>?;
});

class UserProfileNotifier
    extends StateNotifier<AsyncValue<Map<String, dynamic>?>> {
  UserProfileNotifier(this._client, this._userId)
      : super(const AsyncValue.loading()) {
    _load();
  }

  final SupabaseClient _client;
  final String _userId;

  Future<void> _load() async {
    try {
      final data = await _client
          .from('user_profiles')
          .select()
          .eq('id', _userId)
          .maybeSingle();
      state = AsyncValue.data(data as Map<String, dynamic>?);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> update(Map<String, dynamic> updates) async {
    await _client
        .from('user_profiles')
        .update({...updates, 'updated_at': DateTime.now().toIso8601String()})
        .eq('id', _userId);
    await _load();
  }
}

final userProfileNotifierProvider = StateNotifierProvider.autoDispose<
    UserProfileNotifier, AsyncValue<Map<String, dynamic>?>>(
  (ref) {
    final user = ref.watch(currentUserProvider);
    final client = ref.watch(supabaseClientProvider);
    return UserProfileNotifier(client, user?.id ?? '');
  },
);
