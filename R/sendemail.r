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
    query <- list(Action = "SendEmail")
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @export
send_raw_email <- 
function(body,
         from,
         to = NULL,
         cc = NULL,
         bcc = NULL,
         ...) {
    query <- list(Action = "SendRawEmail")
    r <- sesPOST(query = query, ...)
    return(r)
}
