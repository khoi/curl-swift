# ➰ curl-swift ![status badge](https://github.com/khoi/curl-swift/actions/workflows/test.yml/badge.svg)

An opinionated `libcurl` wrapper for Swift

## ⌨️ Usage

There are 2 ways to use this library which kinda represents the [libcurl-easy](https://curl.se/libcurl/c/libcurl-easy.html) and [libcurl-share](https://curl.se/libcurl/c/libcurl-share.html)

### `CURL.swift` 
Each request is run in total isolation. 

```swift
let req = CURL(
    method: "GET",
    url:
        "https://httpbin.org/get"
)
let res = try req.perform()
```

### `CURLSH.swift`
Allow multiple requests to share cookies, dns cache, ssl session, and other goodies. 

```swift
let share = CURLSH()
let res = try share.perform(curl: req) 
```

## 🏛 Design choices

- The url string passed in will not be escaped, handle it at the call-site.
