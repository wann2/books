package com.wann2.app;

import org.apache.cordova.DroidGap;

import android.content.res.Configuration;
import android.os.Bundle;

public class Wann2AppActivity extends DroidGap {
    
	/** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        super.loadUrl("file:///android_asset/www/index.html");
    }
    
}
