get_id_notification <- function(identity, ...) {
    query <- list(Action = "GetIdentityNotificationAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    r <- sesPOST(query = query, ...)
    return(r)
}

set_id_notification <- function(identity, type, topic, ...) {
    query <- list(Action = "SetIdentityNotificationAttributes")
    query$Identity <- identity
    vtype <- c("Bounce", "Complaint", "Delivery")
    if (!type %in% vtype) {
        stop("'type' must be one of: ", paste0(vtype, collapse = ", "))
    }
    query$NotificationType <- type
    if (!missing(topic)) {
        query$SnsTopic <- topic
    }
    r <- sesPOST(query = query, ...)
    return(r)
}
