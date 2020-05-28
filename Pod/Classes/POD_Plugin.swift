
import Foundation
import OneCore

@objc(${POD_PLUGIN_NAME})
final class ${POD_PLUGIN_NAME}: NSObject, Pluggable {
    var identifier: String {
        "${POD_PLUGIN_IDENTIFIER}"
    }
}
