import 'package:fam_coding_supply/fam_coding_supply.dart';
import 'package:flutter_todolist_app/env.dart';

class AppInitConfig {
  static FamCodingSupply famCodingSupply = FamCodingSupply();
  static AppApiServiceCS appApiService = AppApiServiceCS(EnvironmentConfig.baseUrl());
  Future<void> init() async {
    AppLoggerCS.useLogger = true;
    // await famCodingSupply.appInfo.init();
    await famCodingSupply.appConnectivityService.init();
    // await famCodingSupply.appDeviceInfo.getDeviceData();
    EnvironmentConfig.customBaseUrl = "https://271c-114-10-42-224.ngrok-free.app";
  }
}
