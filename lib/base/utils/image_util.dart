import 'dart:io';
// import 'package:g_base_package/base/utils/logger.dart';
// import 'package:exif/exif.dart';
// import 'package:image/image.dart' as img;

class ImageUtil{

  ///This is example code how to rotate images taken from the camera with
  ///wrong orientation.
  ///Usually happens on a Samsung devices.
  ///Example : the user is taking an image in portrait mode,
  ///but the camera returns the file with wrong orientation as
  ///meta data. So we end up with profile image rotated 90 degrees.
  ///
  ///To implement this code in your app, you need to add
  ///exif: ^1.0.3 and image: ^2.1.12 (or newest) packages as dependency
  Future<File> fixExifRotation(String imagePath) async {
    // final originalFile = File(imagePath);
    // List<int> imageBytes = await originalFile.readAsBytes();
    //
    // final originalImage = img.decodeImage(imageBytes);
    //
    // final height = originalImage.height;
    // final width = originalImage.width;
    //
    // // Let's check for the image size
    // if (height >= width) {
    //   // I'm interested in portrait photos so
    //   // I'll just return here
    //   return originalFile;
    // }
    //
    // // We'll use the exif package to read exif data
    // // This is map of several exif properties
    // // Let's check 'Image Orientation'
    // final exifData = await readExifFromBytes(imageBytes);
    //
    // img.Image fixedImage;
    //
    // if (exifData != null) {
    //   Log.d('Rotating image necessary');
    //   // rotate
    //   if (exifData['Image Orientation'].printable.contains('Horizontal')) {
    //     fixedImage = img.copyRotate(originalImage, 90);
    //   } else if (exifData['Image Orientation'].printable.contains('180')) {
    //     fixedImage = img.copyRotate(originalImage, -90);
    //   } else {
    //     fixedImage = img.copyRotate(originalImage, 0);
    //   }
    // }else{
    //   Log.d('no exif data');
    // }
    //
    // // Here you can select whether you'd like to save it as png
    // // or jpg with some compression
    // // I choose jpg with 100% quality
    // final fixedFile = await originalFile.writeAsBytes(img.encodeJpg(fixedImage));
    //
    // return fixedFile;
    return null;
  }
}