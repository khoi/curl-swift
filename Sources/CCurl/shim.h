#ifndef CURL_EXTENSIONS
#define CURL_EXTENSIONS

#include <stdbool.h>
#include <curl/curl.h>

static CURLcode curl_easy_setopt_string(CURL *curl, CURLoption option, const char *param) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_bool(CURL *curl, CURLoption option, bool param) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_long(CURL *curl, CURLoption option, long param) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_write_func(CURL *curl, CURLoption option, size_t (*param)(void *, size_t, size_t, void *)) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_write_data(CURL *curl, CURLoption option, void *param) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_ptr_slist(CURL *curl, CURLoption option, struct curl_slist *param) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_ptr_char(CURL *curl, CURLoption option, char *param) {
    return curl_easy_setopt(curl, option, param);
}

static CURLcode curl_easy_setopt_share(CURL *curl, CURLSH *share) {
    return curl_easy_setopt(curl, CURLSHOPT_SHARE, share);
}

static CURLcode curl_easy_getinfo_long(CURL *curl, CURLINFO info, long *param) {
    return curl_easy_getinfo(curl, info, param);
}

static CURLcode curl_easy_getinfo_string(CURL *curl, CURLINFO info, const char **param) {
    return curl_easy_getinfo(curl, info, param);
}

struct curl_memory_struct {
    void *ptr;
    size_t size;
};

// https://curl.se/libcurl/c/CURLOPT_WRITEFUNCTION.html
static size_t curl_write_callback_fn(void *data, size_t size, size_t nmemb, void *userp) {
    size_t realsize = size * nmemb;
    struct curl_memory_struct *mem = (struct curl_memory_struct *)userp;
    
    char *ptr = realloc(mem->ptr, mem->size + realsize + 1);
    if(ptr == NULL)
        return 0;  /* out of memory! */
    
    mem->ptr = ptr;
    memcpy(&(mem->ptr[mem->size]), data, realsize);
    mem->size += realsize;
    ((char *)mem->ptr)[mem->size] = 0;
    
    return realsize;
}

static CURLSHcode curl_share_setopt_lockdata(CURLSH *share, CURLSHoption option, curl_lock_data param) {
    return curl_share_setopt(share, option, param);
}

static CURLSHcode curl_share_setopt_string(CURLSH *share, CURLSHoption option, const char *param) {
    return curl_share_setopt(share, option, param);
}

static CURLSHcode curl_share_setopt_bool(CURLSH *share, CURLSHoption option, bool param) {
    return curl_share_setopt(share, option, param);
}

static CURLSHcode curl_share_setopt_long(CURLSH *share, CURLSHoption option, long param) {
    return curl_share_setopt(share, option, param);
}

#endif
