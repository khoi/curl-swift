import Foundation
import CCurl

public class CURLSH {
    private var share: UnsafeMutableRawPointer!

    public init(
        shareCookie: Bool = true,
        shareDNSCache: Bool = true,
        shareSSLSession: Bool = true,
        shareConnectionCache: Bool = true
    ) {
        share = curl_share_init()
        
        curl_share_setopt_lockdata(share, shareCookie ? CURLSHOPT_SHARE : CURLSHOPT_UNSHARE, CURL_LOCK_DATA_COOKIE)
        curl_share_setopt_lockdata(share, shareDNSCache ? CURLSHOPT_SHARE : CURLSHOPT_UNSHARE, CURL_LOCK_DATA_DNS);
        curl_share_setopt_lockdata(share, shareSSLSession ? CURLSHOPT_SHARE : CURLSHOPT_UNSHARE, CURL_LOCK_DATA_SSL_SESSION)
        curl_share_setopt_lockdata(share, shareConnectionCache ? CURLSHOPT_SHARE : CURLSHOPT_UNSHARE, CURL_LOCK_DATA_CONNECT);
    }
    
    public func perform(curl: CURL) throws -> Response {
        try curl.perform(share: share)
    }
    
    deinit {
        curl_share_cleanup(share)
    }
}
