package com.obit.obituaries;

import android.Manifest;
import android.animation.ValueAnimator;
import android.annotation.SuppressLint;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.net.Uri;
import android.os.Bundle;
import android.util.TypedValue;
import android.view.MotionEvent;
import android.view.SurfaceView;
import android.view.View;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.cardview.widget.CardView;
import androidx.core.app.ActivityCompat;

import com.bambuser.broadcaster.BroadcastStatus;
import com.bambuser.broadcaster.Broadcaster;
import com.bambuser.broadcaster.CameraError;
import com.bambuser.broadcaster.ConnectionError;
import com.mikhaellopez.circularimageview.CircularImageView;
import com.obit.obituaries.Classes.Data;
import com.obit.obituaries.Classes.EndBroadCastPost;
import com.obit.obituaries.Classes.LoadProfilePicture;
import com.obit.obituaries.Classes.OnSwipeTouchListener;
import com.obit.obituaries.Classes.SaveResourceId;

import static com.obit.obituaries.R.layout.camera_activity;

public class CameraActivity extends AppCompatActivity implements SensorEventListener
{
    private SurfaceView mPreviewSurface;
    private Broadcaster mBroadcaster;
    private ImageButton mBroadcastButton;
    private TextView mStreamInfo;
    private CardView mTopLayer;
    private String mSaveResourceUrl;
    private String endBroadcastUrl;
    private String mAuthToken;
    private String mBroadcastId="";

    private SensorManager mSensorManager;
    private Sensor mAccelerometer;
    private final float[] mGravityValues = new float[3];
    private float[] mGravity = new float[3];
    RelativeLayout mRotateView;

    private int mTopMargin = 0;
    private final int mTransitionSpeed = 400;
    private RelativeLayout.LayoutParams mParams;
    private boolean isOpen;
    private boolean startStreamClicked;

    @SuppressLint("ClickableViewAccessibility")
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(camera_activity);

        mSensorManager = (SensorManager)getSystemService(SENSOR_SERVICE);
        mAccelerometer = mSensorManager.getDefaultSensor(Sensor.TYPE_ACCELEROMETER);

        mTopMargin = (int) toDPI(98);

        mRotateView     = findViewById(R.id.rotate_view);
        mPreviewSurface = findViewById(R.id.preview_surface_view);
        mBroadcastButton= findViewById(R.id.broadcast_button);
        mStreamInfo     = findViewById(R.id.stream_info);
        mTopLayer       = findViewById(R.id.top_layer);

        CircularImageView profilePic= findViewById(R.id.profile_pic);
        TextView name               = findViewById(R.id.name);
        TextView eventType          = findViewById(R.id.event_type);
        ImageButton closeButton     = findViewById(R.id.close_button);
        TextView endBroadcast       = findViewById(R.id.end_broadcast);
        TextView bottomTextInfo     = findViewById(R.id.bottom_text_info);
        Button startCameraButton    = findViewById(R.id.start_camera_button);

        Data _data = (Data) getIntent().getSerializableExtra(MainActivity._CODE);

        if(_data != null) {
            mSaveResourceUrl = _data.getSaveResourceUrl();
            endBroadcastUrl = _data.getEndBroadcastUrl();
            mAuthToken = _data.getAuthToken();
            name.setText(_data.getFullName());
            eventType.setText(_data.getEventType());
            mBroadcaster = new Broadcaster(this, _data.getAppId(), mBroadcasterObserver);
            mBroadcaster.setRotation(getWindowManager().getDefaultDisplay().getRotation());
            mBroadcaster.setAuthor(_data.getUserName());
            mBroadcaster.setTitle(String.format("%s %s", _data.getFullName(), _data.getEventType()));
            mBroadcaster.setSaveOnServer(true);
            mBroadcaster.setCustomData(String.format("%s %s", _data.getDate(), _data.getTime()));
            new LoadProfilePicture(profilePic).execute(_data.getProfilePicUrl());
        }else{
            Toast.makeText(this, R.string.error_loading_resource, Toast.LENGTH_LONG).show();
        }

        mParams = (RelativeLayout.LayoutParams) mTopLayer.getLayoutParams();
        boolean isTwoCamera = mBroadcaster.getSupportedCameras().size()>1;

        if(isTwoCamera) {
            bottomTextInfo.append(getString(R.string.cam_text_info2));
        }

