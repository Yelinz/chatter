import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'OPENAI_KEY', obfuscate: true)
  static final openAiKey = _Env.openAiKey;
  @EnviedField(varName: 'AZURE_KEY', obfuscate: true)
  static final azureKey = _Env.azureKey;
  @EnviedField(varName: 'DEEPL_KEY', obfuscate: true)
  static final deeplKey = _Env.deeplKey;
  @EnviedField(varName: "GCP_KEY", obfuscate: true)
  static final gcpKey = _Env.gcpKey;
}
