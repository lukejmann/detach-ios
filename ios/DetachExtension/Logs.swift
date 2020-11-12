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
            let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: "tunnel", modifiers: [])

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
    let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: msg, modifiers: [])

    let logger = Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
    logger.infoMessage("")
}

func PrintDomain(_ msg: String) {
    let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach.DomainLog", category: msg, modifiers: [])

    let logger = Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
    logger.infoMessage("")
}

struct EmojiModifier: LogModifier {
    let name: String

    /**
     Brings little fun with emojis in debugging.
     Takes message and puts a emoji depending on the logLevel at the start of the line.

     - parameter message: The message to log.
     - parameter logLevel: The severity of the message.
     - returns: The modified log message.
     */
    func modifyMessage(_ message: String, with logLevel: LogLevel) -> String {
        switch logLevel {
        case .debug:
            return "🔬🔬🔬 [\(name)] => \(message)"
        case .info:
            return "💡💡💡 [\(name)] => \(message)"
        case .event:
            return "🔵🔵🔵 [\(name)] => \(message)"
        case .warn:
            return "⚠️⚠️⚠️ [\(name)] => \(message)"
        case .error:
            return "🚨💣💥 [\(name)] => \(message)"
        default:
            return "[\(name)] => \(message)"
        }
    }
}
