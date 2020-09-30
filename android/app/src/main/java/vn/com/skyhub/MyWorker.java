//package vn.com.skyhub;
//
//import android.content.Context;
//
//
//import androidx.annotation.NonNull;
//
//import static vn.com.skyhub.MainActivity.startWorker;
//
//public class MyWorker extends Worker {
//    private final Context context;
//    public MyWorker(@NonNull Context context, @NonNull WorkerParameters workerParams) {
//        super(context, workerParams);
//        this.context = context;
//    }
//
//    @Override
//    public Result doWork() {
//        startWorker(context);
//        System.out.println("call......................");
//        return Result.success();
//    }
//}
