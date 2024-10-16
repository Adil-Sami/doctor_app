
import 'package:intl/intl.dart';

extension general on String {
  String limitChars(int chars){
    if(this.length > chars){
      return this.substring(0,chars) + '...';
    }
    else{
      return this;
    }
  }
}
