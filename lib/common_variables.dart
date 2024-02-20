import 'package:flutter/cupertino.dart';
import 'package:rna/widgets/input_sup.dart';
import 'package:rna/widgets/input_vanc.dart';

import 'objects/service.dart';
import 'objects/user_input.dart';

class CommonVariables{
  static Service? service;
  static UserInput? userInput;
  static Widget drugWidget = const InputVancomycinWidget();
  static Widget serviceInputWidget = const InputSupplementaryWidget();

}