        mPreviewSurface.setOnTouchListener(new OnSwipeTouchListener(CameraActivity.this, isTwoCamera)
        {
            public void onSwipeTop(){
                _onSwipeTop();
            }

            public void onSwipeBottom() {
                _onSwipeBottom();
            }

            public void onDoubleTaped(MotionEvent e) {
                mBroadcaster.setCameraId(mBroadcaster.getCameraId().equals("1") ? "0" : "1");
            }
        });

        mBroadcastButton.setOnClickListener(v -> _onSwipeBottom());

        endBroadcast.setOnClickListener(view -> {
            Intent data = new Intent();
            data.setData(Uri.parse("RESULT_BROADCAST_ENDED"));
            setResult(RESULT_OK, data);
            finish();
        });

        closeButton.setOnClickListener(view -> {
            if(!isOpen){
                _onSwipeBottom();
            } else {
                _onSwipeTop();
            }
        });

        startCameraButton.setOnClickListener(view -> {
            RelativeLayout  startCameraView = findViewById(R.id.start_camera_view);
            startCameraView.setVisibility(View.GONE);
            startStreamClicked = true;
            mBroadcaster.startBroadcast();
        });
    }

    private void _onSwipeBottom(){
        if(!isOpen) {
            int RADIUS = 33;
            mTopLayer.setRadius(toDPI(RADIUS));
            ValueAnimator animi = ValueAnimator.ofInt(mTopMargin);
            animi.setDuration(mTransitionSpeed);
            animi.addUpdateListener(animation -> {
                mParams.setMargins(0, Integer.parseInt(animation.getAnimatedValue().toString()), 0, -100);
                mTopLayer.setLayoutParams(mParams);
            });
            animi.start();
        }
        isOpen = true;
    }

    private void _onSwipeTop(){
        if(isOpen) {
            ValueAnimator animi = ValueAnimator.ofInt(mTopMargin);
            animi.setDuration(mTransitionSpeed);
            animi.addUpdateListener(animation -> {
                int _topMargin = mTopMargin - (Integer) animation.getAnimatedValue();
                mParams.setMargins(0,  _topMargin, 0, -100);
                mTopLayer.setLayoutParams(mParams);

                if(_topMargin == 0){
                    mTopLayer.setRadius(0);
                    mParams.bottomMargin = 0;
                    mTopLayer.setLayoutParams(mParams);
                }
            });
            animi.start();
        }
        isOpen = false;
    }

    private float toDPI(float pix) {
        return TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, pix, getResources().getDisplayMetrics());
    }

    @Override
    public void onDestroy() {
        super.onDestroy();
        mBroadcaster.onActivityDestroy();
    }

    @Override
    public void onPause() {
        super.onPause();
        if(!mBroadcastId.isEmpty()) {
            new EndBroadCastPost().execute(endBroadcastUrl, mBroadcastId, mAuthToken);
        }
        mBroadcaster.onActivityPause();
        mSensorManager.unregisterListener(this);
    }

    @Override
    public void onResume() {
        super.onResume();
        if (hasPermission(Manifest.permission.CAMERA) && hasPermission(Manifest.permission.RECORD_AUDIO)) {
            ActivityCompat.requestPermissions(this, new String[]{
                    Manifest.permission.CAMERA,
                    Manifest.permission.RECORD_AUDIO}, 1);
        }
        else if(hasPermission(Manifest.permission.RECORD_AUDIO))
            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.RECORD_AUDIO}, 1);
        else if(hasPermission(Manifest.permission.CAMERA))
            ActivityCompat.requestPermissions(this, new String[] {Manifest.permission.CAMERA}, 1);

        mBroadcaster.setCameraSurface(mPreviewSurface);
        mBroadcaster.onActivityResume();
        mBroadcaster.setRotation(getWindowManager().getDefaultDisplay().getRotation());
        mBroadcastButton.setBackground(getResources().getDrawable(R.drawable.stop_icon));

        mSensorManager.registerListener(this, mAccelerometer, SensorManager.SENSOR_DELAY_NORMAL);
    }

    private boolean hasPermission(String permission) {
        return ActivityCompat.checkSelfPermission(this, permission) != PackageManager.PERMISSION_GRANTED;
    }

    private final Broadcaster.Observer mBroadcasterObserver = new Broadcaster.Observer()
    {
        @Override
        public void onConnectionStatusChange(BroadcastStatus broadcastStatus)
        {
            if (broadcastStatus == BroadcastStatus.STARTING) {
                mStreamInfo.setText(R.string.action_connecting);
                //mBroadcastButton.setBackground(getResources().getDrawable(R.drawable.play_icon));
                getWindow().addFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
            }
            if (broadcastStatus == BroadcastStatus.PREPARED)
                mStreamInfo.setText(R.string.action_preparing);
            if (broadcastStatus == BroadcastStatus.CAPTURING) {
                mStreamInfo.setText(R.string.action_streaming);
                //mBroadcastButton.setBackground(getResources().getDrawable(R.drawable.stop_icon));
            }
            if (broadcastStatus == BroadcastStatus.RECONNECTING) {
                mStreamInfo.setText(R.string.action_reconnecting);
                //mBroadcastButton.setBackground(getResources().getDrawable(R.drawable.stop_icon));
            }
            if (broadcastStatus == BroadcastStatus.FINISHING)
                mStreamInfo.setText(R.string.finishing);
            if (broadcastStatus == BroadcastStatus.IDLE) {
                mStreamInfo.setText(R.string.action_stream_end);
                //mBroadcastButton.setBackground(getResources().getDrawable(R.drawable.play_icon));
                getWindow().clearFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
            }
        }
        @Override
        public void onStreamHealthUpdate(int i) {
        }
        @Override
        public void onConnectionError(ConnectionError connectionError, String s) {
            String errorType = "UNKNOWN ERROR";
            switch(connectionError){
                case NONE:
                    errorType = "NONE";
                break;
                case CONNECT_FAILED:
                    errorType = "CONNECT FAILED";
                break;
                case SEND_FAILED:
                    errorType = "SEND FAILED";
                break;
                case DISCONNECTED:
                    errorType = "DISCONNECTED";
                break;
                case RECEIVE_FAILED:
                    errorType = "RECEIVE FAILED";
                break;
                case WRITE_FAILED:
                    errorType = "WRITE ERROR";
                break;
                case BAD_CREDENTIALS:
                    errorType = "BAD CREDENTIALS";
                break;
                case BAD_CLIENT:
                    errorType = "BAD CLIENT";
                break;
                case BAD_SERVER:
                case SERVER_MESSAGE:
                case SERVER_FULL:
                    errorType = "SERVER MESSAGE";
                break;
                case RECONNECT_FAILED:
                    errorType = "RECONNECT FAILED";
                break;
            }

            Toast.makeText(getApplicationContext(), String.format("%s: %s", errorType, s), Toast.LENGTH_LONG).show();
        }
        @Override
        public void onBroadcastInfoAvailable(String s, String s1) {
        }
        @Override
        public void onBroadcastIdAvailable(String id)
        {
            mBroadcastId = id;
            new SaveResourceId().execute(mSaveResourceUrl, mBroadcastId, mAuthToken);
        }
        @Override
        public void onCameraError(CameraError cameraError) {
            Toast.makeText(getApplicationContext(), "Error with camera >> " + cameraError.name(), Toast.LENGTH_LONG).show();
        }
        @Override
        public void onChatMessage(String s) {
        }
        @Override
        public void onResolutionsScanned() {
        }
        @Override
        public void onCameraPreviewStateChanged() {
        }
    };

    @Override
    public void onSensorChanged(SensorEvent event) {
        synchronized (this) {
            if(startStreamClicked) {
                if (event.sensor.getType() == Sensor.TYPE_ACCELEROMETER) {
                    System.arraycopy(event.values, 0, mGravityValues, 0, 3);
                    mGravity[0] = mGravityValues[0];//x
                    mGravity[1] = mGravityValues[1];//y
                    mGravity[2] = mGravityValues[2];//z
                }
                float angle = (float) (Math.atan2(mGravity[0], mGravity[1]) / (Math.PI / 180)) - 90;

                if (angle < -240 || angle > 60) {
                    showRotateView(90);
                } else if (angle < -60 && angle > -120) {
                    showRotateView(270);
                } else {
                    mRotateView.animate()
                            .alpha(0.0f)
                            .setDuration(30).start();
                }
            }else{
                //show rotate after button is clicked
                mRotateView.animate().alpha(0.0f).setDuration(0).start();
            }
        }
    }

    private void showRotateView(float x)
    {
        mRotateView.setRotation(x);
        mRotateView.animate()
                .alpha(1.0f)
                .setDuration(150).start();
    }

    @Override
    public void onAccuracyChanged(Sensor sensor, int i) {
    }
}