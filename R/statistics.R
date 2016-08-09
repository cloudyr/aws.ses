#' @title Get Quota
#' @description Get Quota
#' @template dots
#' @examples 
#' \dontrun{
#' get_quota()
#' } 
#' @export
get_quota <- function(...) {
    query <- list(Action = "GetSendQuota")
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @title Get Statistics
#' @description Get Statistics
#' @template dots
#' @examples 
#' \dontrun{
#' get_statistics()
#' } 
#' @export
get_statistics <- function(...) {
    query <- list(Action = "GetSendStatistics")
    r <- sesPOST(query = query, ...)
    return(r)
}

