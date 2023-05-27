import os.log

extension Logger {
    private static var subsystem = "io.kilian.EmealKit"

    static let emealKit = Logger(subsystem: subsystem, category: "EmealKit")
}
