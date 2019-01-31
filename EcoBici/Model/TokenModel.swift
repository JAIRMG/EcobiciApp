
import Foundation

struct AccessToken: Decodable {
    var access_token: String?
	var expires_in: Int?
	var token_type: String?
	var scope: String?
	var refresh_token: String?
}
