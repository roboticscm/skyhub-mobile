package vn.com.skyhub;

import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.core.content.ContextCompat;
import android.util.Log;
import java.util.ArrayList;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import android.os.PowerManager.WakeLock;
import android.os.PowerManager;
import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.view.FlutterCallbackInformation;
import io.flutter.view.FlutterMain;
import io.flutter.view.FlutterNativeView;
import io.flutter.view.FlutterRunArguments;

public class MainActivity extends FlutterActivity implements MethodChannel.MethodCallHandler  {
  public static final String CHANNEL = "vn.com.sky.native";
  static private MethodChannel methodChannel;
  private  WakeLock wakeLock;
  private  PowerManager powerManager;
  @SuppressWarnings("unchecked")
  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
    methodChannel = new MethodChannel(getFlutterView(), CHANNEL);
    methodChannel.setMethodCallHandler(this::onMethodCall);

    powerManager = (PowerManager) getSystemService(POWER_SERVICE);
    wakeLock = powerManager.newWakeLock(PowerManager.SCREEN_DIM_WAKE_LOCK | PowerManager.ACQUIRE_CAUSES_WAKEUP,
          "Skyhub::websocketTag");
    //turnOnScreen();
  }
  @SuppressWarnings("unchecked")
  @Override
  public void onMethodCall(MethodCall call, MethodChannel.Result result) {

    try {
      if (call.method.equals("sendAppToBackground")) {
        moveTaskToBack(true);
        result.success(true);
      } else if (call.method.equals("showMainActivity")) {
        forceShowMainActivity();
        result.success(true);
      } else if (call.method.equals("startService")) {
        startService(this);
        result.success(true);
      } else if (call.method.equals("stopService")) {
        stopService();
        result.success(true);
      } else if (call.method.equals("turnOnScreen")) {
        turnOnScreen();
        result.success(true);
      }
      else if (call.method.equals("turnOffScreen")) {
        turnOffScreen();
        result.success(true);
      }
      else if (call.method.equals("createNativeView")) {
        Long handle = call.argument("handle");
        createNativeView(handle,this);
        result.success(true);
      }
      else {
        result.notImplemented();
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
  }

  public void forceShowMainActivity() {
    Intent intent = new Intent(this, MainActivity.class);
    intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    this.startActivity(intent);
  }

  static public Boolean showMainActivity(Context context) {
    if(!isRunning(context)) {
      Intent intent = new Intent(context, MainActivity.class);
      intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
      intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
      context.startActivity(intent);
      return true;
    }

    return false;
  }

  static private boolean isRunning(Context ctx) {
    ActivityManager activityManager = (ActivityManager) ctx.getSystemService(Context.ACTIVITY_SERVICE);
    List<ActivityManager.RunningTaskInfo> tasks = activityManager.getRunningTasks(Integer.MAX_VALUE);

    for (ActivityManager.RunningTaskInfo task : tasks) {
      if (ctx.getPackageName().equalsIgnoreCase(task.baseActivity.getPackageName()))
        return true;
    }

    return false;
  }

  public static void createNativeView(Long handle, Context context) {
    String args[] = getArgsFromIntent(((Activity)context).getIntent());

    FlutterMain.ensureInitializationComplete(context, args);

    FlutterNativeView nativeView = new FlutterNativeView(context, true);

    FlutterCallbackInformation callback = FlutterCallbackInformation.lookupCallbackInformation(handle);
    FlutterRunArguments flutterRunArguments = new FlutterRunArguments();

    flutterRunArguments.bundlePath = FlutterMain.findAppBundlePath(context);
    flutterRunArguments.libraryPath = callback.callbackLibraryPath;
    flutterRunArguments.entrypoint = callback.callbackName;

    nativeView.runFromBundle(flutterRunArguments);
  }

  static private String[] getArgsFromIntent(Intent intent) {
    // Before adding more entries to this list, consider that arbitrary
    // Android applications can generate intents with extra data and that
    // there are many security-sensitive args in the binary.
    ArrayList<String> args = new ArrayList<>();
    if (intent.getBooleanExtra("trace-startup", false)) {
      args.add("--trace-startup");
    }
    if (intent.getBooleanExtra("start-paused", false)) {
      args.add("--start-paused");
    }
    if (intent.getBooleanExtra("enable-dart-profiling", false)) {
      args.add("--enable-dart-profiling");
    }
    if (!args.isEmpty()) {
      String[] argsArray = new String[args.size()];
      return args.toArray(argsArray);
    }
    return null;
  }

  static public void startService(Context context) {
    Intent intent = new Intent(context, SkyService.class);
    ContextCompat.startForegroundService(context, intent);
    TimerTask timerTask = new TimerTask() {
      @Override
      public void run() {
        showMainActivity(context);
      }
    };
    Timer timer = new Timer();
    timer.scheduleAtFixedRate(timerTask, 60000, 60000);
  }

  private void stopService() {
    Intent intent = new Intent(this, SkyService.class);
    stopService(intent);
  }

  private void turnOnScreen() {
    PowerManager pm = (PowerManager) getSystemService(Context.POWER_SERVICE);
    boolean isScreenOn = pm.isScreenOn();

    if (Build.VERSION.SDK_INT >= 21){
      isScreenOn = pm.isInteractive();
    }


    if(wakeLock.isHeld() == false && isScreenOn == false ) {
      wakeLock.acquire();
      Log.v("wakeLock", "Turn on screen");
    }
    //wakeLock.acquire();
    //if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
     // this.setTurnScreenOn(true);
   // } else {

     // print("owejfwefwewefewfffffff");
//      WindowManager.LayoutParams params = this.getWindow().getAttributes();
//      params.flags = WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON;
//      params.screenBrightness = 0.9f;
//      this.getWindow().setAttributes(params);
   // }
  }
  private void turnOffScreen(){

    if ((wakeLock != null) &&           // we have a WakeLock
            (wakeLock.isHeld() == true)) {
      wakeLock.release();
      Log.v("wakeLock", "Turn off screen ");
    }
 }
}
