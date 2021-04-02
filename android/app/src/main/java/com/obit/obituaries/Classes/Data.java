package com.obit.obituaries.Classes;

import java.io.Serializable;

public class Data implements Serializable {
    String AppId;
    String userName;
    String fullName;
    String profilePicUrl;
    String eventType;
    String date;
    String time;
    String authToken;
    String saveResourceUrl;
    String endBroadcastUrl;

    public Data(String appId, String userName, String fullName, String profilePicUrl, String eventType, String date, String time, String authToken, String saveResourceUrl, String endBroadcastUrl) {
        AppId = appId;
        this.userName = userName;
        this.fullName = fullName;
        this.profilePicUrl = profilePicUrl;
        this.eventType = eventType;
        this.date = date;
        this.time = time;
        this.authToken = authToken;
        this.saveResourceUrl = saveResourceUrl;
        this.endBroadcastUrl = endBroadcastUrl;
    }

    public String getAppId() {
        return AppId;
    }

    public String getUserName() {
        return userName;
    }

    public String getFullName() {
        return fullName;
    }

    public String getProfilePicUrl() {
        return profilePicUrl;
    }

    public String getEventType() {
        return eventType;
    }

    public String getDate() {
        return date;
    }

    public String getTime() {
        return time;
    }

    public String getAuthToken() {
        return authToken;
    }

    public String getSaveResourceUrl() {
        return saveResourceUrl;
    }

    public String getEndBroadcastUrl() {
        return endBroadcastUrl;
    }
}
