import 'package:encrypt/encrypt.dart';
import 'package:woo_shop/common/index.dart';

class EncryptUtil {
  static final EncryptUtil _instance = EncryptUtil._internal();
  factory EncryptUtil() => _instance;
  EncryptUtil._internal() {
    encrypter = Encrypter(AES(
      key,
      mode: AESMode.cbc,
      padding: 'PKCS7',
    ));
  }

  final key = Key.fromUtf8(Constants.aesKey);
  final iv = IV.fromUtf8(Constants.aesIV);
  late Encrypter encrypter;

  /// aes加密
  String aesEncode(String content) {
    final encrypted = encrypter.encrypt(content, iv: iv);
    return encrypted.base64;
  }
}
