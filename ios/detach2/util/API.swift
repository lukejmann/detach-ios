import Foundation
import Moya

// MARK: - Provider setup

private func JSONResponseDataFormatter(_ data: Data) -> String {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return String(data: prettyData, encoding: .utf8) ?? String(data: data, encoding: .utf8) ?? ""
    } catch {
        return String(data: data, encoding: .utf8) ?? ""
    }
}

public let detachProvier = MoyaProvider<DetachAPI>(plugins: [
    NetworkLoggerPlugin(
        configuration:
        .init(
            formatter:
            .init(responseData: JSONResponseDataFormatter),
            logOptions: .default)
    ),
]
)

// MARK: - Provider support

private extension String {
    var urlEscaped: String {
        addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }
}

public enum DetachAPI {
    case login(userID: String, email: String)
    case createSession(opt: SessionCreateOpt)
    case cancelSession(opt: SessionCancelOpt)
    case checkReceipt(opt: CheckReceiptOpt)
    case fetchAppDomains
}

extension DetachAPI: TargetType {
    public var baseURL: URL { URL(string: "http://192.168.1.92/1")! }
    public var path: String {
        switch self {
        case .login:
            return "/users/login"
        case .createSession:
            return "/sessions/create"
        case .cancelSession:
            return "/sessions/cancel"
        case .checkReceipt:
            return "/users/checkReceipt"
        case .fetchAppDomains:
            return "/static/ADs"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .get
        case .createSession:
            return .post
        case .cancelSession:
            return .post
        case .checkReceipt:
            return .post
        case .fetchAppDomains:
            return .get
        }
    }

    public var task: Task {
        switch self {
        case let .login(userID, email):
            return .requestParameters(parameters: ["userID": userID, "email": email], encoding: URLEncoding.default)
        case let .createSession(opt): // Always send parameters as JSON in request body
            print("opt in task: \(opt)")
            return .requestJSONEncodable(opt)
        case let .cancelSession(opt):
            return .requestJSONEncodable(opt)
        case let .checkReceipt(opt):
            print("check Receipt opt: \(opt)")
            return .requestJSONEncodable(opt)
        case .fetchAppDomains:
            return .requestPlain
//        case .updateUser
//        default:
//            return .requestJSONEncodable()
        }
    }

//
//    var parameterEncoding: Moya.ParameterEncoding {
//        switch self {
//        case .login:
//            return ParameterEncoding
//        default:
//            return JSONEncoding.default
//        }
//    }

    public var validationType: ValidationType {
        switch self {
//        case .login:
//            return .successCodes
        default:
            return .none
        }
    }

    public var sampleData: Data {
        switch self {
        case .login:
            return "[{\"1\": \"l@mann.xyz\"}]".data(using: String.Encoding.utf8)!
        case let .createSession(opt):
            return "{\"opt\": \"\(opt)\"}".data(using: String.Encoding.utf8)!
        case let .cancelSession(opt):
            return "{\"opt\": \"\(opt)\"}".data(using: String.Encoding.utf8)!
        case let .checkReceipt(opt):
            return "{\"opt\": \"\(opt)\"}".data(using: String.Encoding.utf8)!
        case .fetchAppDomains:
            return "{}".data(using: String.Encoding.utf8)!
        }
    }

    public var headers: [String: String]? {
        ["Content-type": "application/json"]
    }
}

public func url(_ route: TargetType) -> String {
    let r = route.baseURL.appendingPathComponent(route.path).absoluteString
    print("url: ", r)
    return r
}

// MARK: - Response Handlers

extension Moya.Response {
    func mapNSArray() throws -> NSArray {
        let any = try mapJSON()
        guard let array = any as? NSArray else {
            throw MoyaError.jsonMapping(self)
        }
        return array
    }
}

public struct SessionCreateOpt: Codable {
    var userID: String
    var endTime: Int
    var deviceToken: String
}

public struct SessionCancelOpt: Codable {
    var userID: String
    var sessionID: String
}

public struct CheckReceiptOpt: Codable {
    var userID: String
    var appleReciept: String
}
