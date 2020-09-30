package io.flutter.plugins;

import io.flutter.plugin.common.PluginRegistry;
import xyz.luan.audioplayers.AudioplayersPlugin;
import io.flutter.plugins.connectivity.ConnectivityPlugin;
import io.flutter.plugins.deviceinfo.DeviceInfoPlugin;
import com.example.devicelocale.DevicelocalePlugin;
import fr.g123k.flutterappbadger.FlutterAppBadgerPlugin;
import com.amolg.flutterbarcodescanner.FlutterBarcodeScannerPlugin;
import com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin;
import com.octapush.moneyformatter.fluttermoneyformatter.FlutterMoneyFormatterPlugin;
import de.gigadroid.flutterudid.FlutterUdidPlugin;
import com.cloudwebrtc.webrtc.FlutterWebRTCPlugin;
import com.github.adee42.keyboardvisibility.KeyboardVisibilityPlugin;
import io.flutter.plugins.pathprovider.PathProviderPlugin;
import com.baseflow.permissionhandler.PermissionHandlerPlugin;
import flutter.plugins.screen.screen.ScreenPlugin;
import io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin;
import com.cloudwebrtc.flutterincallmanager.FlutterIncallManagerPlugin;

/**
 * Generated file. Do not edit.
 */
public final class GeneratedPluginRegistrant {
  public static void registerWith(PluginRegistry registry) {
    if (alreadyRegisteredWith(registry)) {
      return;
    }
    AudioplayersPlugin.registerWith(registry.registrarFor("xyz.luan.audioplayers.AudioplayersPlugin"));
    ConnectivityPlugin.registerWith(registry.registrarFor("io.flutter.plugins.connectivity.ConnectivityPlugin"));
    DeviceInfoPlugin.registerWith(registry.registrarFor("io.flutter.plugins.deviceinfo.DeviceInfoPlugin"));
    DevicelocalePlugin.registerWith(registry.registrarFor("com.example.devicelocale.DevicelocalePlugin"));
    FlutterAppBadgerPlugin.registerWith(registry.registrarFor("fr.g123k.flutterappbadger.FlutterAppBadgerPlugin"));
    FlutterBarcodeScannerPlugin.registerWith(registry.registrarFor("com.amolg.flutterbarcodescanner.FlutterBarcodeScannerPlugin"));
    FlutterLocalNotificationsPlugin.registerWith(registry.registrarFor("com.dexterous.flutterlocalnotifications.FlutterLocalNotificationsPlugin"));
    FlutterMoneyFormatterPlugin.registerWith(registry.registrarFor("com.octapush.moneyformatter.fluttermoneyformatter.FlutterMoneyFormatterPlugin"));
    FlutterUdidPlugin.registerWith(registry.registrarFor("de.gigadroid.flutterudid.FlutterUdidPlugin"));
    FlutterWebRTCPlugin.registerWith(registry.registrarFor("com.cloudwebrtc.webrtc.FlutterWebRTCPlugin"));
    KeyboardVisibilityPlugin.registerWith(registry.registrarFor("com.github.adee42.keyboardvisibility.KeyboardVisibilityPlugin"));
    PathProviderPlugin.registerWith(registry.registrarFor("io.flutter.plugins.pathprovider.PathProviderPlugin"));
    PermissionHandlerPlugin.registerWith(registry.registrarFor("com.baseflow.permissionhandler.PermissionHandlerPlugin"));
    ScreenPlugin.registerWith(registry.registrarFor("flutter.plugins.screen.screen.ScreenPlugin"));
    SharedPreferencesPlugin.registerWith(registry.registrarFor("io.flutter.plugins.sharedpreferences.SharedPreferencesPlugin"));
    FlutterIncallManagerPlugin.registerWith(registry.registrarFor("com.cloudwebrtc.flutterincallmanager.FlutterIncallManagerPlugin"));
  }

  private static boolean alreadyRegisteredWith(PluginRegistry registry) {
    final String key = GeneratedPluginRegistrant.class.getCanonicalName();
    if (registry.hasPlugin(key)) {
      return true;
    }
    registry.registrarFor(key);
    return false;
  }
}
