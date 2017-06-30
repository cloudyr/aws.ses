#' @title SES HTTP Requests
#' @description Low-level SES POST function
#' @param query A list containing query string parameters
#' @param body A list of query-like parameters to be passed as a form-encoded message body.
#' @param region A character string containing an AWS region. If missing, the default \dQuote{us-east-1} is used.
#' @param key A character string containing an AWS Access Key ID. See \code{\link[aws.signature]{locate_credentials}}.
#' @param secret A character string containing an AWS Secret Access Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param session_token Optionally, a character string containing an AWS temporary Session Token. See \code{\link[aws.signature]{locate_credentials}}.
#' @param \dots Additional arguments passed to \code{\link[httr]{POST}}.
#' @import httr
#' @importFrom aws.signature signature_v4_auth
#' @importFrom utils URLencode
#' @importFrom jsonlite fromJSON
#' @export
sesPOST <- function(query = list(), 
                    body = NULL,
                    region = Sys.getenv("AWS_DEFAULT_REGION","us-east-1"), 
                    key = NULL, 
                    secret = NULL, 
                    session_token = NULL,
                    ...) {
    uri <- paste0("https://email.",region,".amazonaws.com")
    d_timestamp <- format(Sys.time(), "%Y%m%dT%H%M%SZ", tz = "UTC")
    body_to_sign <- if (is.null(body)) {
        "" 
    } else {
        paste0(names(body), "=", sapply(unname(body), utils::URLencode, reserved = TRUE), collapse = "&")
    }
    Sig <- signature_v4_auth(
           datetime = d_timestamp,
           region = region,
           service = "email",
           verb = "POST",
           action = "/",
           query_args = query,
           canonical_headers = list(host = paste0("email.",region,".amazonaws.com"),
                                    `x-amz-date` = d_timestamp),
           request_body = body_to_sign,
           key = key, 
           secret = secret,
           session_token = session_token)
    headers <- list()
    headers[["x-amz-date"]] <- d_timestamp
    headers[["x-amz-content-sha256"]] <- Sig$BodyHash
    if (!is.null(session_token) && session_token != "") {
        headers[["x-amz-security-token"]] <- session_token
    }
    headers[["Authorization"]] <- Sig[["SignatureHeader"]]
    H <- do.call(add_headers, headers)
    
    if (length(query)) {
        if (!is.null(body)) {
            r <- POST(uri, H, query = query, body = body, encode = "form", ...)
        } else {
            r <- POST(uri, H, query = query, ...)
        }
    } else {
        if (!is.null(body)) {
            r <- POST(uri, H, body = body, encode = "form", ...)
        } else {
            r <- POST(uri, H, ...)
        }
    }
    
    if (http_error(r)) {
        x <- try(fromJSON(content(r, "text", encoding = "UTF-8"))$Error, silent = TRUE)
        warn_for_status(r)
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- Sig$CanonicalRequest
        attr(out, "request_string_to_sign") <- Sig$StringToSign
        attr(out, "request_signature") <- Sig$SignatureHeader
    } else {
        out <- try(fromJSON(content(r, "text", encoding = "UTF-8")), silent = TRUE)
        if (inherits(out, "try-error")) {
            out <- structure(content(r, "text", encoding = "UTF-8"), class = "unknown")
        }
    }
    return(out)
}
