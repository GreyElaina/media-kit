import CoreVideo

// Stub of `plugin/VideoFrameObservers.swift`, there are no video outputs.
public enum VideoFrameObservers {
  public typealias Observer = (CVPixelBuffer) -> Void

  @discardableResult
  public static func set(_ observer: Observer?, textureId: Int64) -> Bool {
    return false
  }

  public static func requestFrame(textureId: Int64) {}
}
