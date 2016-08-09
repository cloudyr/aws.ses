#' @rdname idnotification
#' @title Get/Set Notifications
#' @description Get/Set ID Notifications
#' @template identity
#' @template dots
#' @examples 
#' \dontrun{
#' # get
#' get_id_notifiaction()
#' # set
#' set_id_notifiaction()
#' }
#' @export
get_id_notification <- function(identity, ...) {
    query <- list(Action = "GetIdentityNotificationAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname idnotification
#' @param type A character string specifying a notification type.
#' @param topic An SNS topic name
#' @export
set_id_notification <- 
function(identity, type = c("Bounce", "Complaint", "Delivery"), topic, ...) {
    query <- list(Action = "SetIdentityNotificationAttributes")
    query$Identity <- identity
    query$NotificationType <- match.arg(type) 
    if (!missing(topic)) {
        query$SnsTopic <- topic
    }
    r <- sesPOST(query = query, ...)
    return(r)
}
