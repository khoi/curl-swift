# curl-swift

An opinionated `libcurl` wrapper for Swift

## Design choices

- The url string passed in will not be escaped, handle it at the call-site.
