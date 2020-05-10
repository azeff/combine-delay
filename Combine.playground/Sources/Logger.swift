import Foundation

public class Logger: TextOutputStream {
    
    private var buffer = ""
    
    public init() { }
    
    public func write(_ string: String) {
        if buffer == "" {
            buffer = "\(Date())    "
        }
        buffer += string
        if buffer.rangeOfCharacter(from: .newlines) != nil {
            print(buffer, terminator: "")
            buffer = ""
        }
    }
    
    public func writeLine(_ string: String) {
        write(string + "\n")
    }
}
