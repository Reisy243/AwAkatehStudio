#!/bin/sh

# Please change by your keystore file
export KEYSTORE=$ANDROID_HOME/reisy.ks
# API 33 = Android 13
# https://apilevels.com/
export API_LEVEL=33

rm -vf *.apk* *.dex \
	src/io/github/reisy243/awakatehStudio/*.class \
	src/io/github/reisy243/awakatehStudio/R.java

aapt package -f \
	-m -J src \
	-M AndroidManifest.xml \
	-S res \
	-I $ANDROID_HOME/platforms/android-$API_LEVEL/android.jar

javac \
	-classpath "$ANDROID_HOME/platforms/android-$API_LEVEL/android.jar" \
	src/io/github/reisy243/awakatehStudio/*.java

d8 \
	--lib $ANDROID_HOME/platforms/android-$API_LEVEL/android.jar \
	src/io/github/reisy243/awakatehStudio/*.class \
	--output .

aapt package -f \
	-M AndroidManifest.xml \
	-S res \
	-I $ANDROID_HOME/platforms/android-$API_LEVEL/android.jar \
	-F build.apk

aapt add build.apk classes.dex

zipalign -p 4 build.apk out.apk

apksigner sign \
	-ks $KEYSTORE \
	out.apk
