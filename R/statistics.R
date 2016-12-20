#' @rdname sendemail
#' @examples 
#' \dontrun{
#' get_quota()
#' get_statistics()
#' } 
#' @export
get_quota <- function(...) {
    query <- list(Action = "GetSendQuota")
    r <- sesPOST(query = query, ...)
    structure(r[["GetSendQuotaResponse"]][["GetSendQuotaResult"]],
              RequestId = r[["GetSendQuotaResponse"]][["ResponseMetadata"]][["RequestId"]])
}

#' @rdname sendemail
#' @export
get_statistics <- function(...) {
    query <- list(Action = "GetSendStatistics")
    r <- sesPOST(query = query, ...)
    structure(r[["GetSendStatisticsResponse"]][["GetSendStatisticsResult"]][["SendDataPoints"]],
              RequestId = r[["GetSendStatisticsResponse"]][["ResponseMetadata"]][["RequestId"]])
}
