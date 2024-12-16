import UIKit
import Flutter
import llama_cpp_swift // 追加したライブラリをインポート

@main
@objc class AppDelegate: FlutterAppDelegate {
  private var llamaContext: LlamaContext?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller = window?.rootViewController as! FlutterViewController

    let llamaChannel = FlutterMethodChannel(
      name: "llama_swift_channel",
      binaryMessenger: controller.binaryMessenger
    )

    llamaChannel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "loadModel":
        guard let args = call.arguments as? [String: Any],
              let modelPath = args["modelPath"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Model path is missing", details: nil))
          return
        }
        self?.loadModel(path: modelPath, result: result)

      case "sendPrompt":
        guard let args = call.arguments as? [String: Any],
              let prompt = args["prompt"] as? String else {
          result(FlutterError(code: "INVALID_ARGUMENT", message: "Prompt is missing", details: nil))
          return
        }
        self?.sendPrompt(prompt: prompt, result: result)

      default:
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func loadModel(path: String, result: @escaping FlutterResult) {
    do {
      llamaContext = try LlamaContext.create_context(path: path)
      result(nil)
    } catch {
      result(FlutterError(code: "MODEL_LOAD_ERROR", message: "Failed to load model", details: error.localizedDescription))
    }
  }

  private func sendPrompt(prompt: String, result: @escaping FlutterResult) {
    guard let llamaContext else {
      result(FlutterError(code: "MODEL_NOT_LOADED", message: "Model is not loaded", details: nil))
      return
    }

    DispatchQueue.global(qos: .userInitiated).async {
      llamaContext.completion_init(text: prompt)

      var output = ""
      while !llamaContext.is_done {
        output += llamaContext.completion_loop()
      }

      DispatchQueue.main.async {
        result(output)
      }
    }
  }
}
