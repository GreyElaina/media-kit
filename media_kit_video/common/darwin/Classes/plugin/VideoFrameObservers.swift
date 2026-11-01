import CoreVideo

// Lets other native code of the app (e.g. picture-in-picture) get the frames
// of a video output, without going through the Flutter texture.
public enum VideoFrameObservers {
  public typealias Observer = (CVPixelBuffer) -> Void

  private final class WeakVideoOutput {
    weak var value: VideoOutput?
    init(_ value: VideoOutput) { self.value = value }
  }

  private static let lock = NSLock()
  private static var videoOutputs = [Int64: WeakVideoOutput]()

  // Sets the observer of the frames of the video output of `textureId`, or
  // removes it if `nil`. Returns whether there is such a video output.
  //
  // The observer is called on the render thread of the video output, right
  // after each frame is rendered, and while the pixel buffer can't be
  // rendered into. It must not keep the pixel buffer, which is reused for
  // the next frames.
  @discardableResult
  public static func set(_ observer: Observer?, textureId: Int64) -> Bool {
    guard let videoOutput = get(textureId) else {
      return false
    }
    videoOutput.setFrameObserver(observer)
    return true
  }

  // Calls the observer of the video output of `textureId` with the current
  // frame, e.g. while paused, when no frame is rendered.
  public static func requestFrame(textureId: Int64) {
    get(textureId)?.requestFrame()
  }

  static func add(_ videoOutput: VideoOutput, textureId: Int64) {
    locked {
      videoOutputs[textureId] = WeakVideoOutput(videoOutput)
    }
  }

  static func remove(textureId: Int64) {
    locked {
      videoOutputs[textureId] = nil
    }
  }

  private static func get(_ textureId: Int64) -> VideoOutput? {
    return locked {
      videoOutputs[textureId]?.value
    }
  }

  private static func locked<T>(do block: () -> T) -> T {
    lock.lock()
    defer {
      lock.unlock()
    }

    return block()
  }
}
