#' @export
get_dkim <- function(identity, ...) {
    query <- list(Action = "GetIdentityDkimAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    query <- c(query, identity)
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @export
set_dkim <- function(identity, enabled, ...) {
    query <- list(Action = "SetDkimEnabled", 
                  Identity = identity,
                  DkimEnabled = tolower(as.character(enabled)))
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @export
verify_dkim <- function(domain, ...) {
    query <- list(Action = "VerifyDomainDkim", Domain = domain)
    r <- sesPOST(query = query, ...)
    return(r)
}
