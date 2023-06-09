// This file was automatically generated by noise-serde-lib.
import Foundation
import NoiseBackend
import NoiseSerde

public struct Human: Readable, Writable {
  public let name: String
  public let age: UVarint

  public init(
    name: String,
    age: UVarint
  ) {
    self.name = name
    self.age = age
  }

  public static func read(from inp: InputPort, using buf: inout Data) -> Human {
    return Human(
      name: String.read(from: inp, using: &buf),
      age: UVarint.read(from: inp, using: &buf)
    )
  }

  public func write(to out: OutputPort) {
    name.write(to: out)
    age.write(to: out)
  }
}

public class Backend {
  let impl: NoiseBackend.Backend!

  init(withZo zo: URL, andMod mod: String, andProc proc: String) {
    impl = NoiseBackend.Backend(withZo: zo, andMod: mod, andProc: proc)
  }
}
