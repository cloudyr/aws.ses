#' @rdname dkim
#' @title DKIM
#' @description Manage DKIM
#' @template identity
#' @template dots
#' @examples 
#' \dontrun{
#' set_dkim(id, TRUE)
#' get_dkim(id)
#' }
#' @export
get_dkim <- function(identity, ...) {
    query <- list(Action = "GetIdentityDkimAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    query <- c(query, identity)
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname dkim
#' @param enabled A logical.
#' @export
set_dkim <- function(identity, enabled, ...) {
    query <- list(Action = "SetDkimEnabled", 
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
