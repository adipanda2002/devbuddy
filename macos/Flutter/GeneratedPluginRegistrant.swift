//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

<<<<<<< HEAD
import sqflite_darwin

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  SqflitePlugin.register(with: registry.registrar(forPlugin: "SqflitePlugin"))
=======
import app_links
import path_provider_foundation
import shared_preferences_foundation
import url_launcher_macos

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  AppLinksMacosPlugin.register(with: registry.registrar(forPlugin: "AppLinksMacosPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SharedPreferencesPlugin.register(with: registry.registrar(forPlugin: "SharedPreferencesPlugin"))
  UrlLauncherPlugin.register(with: registry.registrar(forPlugin: "UrlLauncherPlugin"))
>>>>>>> 1bf6caf8cd4b35dddaec18ce0bdf47c81cd298a0
}
