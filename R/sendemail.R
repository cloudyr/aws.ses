#' @rdname sendemail
#' @title Send Email via SES
#' @description Send email via Amazon SES service
#' @param message A character string specifying the message body
#' @param subject A character string specifying the email subject
#' @param from A character string specifying teh sender
#' @param to A character vector of TO recipient email addresses.
#' @param cc A character vector of CC recipient email addresses.
#' @param bcc A character vector of BCC recipient email addresses.
#' @param replyto A character vector of reply-to email addresses.
#' @param returnpath A character string specifying the email address to which feedback and bounces are sent.
#' @template dots
#' @details Send a test or raw email message.
#' @examples
#' \dontrun{
#' send_email("Test Email Body", "Test Email", from = "me@example.com", to = "ex@example.com")
#' }
#' @export
send_email <- 
function(message,
         subject,
         from,
         to = NULL,
         cc = NULL,
         bcc = NULL,
         replyto = NULL,
         returnpath = NULL,
         ...) {
    query <- list(Action = "SendEmail", Source = from)
    query[["Message"]] <- list(Body = message, Subject = subject)
    query[["Destination"]] <- list(ToAddresses = to,
                                   CcAddresses = cc,
                                   BccAddresses = bcc)
    if (!is.null(replyto)) {
      query[["ReplyToAddresses"]] <- replyto
    }
    if (!is.null(returnpath)) {
      query[["ReturnPath"]] <- returnpath
    }
    
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname sendemail
#' @param body A raw vector containing a valid email body (of no more than 10MB in size).
#' @export
send_raw_email <- 
function(body,
         from,
         to = NULL,
         cc = NULL,
         bcc = NULL,
         ...) {
    query <- list(Action = "SendRawEmail", Source = from)
    query[["RawMessage"]] <- list(Data = body)
    
    r <- sesPOST(query = query, ...)
    return(r)
}
