package com.obit.obituaries;

import android.content.Intent;
import androidx.annotation.NonNull;
import com.obit.obituaries.Classes.Data;
import java.io.Serializable;
import java.util.Map;
import java.util.Objects;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

/*
* Note to self
* app_key
* changeit
*/
public class MainActivity extends FlutterActivity
{
    private MethodChannel.Result mResult;
    public static final int REQUEST_CODE = 10001;
    public static final String _CODE = "ARGS_DATA";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
    GeneratedPluginRegistrant.registerWith(flutterEngine);

    MethodChannel channel = new MethodChannel(flutterEngine.getDartExecutor(), "START_CAMERA_APP");

    channel.setMethodCallHandler(
        (call, result) -> {
            if (call.method.equals("startCameraActivity")) {
                Map<String, String> args = call.arguments();
                Data data = new Data(
                        args.get("bambUserAppId"),
                        args.get("userName"),
                        args.get("fullName"),
                        args.get("profilePicUrl"),
                        args.get("eventType"),
                        args.get("date"),
                        args.get("time"),
                        args.get("authToken"),
                        args.get("SaveResourceUrl"),
                        args.get("EndBroadcastUrl")
                        );

                Intent intent = new Intent(getActivity(), CameraActivity.class);
                intent.putExtra(_CODE, (Serializable) data);
                startActivityForResult(intent,REQUEST_CODE);
                mResult = result;
            }
        }
    );
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        //super.onActivityResult(requestCode, resultCode, data);
        if (requestCode == REQUEST_CODE) {
            if (resultCode == RESULT_OK) {
                mResult.success(Objects.requireNonNull(data.getData()).toString());
            }

            if (resultCode == RESULT_CANCELED) {
                mResult.success("RESULT_CANCELED");
            }
        }
    }
}
