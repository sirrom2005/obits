package com.obit.obituaries.Classes;

import android.graphics.Bitmap;
import android.os.AsyncTask;
import android.util.Log;

import com.squareup.okhttp.MediaType;
import com.squareup.okhttp.OkHttpClient;
import com.squareup.okhttp.Request;
import com.squareup.okhttp.RequestBody;
import com.squareup.okhttp.Response;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import static java.lang.String.*;

public class SaveResourceId extends AsyncTask<String, Void, String>
{
    @Override
    protected String doInBackground(String... args)
    {
        String json = format("{\"service\":{\"bambuser_broadcast_id\" : \"%s\" }}", args[1]);
        OkHttpClient client = new OkHttpClient();
        MediaType JSON = MediaType.parse("application/json; charset=utf-8");

        RequestBody body = RequestBody.create(JSON, json);
        Request request = new Request.Builder()
                .header("Authorization", String.format("Bearer %s", args[2]))
                .url(args[0])
                .patch(body)
                .build();

        Response response;

        try {
            response = client.newCall(request).execute();
            return response.body().string();
        } catch (IOException e) {
            return e.getMessage();
        }
    }

    @Override
    protected void onPostExecute(String s) {
        super.onPostExecute(s);
    }
}
