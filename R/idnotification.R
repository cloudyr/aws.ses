#' @rdname idnotification
#' @title Get/Set Notifications
#' @description Get/Set ID Notifications
#' @template identity
#' @template dots
#' @examples 
#' \dontrun{
#' # get
#' get_id_notifiaction("example@example.com")
#' 
#' # set
#' if (require("aws.sns")) {
#'   top <- create_topic("ses_email_bounce")
#'   set_id_notifiaction("example@example.com", "Bounce", top)
#'   get_id_notifiaction("example@example.com")
#'   
#'   # cleanup
#'   delete_topic(top)
#' }
#' }
#' @seealso \code{\link{verify_id}}, \code{\link[aws.sns]{create_topic}}
#' @export
get_id_notification <- function(identity, ...) {
    query <- list(Action = "GetIdentityNotificationAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", seq_along(identity))
    query <- c(query, identity)
    r <- sesPOST(query = query, ...)
    r <- r[["GetIdentityNotificationAttributesResponse"]]
    structure(r[["GetIdentityNotificationAttributesResult"]][["NotificationAttributes"]],
              RequestId = r[["ResponseMetadata"]][["RequestId"]])
}

#' @rdname idnotification
#' @param type A character string specifying a notification type.
#' @param topic An SNS topic name. See \code{\link[aws.sns]{create_topic}}
#' @export
set_id_notification <- 
function(identity, type = c("Bounce", "Complaint", "Delivery"), topic, ...) {
    query <- list(Action = "SetIdentityNotificationTopic")
    query$Identity <- identity
    query$NotificationType <- match.arg(type) 
    if (!missing(topic)) {
        query$SnsTopic <- topic
    }
    r <- sesPOST(query = query, ...)
    structure(r[["SetIdentityNotificationTopicResponse"]][["SetIdentityNotificationTopicResult"]],
              RequestId = r[["ResponseMetadata"]][["RequestId"]])
}
