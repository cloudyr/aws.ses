#' @rdname identities
#' @title SES Identities
#' @description Manage SES Identities
#' @param type A character string specifying the identity type.
#' @param nmax An integer specifying the maximum number of identities to return.
#' @param next_token A pagination token
#' @template dots
#' @examples 
#' \dontrun{
#' list_ids(nmax = 5)
#' }
#' @export
list_ids <- 
function(type = c("EmailAddress","Domain"), 
         nmax = NULL, 
         next_token = NULL, 
         ...) {
    query <- list(Action = "ListIdentities")
    query$IdentityType <- match.arg(type)
    if (!is.null(nmax) && (nmax > 100 | nmax < 1)) {
        stop("'nmax' must be > 1 and < 100")
    }
    query$MaxItems <- nmax
    if (!is.null(next_token)) {
        query$NextToken <- next_token
    }
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname identities
#' @param address A charcter string specifying an email address.
#' @param domain A character string specifying a domain.
#' @export
verify_id <- function(address, domain, ...) {
    query <- list(Action = "VerifyEmailIdentity")
    if (missing(address) & missing(domain)) {
        stop("Must specify 'address' or 'domain'")
    }
    if (!missing(address)) {
        query$EmailAddress <- address
    } else if (!missing(domain)) {
        query$Domain <- domain
    }
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname identities
#' @template identity
#' @export
get_verification_attrs <- function(identity, ...) {
    query <- list(Action = "GetIdentityVerificationAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", 1:length(identity))
    r <- sesPOST(query = query, ...)
    return(r)
}

#' @rdname identities
#' @export
delete_id <- function(identity, ...) {
    query <- list(Action = "DeleteIdentity", Identity = identity)
    r <- sesPOST(query = query, ...)
    return(r)
}
