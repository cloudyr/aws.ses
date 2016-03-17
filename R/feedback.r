#' @export
set_feedback <- function(identity, forwarding, ...) {
    query <- list(Action = "SetIdentityFeedbackForwardingEnabled", 
                  Identity = identity,
                  ForwardingEnabled = tolower(as.character(forwarding)))
    r <- sesPOST(query = query, ...)
    return(r)
}
