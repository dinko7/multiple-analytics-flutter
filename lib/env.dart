import 'package:envied/envied.dart';

part 'env.g.dart';

@envied
abstract class Env {
  @EnviedField(varName: 'MIXPANEL_TOKEN')
  static const String mixpanelToken = _Env.mixpanelToken;
}