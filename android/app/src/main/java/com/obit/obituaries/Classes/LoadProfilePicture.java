package com.obit.obituaries.Classes;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.AsyncTask;
import android.util.Log;
import android.widget.Toast;

import com.mikhaellopez.circularimageview.CircularImageView;
import com.obit.obituaries.CameraActivity;

import java.io.IOException;
import java.net.URL;

public class LoadProfilePicture extends AsyncTask<String, Void, Bitmap>
{
    CircularImageView mImageHolder;

    public LoadProfilePicture(CircularImageView p) {
        mImageHolder = p;
    }

    @Override
    protected Bitmap doInBackground(String... strings) {
        Bitmap bmp = null;
        try {
            URL url = new URL(strings[0]);
            return BitmapFactory.decodeStream(url.openConnection().getInputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    @Override
    protected void onPostExecute(Bitmap bitmap) {
        super.onPostExecute(bitmap);
        if(bitmap!=null) {
            mImageHolder.setImageBitmap(bitmap);
        }else{
            Log.d("LoadProfilePicture", "Error loading image");
        }
    }
}