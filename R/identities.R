#' @rdname identities
#' @title SES Identities
#' @description Manage SES Identities
#' @param type A character string specifying the identity type.
#' @param nmax An integer specifying the maximum number of identities to return.
#' @param next_token A pagination token
#' @template dots
#' @details \code{verify_id} sends an email verification request to the specified email address.
#' @return \code{list_ids} returns a character vector of verified email addresses or domains.
#' @examples 
#' \dontrun{
#' # verify an addres
#' verify_id("example@example.com")
#' get_verification_attrs("example@example.com")
#' 
#' list_ids()
#'
#' # remove identity
#' delete_id("example@example.com")
#' }
#' @seealso \code{\link{get_id_notification}}
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
    structure(r[["ListIdentitiesResponse"]][["ListIdentitiesResult"]][["Identities"]],
              NextToken = r[["ListIdentitiesResponse"]][["ListIdentitiesResult"]][["NextToken"]],
              RequestId = r[["ListIdentitiesResponse"]][["ResponseMetadata"]][["RequestId"]])
}

#' @rdname identities
#' @param address A charcter string specifying an email address.
#' @param domain A character string specifying a domain.
#' @export
verify_id <- function(address, domain, ...) {
    query <- list(Action = "VerifyEmailIdentity")
    if ((missing(address) & missing(domain)) | (!missing(address) & !missing(domain))) {
        stop("Must specify 'address' or 'domain'")
    }
    if (!missing(address)) {
        query[["EmailAddress"]] <- address
    } else if (!missing(domain)) {
        query[["Domain"]] <- domain
    }
    r <- sesPOST(query = query, ...)
    structure(r[["VerifyEmailIdentityResponse"]][["VerifyEmailIdentityResult"]],
              RequestId = r[["VerifyEmailIdentityResponse"]][["ResponseMetadata"]][["RequestId"]])
}

#' @rdname identities
#' @template identity
#' @export
get_verification_attrs <- function(identity, ...) {
    query <- list(Action = "GetIdentityVerificationAttributes")
    identity <- as.list(identity)
    names(identity) <- paste0("Identities.member.", seq_along(identity))
    query <- c(query, identity)
    r <- sesPOST(query = query, ...)
    r <- r[["GetIdentityVerificationAttributesResponse"]]
    structure(r[["GetIdentityVerificationAttributesResult"]][["VerificationAttributes"]],
              RequestId = r[["ResponseMetadata"]][["RequestId"]])
}

#' @rdname identities
#' @export
delete_id <- function(identity, ...) {
    query <- list(Action = "DeleteIdentity", Identity = identity)
    r <- sesPOST(query = query, ...)
    structure(r[["DeleteIdentityResponse"]][["DeleteIdentityResult"]],
              RequestId = r[["DeleteIdentityResponse"]][["ResponseMetadata"]][["RequestId"]])
}
