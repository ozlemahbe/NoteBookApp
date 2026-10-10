import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:cryptography/cryptography.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  test('Crypto Spike - AES-256-GCM and Key Wrapping', () async {
    // 1. Generate a secure vault key (User Data Key)
    final algorithm = AesGcm.with256bits();
    final secretKey = await algorithm.newSecretKey();
    
    // 2. Encrypt some data
    final clearText = utf8.encode('Sensitive Note Content');
    final nonce = algorithm.newNonce();
    // Simulate AAD
    final aad = utf8.encode('user123_noteId456_v1');
    
    final secretBox = await algorithm.encrypt(
      clearText,
      secretKey: secretKey,
      nonce: nonce,
      aad: aad,
    );
    
    expect(secretBox.cipherText, isNot(equals(clearText)));
    
    // 3. Decrypt the data
    final decryptedText = await algorithm.decrypt(
      secretBox,
      secretKey: secretKey,
      aad: aad,
    );
    
    expect(utf8.decode(decryptedText), equals('Sensitive Note Content'));
    
    // 4. KDF (Argon2id) for vault password wrapping
    final kdf = Argon2id(
      memory: 10000,
      iterations: 2,
      parallelism: 1,
      hashLength: 32,
    );
    final salt = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16];
    final passwordKey = await kdf.deriveKey(
      secretKey: SecretKey(utf8.encode('my_strong_vault_password')),
      nonce: salt,
    );
    
    final passwordKeyData = await passwordKey.extractBytes();
    expect(passwordKeyData.length, equals(32)); // 256 bits

    // 5. Mock Secure Storage
    FlutterSecureStorage.setMockInitialValues({});
    const storage = FlutterSecureStorage();
    final keyBytes = await secretKey.extractBytes();
    await storage.write(key: 'vault_key_1', value: base64Encode(keyBytes));
    
    final readKey = await storage.read(key: 'vault_key_1');
    expect(readKey, isNotNull);
    expect(base64Decode(readKey!), equals(keyBytes));
  });
}
