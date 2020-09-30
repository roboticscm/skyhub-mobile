package vn.com.skyhub;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.os.Build;

import io.flutter.app.FlutterApplication;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugins.GeneratedPluginRegistrant;

import static vn.com.skyhub.MainActivity.CHANNEL;

public class App extends FlutterApplication implements PluginRegistry.PluginRegistrantCallback {
    public static final String CHANNEL_ID = "skyMobileServiceChannel";

    @Override
    public void onCreate() {
        super.onCreate();
        createNotificationChannel();
    }

    private void createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O){
            NotificationChannel channel = new NotificationChannel(
                    CHANNEL_ID, "Sky mobile Service", NotificationManager.IMPORTANCE_DEFAULT);
            NotificationManager manager = getSystemService(NotificationManager.class);
            manager.createNotificationChannel(channel);
        }
    }

    @Override
    public void registerWith(PluginRegistry registry) {
        GeneratedPluginRegistrant.registerWith(registry);
//        MethodChannel channel = new MethodChannel(registry.registrarFor(CHANNEL).messenger(), CHANNEL);

//        channel.invokeMethod("systemTimer", null);
    }
}
