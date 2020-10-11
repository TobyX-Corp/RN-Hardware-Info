package com.reactlibrary;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.AppOpsManager;
import android.app.usage.NetworkStats;
import android.app.usage.NetworkStatsManager;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.PackageManager;
import android.net.ConnectivityManager;
import android.os.BatteryManager;
import android.os.RemoteException;
import android.provider.Settings;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.uimanager.IllegalViewOperationException;

import java.io.File;
import java.io.FileFilter;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.util.regex.Pattern;

public class RnHardwareInfoModule extends ReactContextBaseJavaModule {

    ReactApplicationContext reactContext;
    int update_flag = 0;
    long time_old = 0;
    long up_old = 0;
    long down_old = 0;

    public RnHardwareInfoModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "RnHardwareInfo";
    }

    @ReactMethod
    public void getDeviceCpuFreqNow(Callback cb) {
        try{
            cb.invoke(readCpuFreqNow());
        }catch (Exception e){
            cb.invoke(e.toString());
        }
    }

    private String readCpuFreqNow(){
        File[] cpuFiles = getCPUs();
        System.out.println("readCpuFreqNow cpuFiles ="+ cpuFiles);
        int strFileList = 0;
        for(int i = 0; i < cpuFiles.length; i++){
            String num = cpuFiles[i].getAbsolutePath().substring(cpuFiles[i].getAbsolutePath().length()-1);
            String path_scaling_cur_freq =
                    cpuFiles[i].getAbsolutePath()+"/cpufreq/scaling_cur_freq";

            String scaling_cur_freq = cmdCat(path_scaling_cur_freq);
            strFileList += Integer.parseInt(scaling_cur_freq.trim());
        }
        strFileList = strFileList / (cpuFiles.length * 1000);
        String output = Long.toString(strFileList);
        return output;
    }

    private String cmdCat(String f){

        String[] command = {"cat", f};
        StringBuilder cmdReturn = new StringBuilder();

        try {
            ProcessBuilder processBuilder = new ProcessBuilder(command);
            Process process = processBuilder.start();

            InputStream inputStream = process.getInputStream();
            int c;

            while ((c = inputStream.read()) != -1) {
                cmdReturn.append((char) c);
            }

            return cmdReturn.toString();

        } catch (IOException e) {
            e.printStackTrace();
            return "IOExcpetion";
        }

    }

    private File[] getCPUs(){

        class CpuFilter implements FileFilter {
            @Override
            public boolean accept(File pathname) {
                if(Pattern.matches("cpu[0-9]+", pathname.getName())) {
                    return true;
                }
                return false;
            }
        }

        File dir = new File("/sys/devices/system/cpu/");
        File[] files = dir.listFiles(new CpuFilter());
        return files;
    }

    @ReactMethod
    public void getDeviceMemInfo(Callback cb) {
        try{
            cb.invoke(getMemorySizeHumanized());
        }catch (Exception e){
            cb.invoke(e.getMessage());
        }
    }

    /**
     * Returns the available ammount of RAM of your Android device in a human readable format e.g 1.56GB, 4GB, 512MB
     *
     * @return {String}
     */
    public double getMemorySizeHumanized()
    {

        ActivityManager activityManager = (ActivityManager) this.reactContext.getSystemService(Context.ACTIVITY_SERVICE);

        ActivityManager.MemoryInfo memoryInfo = new ActivityManager.MemoryInfo();

        activityManager.getMemoryInfo(memoryInfo);

        DecimalFormat twoDecimalForm = new DecimalFormat("#.##");

        String finalValue = "";
        long totalMemory = memoryInfo.totalMem;

        double kb = totalMemory / 1024.0;
        double mb = totalMemory / 1048576.0;
        double gb = totalMemory / 1073741824.0;
        double tb = totalMemory / 1099511627776.0;

        if (tb > 1) {
            finalValue = twoDecimalForm.format(tb).concat(" TB");
        } else if (gb > 1) {
            finalValue = twoDecimalForm.format(gb).concat(" GB");
        } else if (mb > 1) {
            finalValue = twoDecimalForm.format(mb).concat(" MB");
        }else if(kb > 1){
            finalValue = twoDecimalForm.format(mb).concat(" KB");
        } else {
            finalValue = twoDecimalForm.format(totalMemory).concat(" Bytes");
        }

        double availableMegs = memoryInfo.availMem / 0x100000L;

        //Percentage can be calculated for API 16+
        double percentAvail = memoryInfo.availMem / (double)memoryInfo.totalMem * 100.0;
        System.out.println("getMemorySizeHumanized percentage available= "+ percentAvail);

        BigDecimal b = new BigDecimal(percentAvail);
        double res_percent = b.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();

        return res_percent;
    }


    @ReactMethod
    public void getBatteryTemperature(Callback cb) {

        try {
            Intent batteryIntent = getCurrentActivity().registerReceiver(null, new IntentFilter(Intent.ACTION_BATTERY_CHANGED));
            float batteryTemp = batteryIntent.getIntExtra(BatteryManager.EXTRA_TEMPERATURE,0)/10;

//            cb.invoke("Battery Level: " + batteryTemp + " "+ (char) 0x00B0 +"C; ");
            cb.invoke(batteryTemp + " " + (char) 0x00B0 +"C");

        }catch (IllegalViewOperationException e) {
            cb.invoke(e.getMessage());
        }
    }

    @ReactMethod
    public void getNetworkStats(Callback cb) {
        long up = 0;
        long down = 0;
        long time = 0;
        double down_in_KBps;
        double up_in_KBps;

        final Activity activity = getCurrentActivity();
        final ReactApplicationContext context = this.reactContext;

        if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.M) {
            final AppOpsManager appOps = (AppOpsManager) context.getSystemService(Context.APP_OPS_SERVICE);
            int mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.getPackageName());

//            Intent disable_usage = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
//            context.startActivity(disable_usage);

            if(mode != AppOpsManager.MODE_ALLOWED){
                Intent request_permission = new Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS);
                request_permission.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(request_permission);
                while (mode != AppOpsManager.MODE_ALLOWED) {
                    mode = appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, android.os.Process.myUid(), context.getPackageName());
                }
                Intent main_app = new Intent(activity, activity.getClass());
                main_app.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                context.startActivity(main_app);
            }


            NetworkStatsManager networkStatsManager = (NetworkStatsManager) context.getSystemService(context.NETWORK_STATS_SERVICE);
            NetworkStats.Bucket bucket;

            try {

                time = System.currentTimeMillis();
                bucket = networkStatsManager.querySummaryForDevice(ConnectivityManager.TYPE_WIFI,
                        "",
                        0,
                        System.currentTimeMillis());

                down = bucket.getRxBytes();
                up = bucket.getTxBytes();

                if(this.update_flag == 0){
                    down_in_KBps = 0;
                    up_in_KBps = 0;
                }
                else{
                    double unit = 1.024*(time - this.time_old);
                    down_in_KBps = (down-this.down_old)/unit;
                    up_in_KBps = (up-this.up_old)/unit;
                }

                cb.invoke(down_in_KBps + "kBps", up_in_KBps + "kBps");

                this.time_old = time;
                this.down_old = down;
                this.up_old = up;
                this.update_flag = 1;

            } catch (RemoteException e) {
                cb.invoke(e.getMessage(), null);
            }

        }
        else System.out.println("SDK version is less than code version");
    }
    
}
