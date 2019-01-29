import Foundation

class AuthenticationModule {
    static let shared = AuthenticationModule()
    private var apiService: APIService?
    private init() {
        print("Wisk | Authentication Module Initialized.")
        //  self.apiService = APIService.sharedInstance
    }
//    func login(withCredentials credentials: [String: Any], completion: @escaping(Any?) -> Void) {
//        guard let parameters = APIParameterLayer.shared.setupParameter(withData: credentials) else
//        {
//            completion(nil)
//            return
//        }
//        apiService.performAPIRequest(withParameters: parameters) {
//            (response, error) in
//            if response != nil {
//                //  Add additional functionality as needed
//                //  ...
//                completion(nil)
//            } else {
//                completion(nil)
//            }
//        }
//    }
//    func register(withCredentials credentials: [String: Any], completion: @escaping(Any?) -> Void) {
//        guard let parameters = APIParameterLayer.shared.setupParameter(withData: credentials) else
//        {
//            completion(nil)
//            return
//        }
//        apiService.performAPIRequest(withParameters: parameters) {
//            (response, error) in
//            if response != nil {
//                //  Add additional functionality as needed
//                //  ...
//                completion(nil)
//            } else {
//                completion(nil)
//            }
//        }
//    }
}

