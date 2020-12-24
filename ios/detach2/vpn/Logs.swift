
import Willow

var willowLogger: Logger?

struct LoggingConfiguration {
    static func configure() {
        willowLogger = LoggingConfiguration.buildDebugLogger(name: "Detach Logger")
    }

    private static func buildDebugLogger(name _: String) -> Logger {
        if #available(iOS 10.0, *) {
            let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: "host", modifiers: [TimestampModifier()])

            return Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))

        } else {
            let consoleWriter = ConsoleWriter(modifiers: [TimestampModifier()])
            return Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
        }
    }
}

func Print(_ msg: String) {
    print("going to print \(msg)")
    if #available(iOS 10.0, *) {
        let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: msg, modifiers: [])
        let logger = Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))

        logger.infoMessage("")

    } else {}
}
