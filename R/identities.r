list_ids <- function(type, nmax = NULL, next_token = NULL, ...) {
    query <- list(Action = "ListIdentities")
    if(type %in% c("EmailAddress","Domain"))
        stop("'type' must be 'EmailAddress' or 'Domain'")
    query$IdentityType <- type
    if(!is.null(nmax) && (nmax > 100 | nmax < 1))
        stop("'nmax' must be > 1 and < 100")
    query$MaxItems <- nmax
    if(!is.null(next_token))
        query$NextToken <- next_token
    r <- sesPOST(query = query, ...)
    return(r)
}

verify_id <- function(address, domain, ...) {
    query <- list(Action = "VerifyEmailIdentity")
    if(missing(address) & missing(domain))
        stop("Must specify 'address' or 'domain'")
    if(!missing(address))
        query$EmailAddress <- address
    else if(!missing(domain))
        query$Domain <- domain
    r <- sesPOST(query = query, ...)
    return(r)
}

get_verification_attrs <- function(identity, ...) {
    query <- list(Action = "GetIdentityVerificationAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    r <- sesPOST(query = query, ...)
    return(r)
}

delete_id <- function(identity, ...) {
    query <- list(Action = "DeleteIdentity", Identity = identity)
    r <- sesPOST(query = query, ...)
    return(r)
}
