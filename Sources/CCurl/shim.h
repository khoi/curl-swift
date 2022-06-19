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

static CURLcode curl_easy_getinfo_long(CURL *curl, CURLINFO info, long *param) {
    return curl_easy_getinfo(curl, info, param);
}

struct _curl_helper_memory_struct {
    void *memory;
    size_t size;
};

static size_t _curl_helper_write_callback(void *buffer, size_t size, size_t nmemb, void *userp) {
    size_t real_size = size * nmemb;
    
    struct _curl_helper_memory_struct *mem = (struct _curl_helper_memory_struct *)userp;
    
    mem->memory = realloc(mem->memory, mem->size + real_size + 1);
    
    memcpy(&(((char *)mem->memory)[mem->size]), buffer, real_size);
    mem->size += real_size;
    ((char *)mem->memory)[mem->size] = 0;
    
    return real_size;
}

#endif
