#' @rdname sendemail
#' @title Send Email via SES
#' @description Send email via Amazon SES service
#' @param message A character string specifying the message body (as plain text). Must specify \code{html}, \code{message}, or both; or alternatively \code{raw}.
#' @param html A character string specifying the message body (as HTML). Must specify \code{html}, \code{message}, or both; or alternatively \code{raw}.
#' @param raw A raw vector containing a valid email body (of no more than 10MB in size). Can only specify \code{raw} xor \code{message}/\code{html}.
#' @param subject A character string specifying the email subject
#' @param from A character string specifying the sender. Must be AWS SES verified.
#' @param to A character vector of TO recipient email addresses.
#' @param cc A character vector of CC recipient email addresses.
#' @param bcc A character vector of BCC recipient email addresses.
#' @param replyto A character vector of reply-to email addresses.
#' @param returnpath A character string specifying the email address to which feedback and bounces are sent.
#' @param charset.message An optional character string specifying the character set, e.g., \dQuote{UTF-8}, \dQuote{ISO-8859-1}, etc. if \code{message} is not ASCII.
#' @param charset.html An optional character string specifying the character set, e.g., \dQuote{UTF-8}, \dQuote{ISO-8859-1}, etc. if \code{html} is not ASCII.
#' @param charset.subject An optional character string specifying the character set, e.g., \dQuote{UTF-8}, \dQuote{ISO-8859-1}, etc. if \code{subject} is not ASCII.
#' @param key A character string with the key from an Amazon user's access key who has permission to send email via Amazon SES.
#' @param secret  A character string with the secret from from an Amazon user's access key who has permission to send email via Amazon SES.
#' @param region A character string giving the region of the user's Amazon SES service. Note that AWS SES is only available in regions us-east-1, us-west-2, or eu-west-1.
#' @param force_credentials A logical set to \code{TRUE} or \code{FALSE}. Use \code{TRUE} only if you are providing the key, secret, and region parameters.
#' @template dots
#' @details Send a test or raw email message. \code{get_quota} and \code{get_statistics} provide information on remaining and used email rate limits, respectively. To use Amazon SES from any host, in AWS Identity and Access Management (IAM), create a new user with no password, directly attach an SES permission policy (eg: AmazonSESFullAccess), then in that user's "Security credentials" tab, click "Create access key". This will allow you to download a .csv file with a key and secret to use here. In this case, also set the \code{region} parameter to the region of your Amazon SES service and the \code{force_credentials} parameter to \code{TRUE}.
#' @return A character string containg the message ID.
#' @examples
#' \dontrun{
#' # verify email address
#' verify_identity("me@example.com")
#'
#' # if email verified, can be used to send a message
#' a <- get_verification_attrs("me@example.com")
#' if (a[[1]]$VerificationStatus == "Success") {
#'   # simple plain-text email
#'   send_email("Test Email Body", subject = "Test Email",
#'              from = "me@example.com", to = "recipient@example.com")
#'
#'   # html and plain text versions
#'   send_email(message = "Plain text body",
#'              html = "<div><p style='font-weight=bold;'>HTML text body</p></div>",
#'              subject = "Test Email",
#'              from = "me@example.com", to = "recipient@example.com")
#' }
#' }
#' @export
send_email <-
function(message,
         html,
         raw = NULL,
         subject,
         from,
         to = NULL,
         cc = NULL,
         bcc = NULL,
         replyto = NULL,
         returnpath = NULL,
         charset.subject = NULL,
         charset.message = NULL,
         charset.html = NULL,
         key = NULL,
         secret = NULL,
         region = NULL,
         force_credentials = FALSE,
         ...) {

    query <- list(Source = from)

    # configure message body and subject
    if (!is.null(raw)) {
        query[["Action"]] <- "SendRawEmail"
        query[["RawMessage"]] <- list(Data = raw)
    } else {
        query[["Action"]] <- "SendEmail"
        if (missing(message) & missing(html)) {
            stop("Must specify 'message', 'html', or both of them.")
        }
        if (!missing(message)) {
            query[["Message.Body.Text.Data"]] <- message
            if (!is.null(charset.message)) {
                query[["Message.Message.Charset"]] <- charset.message
            }
        }
        if (!missing(html)) {
            query[["Message.Body.Html.Data"]] <- html
            if (!is.null(charset.html)) {
                query[["Message.Body.Html.Charset"]] <- charset.html
            }
        }
        query[["Message.Subject.Data"]] <- subject
        if (!is.null(charset.subject)) {
            query[["Message.Subject.Charset"]] <- charset.subject
        }
    }

    # configure recipients
    if (length(c(to,cc,bcc)) > 50L) {
        stop("The total number of recipients cannot exceed 50.")
    }
    if (!is.null(to)) {
        names(to) <- paste0("Destination.ToAddresses.member.", seq_along(to))
        query <- c(query, to)
    }
    if (!is.null(cc)) {
        names(cc) <- paste0("Destination.CcAddresses.member.", seq_along(cc))
        query <- c(query, cc)
    }
    if (!is.null(bcc)) {
        names(bcc) <- paste0("Destination.BccAddresses.member.", seq_along(bcc))
        query <- c(query, bcc)
    }
    if (!is.null(replyto)) {
        names(replyto) <- paste0("ReplyToAddresses.member.", seq_along(replyto))
        query <- c(query, replyto)
    }
    if (!is.null(returnpath)) {
      query[["ReturnPath"]] <- returnpath
    }
    r <- sesPOST(body = query,
                 key = key,
                 secret = secret,
                 region = region,
                 force_credentials = force_credentials,
                 ...)
    return(r)
}
