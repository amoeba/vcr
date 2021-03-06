vcr_c <- NULL
VCRHooks <- NULL
request_matchers <- NULL
request_ignorer <- NULL
cassette_serializers <- NULL
cassette_persisters <- NULL
light_switch <- NULL
vcr_cassettes <- NULL

initialize_ivars <- function() {
  light_switch <<- new.env()
  light_switch$turned_off <<- FALSE
  vcr_c$ignore_cassettes <<- FALSE
  vcr_c$cassettes <<- list()
  vcr_c$linked_context <<- NULL

  request_matchers <<- RequestMatcherRegistry$new()
  request_ignorer <<- RequestIgnorer$new()
  cassette_serializers <<- Serializers$new()
  cassette_persisters <<- Persisters$new()
}

.onLoad <- function(libname, pkgname){
  # vcr config object
  vcr_c <<- VCRConfig$new()
  # initialize default configuration vars
  vcr_configure()
  # initialize hooks
  VCRHooks <<- Hooks$new()
  # initialize bucket of cassettes in session
  vcr_cassettes <<- new.env()
  # lots of things
  initialize_ivars()
}

# this doesn't work, nor in .onLoad
# .onAttach <- function(libname, pkgname){
#   # set up logging
#   setHook(packageEvent("initializelog", "attach"), function(...) {
#     do.call(loggr::log_file, list(file_name = vcr_c$vcr_logging, vcr_c$vcr_logging_opts))
#   })
# }
