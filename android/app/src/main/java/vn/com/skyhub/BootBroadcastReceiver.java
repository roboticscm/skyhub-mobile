package vn.com.skyhub;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BootBroadcastReceiver extends BroadcastReceiver {
    @Override
    public void onReceive(Context context, Intent intent) {
        System.out.println("-----------------------------Boot Broadcast Receiver");
        MainActivity.startService(context);
    }
}
