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
    if isBeingDebugged(){
        if msg.count > 0 && msg[0] == "["{
            print("[LOGCOPY]\(msg)")
        } else {
            print("[LOGCOPY] \(msg)")
        }
        return
    }

    if #available(iOS 10.0, *) {
        let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: "MAINAPP", modifiers: [])
        let logger = Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
        logger.infoMessage(msg)
        /* code to put message in log category instead of the log message to get around Apple logging bug
        let consoleWriter = OSLogWriter(subsystem: "xyz.mann.Detach", category: msg, modifiers: [])
        let logger = Logger(logLevels: [.all], writers: [consoleWriter], executionMethod: .synchronous(lock: NSRecursiveLock()))
        logger.infoMessage("")
        */
    } else {}
}

func isBeingDebugged() -> Bool {
    var info = kinfo_proc()
    var mib : [Int32] = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
    var size = MemoryLayout<kinfo_proc>.stride
    let junk = sysctl(&mib, UInt32(mib.count), &info, &size, nil, 0)
    assert(junk == 0, "sysctl failed")
    return (info.kp_proc.p_flag & P_TRACED) != 0
}
