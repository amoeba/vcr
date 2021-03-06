#' The response of an HTTPInteraction
#'
#' @keywords internal
#' @param status the status of the response
#' @param headers the response headers
#' @param body the response body
#' @param http_version the HTTP version
#' @param adapter_metadata Additional metadata used by a specific VCR adapter.
#' @details
#' \strong{Methods}
#'   \describe{
#'     \item{\code{to_hash()}}{
#'       Create a hash.
#'     }
#'     \item{\code{from_hash()}}{
#'       Get a hash back to an R list.
#'     }
#'   }
#' @format NULL
#' @usage NULL
#' @examples \dontrun{
#' url <- "http://httpbin.org/post"
#' body <- list(foo = "bar")
#' (res <- httr::POST(url, body = body))
#' (x <- Response$new(
#'    c(status_code = res$status_code, httr::http_status(res)),
#'    res$headers,
#'    content(res, "text"),
#'    res$all_headers[[1]]$version))
#' x$body
#' x$status
#' x$headers
#' x$http_version
#' x$to_hash()
#' x$from_hash()
#' }
Response <- R6::R6Class('Response',
   public = list(
     status = NULL,
     headers = NULL,
     body = NULL,
     http_version = NULL,
     adapter_metadata = NULL,
     hash = NULL,

     initialize = function(status, headers, body, http_version, adapter_metadata = NULL) {
       if (!missing(status)) self$status <- status
       if (!missing(headers)) self$headers <- headers
       if (!missing(body)) {
         if (inherits(body, "list")) {
           body <- paste(names(body), body, sep = "=", collapse = ",")
         }
         self$body <- body
       }
       if (!missing(http_version)) self$http_version <- http_version
       if (!missing(adapter_metadata)) self$adapter_metadata <- adapter_metadata
     },

     to_hash = function() {
       self$hash <- list(
         status       = self$status,
         headers      = self$headers,
         body         = serializable_body(self$body),
         http_version = self$http_version
       )
       return(self$hash)
     }

     # from_hash = function() {
     #   list(
     #     self$hash[['status']],
     #     self$hash[['headers']],
     #     body_from(self$hash[['body']]),
     #     self$hash[['http_version']],
     #     self$hash[['adapater_metadata']]
     #   )
     # }
   )
)
