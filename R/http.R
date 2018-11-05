#' @title SES HTTP Requests
#' @description Low-level SES POST function
#' @param query A list containing query string parameters
#' @param headers A list of headers to pass to the HTTP request.
#' @param body A list of query-like parameters to be passed as a form-encoded message body.
#' @param verbose A logical indicating whether to be verbose. Default is given by \code{options("verbose")}.
#' @param region A character string specifying an AWS region. See \code{\link[aws.signature]{locate_credentials}}.
#' @param key A character string specifying an AWS Access Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param secret A character string specifying an AWS Secret Key. See \code{\link[aws.signature]{locate_credentials}}.
#' @param session_token Optionally, a character string specifying an AWS temporary Session Token to use in signing a request. See \code{\link[aws.signature]{locate_credentials}}.
#' @param force_credentials A logical set to \code{TRUE} or \code{FALSE}. Use \code{TRUE} only if you are providing the key, secret, and region parameters.
#' @param \dots Additional arguments passed to \code{\link[httr]{POST}}.
#' @import httr
#' @importFrom aws.signature signature_v4_auth
#' @importFrom utils URLencode
#' @importFrom jsonlite fromJSON
#' @export
sesPOST <-
function(
  query = list(),
  headers = list(),
  body = NULL,
  verbose = getOption("verbose", FALSE),
  region = NULL,
  key = NULL,
  secret = NULL,
  session_token = NULL,
  force_credentials = FALSE,
  ...
) {
    # if necessary, locate and validate credentials
    if(!isTRUE(force_credentials)) {
       if(is.null(region)) {
          region <- "us-east-1"
          warning("AWS SES region defaulting to us-east-1. For us-west-2 or eu-west-1, set region parameter.")
       }
       SESregion <- region
       region <- Sys.getenv("AWS_DEFAULT_REGION", "us-east-1")
       credentials <- aws.signature::locate_credentials(key = key, secret = secret, session_token = session_token, region = region, verbose = verbose)
       key <- credentials[["key"]]
       secret <- credentials[["secret"]]
       session_token <- credentials[["session_token"]]
       region <- SESregion
    }

    # generate request signature
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
           session_token = session_token,
           verbose = verbose)
    # setup request headers
    headers[["x-amz-date"]] <- d_timestamp
    headers[["x-amz-content-sha256"]] <- Sig$BodyHash
    headers[["Authorization"]] <- Sig[["SignatureHeader"]]
    if (!is.null(session_token) && session_token != "") {
        headers[["x-amz-security-token"]] <- session_token
    }
    H <- do.call(add_headers, headers)

    # execute request
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
        x <- try(jsonlite::fromJSON(content(r, "text", encoding = "UTF-8"))$Error, silent = TRUE)
        warn_for_status(r)
        h <- headers(r)
        out <- structure(x, headers = h, class = "aws_error")
        attr(out, "request_canonical") <- Sig$CanonicalRequest
        attr(out, "request_string_to_sign") <- Sig$StringToSign
        attr(out, "request_signature") <- Sig$SignatureHeader
    } else {
        out <- try(jsonlite::fromJSON(content(r, "text", encoding = "UTF-8")), silent = TRUE)
        if (inherits(out, "try-error")) {
            out <- structure(content(r, "text", encoding = "UTF-8"), class = "unknown")
        }
    }
    return(out)
}
