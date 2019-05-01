package com.imbakod.wifiscannerflutter

import android.content.*
import android.net.wifi.WifiManager
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity: FlutterActivity() {

  private val WIFI_CHANNEL: String = "com.imbakod.wifiscanner/wifichannel"
  private lateinit var wifiManager: WifiManager

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    wifiManager = applicationContext.getSystemService(WIFI_SERVICE) as WifiManager

    EventChannel(flutterView, WIFI_CHANNEL).setStreamHandler(object : EventChannel.StreamHandler {
      private var wReceiver: BroadcastReceiver? = null

      override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        wReceiver = createWifiBroadcast(events!!)
        ContextWrapper(application).registerReceiver(wReceiver, IntentFilter(WifiManager.RSSI_CHANGED_ACTION))
        
        Timer().scheduleAtFixedRate(object : TimerTask() {
          override fun run() {
            val success = wifiManager.startScan()
            if(success) {
              updateResults(events)
            }
          }
        }, 1000, 800)
      }

      override fun onCancel(p0: Any?) {
        ContextWrapper(application).unregisterReceiver(wReceiver)
        wReceiver = null
      }
    })
  }

  private fun updateResults(events: EventChannel.EventSink) {
    var j = 0
    val hashMap: HashMap<String, ArrayList<HashMap<String, Any>>> = HashMap()
    val l = ArrayList<HashMap<String, Any>>(wifiManager.scanResults.size)

    wifiManager.scanResults.forEach {
      i ->
      j += 1

      l.add(hashMapOf(
              "level" to i.level,
              "centerFreq0" to i.centerFreq0,
              "channelWidth" to i.channelWidth,
              "frequency" to i.frequency,
              "BSSID" to i.BSSID,
              "SSID" to i.SSID,
              "capabilities" to i.capabilities,
              "centerFreq1" to i.centerFreq1,
              "is80211mcResponder" to i.is80211mcResponder,
              "isPasspointNetwork" to i.isPasspointNetwork,
              "operatorFriendlyName" to i.operatorFriendlyName,
              "timestamp" to i.timestamp,
              "venueName" to i.venueName,
              "signalLevel" to WifiManager.calculateSignalLevel(i.level, 5)
      ))
    }

    hashMap["results"] = l
    events.success(hashMap)
  }

  private fun createWifiBroadcast(events: EventChannel.EventSink): BroadcastReceiver {
    return object : BroadcastReceiver() {
      override fun onReceive(context: Context?, intent: Intent?) {
        val success = intent!!.getBooleanExtra(WifiManager.EXTRA_RESULTS_UPDATED, false)
        if (success) {
          updateResults(events)
        }
      }
    }
  }
}
