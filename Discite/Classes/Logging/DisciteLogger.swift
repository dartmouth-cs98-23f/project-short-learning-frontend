//
//  DisciteLogger.swift
//  Discite
//
//  Created by Jessie Li on 3/15/24.
//

import Foundation
import OSLog
import Lottie

public final class DisciteLogger {
    static let shared = LottieLogger(
        assert: { condition, message, file, line in
            Swift.assert(condition(), message(), file: file, line: line)
        },
        assertionFailure: { message, file, line in
            Swift.assertionFailure(message(), file: file, line: line)
        },
        warn: { message, _, _ in
            #if DEBUG
            // swiftlint:disable:next no_direct_standard_out_logs
            print(message())
            #endif
            
            let logMessage = message()
            Logger.shared.warning("\(logMessage)")
            
        },
        info: { message in
            #if DEBUG
            // swiftlint:disable:next no_direct_standard_out_logs
            print(message())
            #endif
            
            let logMessage = message()
            Logger.shared.info("\(logMessage)")
        }
    )
}

extension Logger {
    public static let shared = Logger(subsystem: Bundle.main.bundleIdentifier ?? "discite", category: "general")
}
