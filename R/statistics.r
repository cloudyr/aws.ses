get_quota <- function(...) {
    query <- list(Action = "GetSendQuota")
    r <- sesPOST(query = query, ...)
    return(r)
}

get_statistics <- function(...) {
    query <- list(Action = "GetSendStatistics")
    r <- sesPOST(query = query, ...)
    return(r)
}

