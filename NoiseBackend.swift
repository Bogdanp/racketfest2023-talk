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

  public func findHuman(named name: String) -> Future<String, Human?> {
    return impl.send(
      writeProc: { (out: OutputPort) in
        UVarint(0x0000).write(to: out)
        name.write(to: out)
      },
      readProc: { (inp: InputPort, buf: inout Data) -> Human? in
        return Human?.read(from: inp, using: &buf)
      }
    )
  }

  public func installCallback(internalWithId id: UVarint, andAddr addr: Varint) -> Future<String, Void> {
    return impl.send(
      writeProc: { (out: OutputPort) in
        UVarint(0x0001).write(to: out)
        id.write(to: out)
        addr.write(to: out)
      },
      readProc: { (inp: InputPort, buf: inout Data) -> Void in }
    )
  }
}
