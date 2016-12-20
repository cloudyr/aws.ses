#' @rdname dkim
#' @title DKIM
#' @description Manage DKIM
#' @template identity
#' @template dots
#' @examples 
#' \dontrun{
#' verify_dkim("example.com")
#' get_dkim("me@example.com")
#' set_dkim("me@example.com", TRUE)
#' get_dkim("me@example.com")
#' }
#' @export
get_dkim <- function(identity, ...) {
    query <- list(Action = "GetIdentityDkimAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    query <- c(query, identity)
    r <- sesPOST(query = query, ...)
    structure(r[["GetIdentityDkimAttributesResponse"]][["GetIdentityDkimAttributesResult"]][["DkimAttributes"]],
          RequestId = r[["GetIdentityDkimAttributesResponse"]][["ResponseMetadata"]][["RequestId"]])

}

#' @rdname dkim
#' @param enabled A logical.
#' @export
set_dkim <- function(identity, enabled = TRUE, ...) {
    query <- list(Action = "SetIdentityDkimEnabled", 
                  Identity = identity,
                  DkimEnabled = tolower(as.character(enabled)))
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname dkim
#' @param domain A character string containing a domain.
#' @export
verify_dkim <- function(domain, ...) {
    query <- list(Action = "VerifyDomainDkim", Domain = domain)
    r <- sesPOST(query = query, ...)
    return(r)
}
