# curl-swift ![status badge](https://github.com/khoi/curl-swift/actions/workflows/test.yml/badge.svg)
https://github.com/khoi/curl-swift/actions/workflows/test.yml/badge.svg


An opinionated `libcurl` wrapper for Swift

## Design choices

- The url string passed in will not be escaped, handle it at the call-site.
