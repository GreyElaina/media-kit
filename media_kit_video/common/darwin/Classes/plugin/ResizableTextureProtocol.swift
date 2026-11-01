#if canImport(Flutter)
  import Flutter
#elseif canImport(FlutterMacOS)
  import FlutterMacOS
#endif

public protocol ResizableTextureProtocol: NSObject, FlutterTexture {
  func resize(_ size: CGSize)
  func render(_ size: CGSize)
  // Waits until the GPU has finished rendering, so that the pixel buffer can
  // be read by other APIs than Flutter.
  func waitForRendering()
}
