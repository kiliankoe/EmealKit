import os.log

extension Logger {
    private static let subsystem = "io.kilian.EmealKit"

    static let emealKit = Logger(subsystem: subsystem, category: "EmealKit")
}
