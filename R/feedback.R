#' @rdname feedback
#' @title Enable SES Feedback
#' @description Enable feedback forwarding
#' @template identity
#' @template dots
#' @param forwarding A logical indicating whether to enable (\code{TRUE}) or disable (\code{FALSE}) feedback forwarding.
#' @export
set_feedback <- function(identity, forwarding = TRUE, ...) {
    query <- list(Action = "SetIdentityFeedbackForwardingEnabled", 
                  Identity = identity,
                  ForwardingEnabled = tolower(as.character(forwarding)))
    r <- sesPOST(query = query, ...)
    structure(r[["SetIdentityFeedbackForwardingEnabledResponse"]][["SetIdentityFeedbackForwardingEnabledResult"]],
              RequestId = r[["SetIdentityFeedbackForwardingEnabledResponse"]][["ResponseMetadata"]][["RequestId"]])
}
