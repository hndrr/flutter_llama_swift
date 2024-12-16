import Flutter
import UIKit
import LibLlama // LibLlama.swift をインポート

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
    let llamaChannel = FlutterMethodChannel(
      name: "llama_swift_channel",
      binaryMessenger: controller.binaryMessenger
    )
    
    llamaChannel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      if call.method == "runLlamaSwift" {
        guard let args = call.arguments as? [String: Any],
              let prompt = args["prompt"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Prompt is missing", details: nil))
          return
        }

        // LibLlama.swift のメソッドを呼び出し
        let response = runLlamaSwift(prompt: prompt) // LibLlama.swift の処理
        result(response)
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func runLlamaSwift(prompt: String) -> String {
    let llama = LibLlama()
    // LibLlama.swift の実装をここで呼び出す
    return llama.process(prompt) // 仮の処理
  }
}
