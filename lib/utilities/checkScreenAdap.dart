import 'dart:ui' as ui;

class CheckDeviceScreen{
  bool CheckDeviceScreenPT(){

    bool isTablet;
    //bool isPhone;

    final double devicePixelRatio = ui.window.devicePixelRatio;
    final ui.Size size = ui.window.physicalSize;
    final double width = size.width;
    final double height = size.height;


    if(devicePixelRatio < 2 && (width >= 1000 || height >= 1000)) {
      isTablet = true;
     // isPhone = false;
    }
    else if(devicePixelRatio == 2 && (width >= 1920 || height >= 1920)) {
      isTablet = true;
      //isPhone = false;
    }
    else {
      isTablet = false;
     // isPhone = true;
    }
    return isTablet;
  }

}