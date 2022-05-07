import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as _fbstorage;

class UtilsSv {
  Future<String> uploadFile(File _image, String path) async {
    _fbstorage.Reference storageRefence =
        _fbstorage.FirebaseStorage.instance.ref(path);

    _fbstorage.UploadTask uploadTask = storageRefence.putFile(_image);
    await uploadTask.whenComplete(() => null);
    String returnUrl = '';
    await storageRefence.getDownloadURL().then((fileUrl) {
      returnUrl = fileUrl;
    });
    return returnUrl;
  }
}
