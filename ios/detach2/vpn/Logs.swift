
import Willow

var willowLogger: Logger?

struct LoggingConfiguration {
    static func configure() {
        // create a logger and assign it
        willowLogger = LoggingConfiguration.buildDebugLogger(name: "Detach Logger")
    }

    private static func buildDebugLogger(name _: String) -> Logger {
        // prints straight to the console
//    let emojiModifier = EmojiModifier(name: name)

        if #available(iOS 10.0, *) {
            let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: "host", modifiers: [TimestampModifier()])
//            print("made OFLogWriter")

            return Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))

        } else {
            // Fallback on earlier versions
            let consoleWriter = ConsoleWriter(modifiers: [TimestampModifier()])
            return Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
        }

        // create a new logger with all levels which prints synchronously to the console
    }
}

func Print(_ msg: String) {
    print("going to print \(msg)")
    if #available(iOS 10.0, *) {
        let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: msg, modifiers: [])
        let logger = Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
//        print("called infoMessage()")
        logger.infoMessage("")

    } else {
        // Fallback on earlier versions
    }
}
