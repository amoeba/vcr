<!--
%\VignetteEngine{knitr::knitr}
%\VignetteIndexEntry{vcr introduction}
%\VignetteEncoding{UTF-8}
-->



vr introduction
===============

Record 'HTTP' Calls to Disk

Right now `vcr` is not yet using previously cached requests, but will soon.

## installation

Development version from GitHub


```r
devtools::install_github("ropenscilabs/vcr")
```

Load `vcr`


```r
library("vcr")
```

## examples

list cassettes


```r
cassettes()
#> $foobar
#> <cassette> foobar
#>   Record method: once
#>   Serialize with: yaml
#>   Persist with: FileSystem
#>   update_content_length_header: FALSE
#>   decode_compressed_response: FALSE
#>   allow_playback_repeats: FALSE
#>   allow_unused_http_interactions: TRUE
#>   exclusive: FALSE
#>   preserve_exact_body_bytes: TRUE
#> 
#> $helloworld
#> <cassette> helloworld
#>   Record method: once
#>   Serialize with: yaml
#>   Persist with: FileSystem
#>   update_content_length_header: FALSE
#>   decode_compressed_response: FALSE
#>   allow_playback_repeats: FALSE
#>   allow_unused_http_interactions: TRUE
#>   exclusive: FALSE
#>   preserve_exact_body_bytes: TRUE
```

list the current cassette


```r
cassette_current()
#> $helloworld
#> <cassette> helloworld
#>   Record method: once
#>   Serialize with: yaml
#>   Persist with: FileSystem
#>   update_content_length_header: FALSE
#>   decode_compressed_response: FALSE
#>   allow_playback_repeats: FALSE
#>   allow_unused_http_interactions: TRUE
#>   exclusive: FALSE
#>   preserve_exact_body_bytes: TRUE
```

coerce various things to cassette objects


```r
as.cassette("helloworld")
#> $helloworld
#> <cassette> helloworld
#>   Record method: once
#>   Serialize with: yaml
#>   Persist with: FileSystem
#>   update_content_length_header: FALSE
#>   decode_compressed_response: FALSE
#>   allow_playback_repeats: FALSE
#>   allow_unused_http_interactions: TRUE
#>   exclusive: FALSE
#>   preserve_exact_body_bytes: TRUE
```


```r
as.cassette(cassettes()[1])
#> $foobar
#> <cassette> foobar
#>   Record method: once
#>   Serialize with: yaml
#>   Persist with: FileSystem
#>   update_content_length_header: FALSE
#>   decode_compressed_response: FALSE
#>   allow_playback_repeats: FALSE
#>   allow_unused_http_interactions: TRUE
#>   exclusive: FALSE
#>   preserve_exact_body_bytes: TRUE
```


```r
as.cassette(as.cassettepath("~/vcr/vcr_cassettes/foobar.yml"))
#> $foobar
#> <cassette> foobar
#>   Record method: once
#>   Serialize with: yaml
#>   Persist with: FileSystem
#>   update_content_length_header: FALSE
#>   decode_compressed_response: FALSE
#>   allow_playback_repeats: FALSE
#>   allow_unused_http_interactions: TRUE
#>   exclusive: FALSE
#>   preserve_exact_body_bytes: TRUE
```

list the path to where cassettes are stored


```r
cassette_path()
#> [1] "~/vcr/vcr_cassettes"
```

insert a cassette


```
#> Error: There is already a cassette with the same name: helloworld
```


```r
insert_cassette(name = "helloworld")
```

use a cassette (if cassette not found, we'll create the cassette)


```r
use_cassette("helloworld", GET("http://google.com"))
```

You can also pass a code block, instead of an inline call


```r
insert_cassette("foobar")
call_block("foobar", {
  url <- "http://httpbin.org/get"
  GET(url)
})
```

After running the above, `vcr` will record the HTTP request to disk as a cassette,
with content like:

```
---
http_interactions:
- request:
    method: get
    uri: http://example.com/
    body: ''
    headers: {}
  response:
    status:
      code: 200
      message: OK
    headers:
      Content-Type:
      - text/html;charset=utf-8
      Content-Length:
      - '26'
    body: This is the response body
    http_version: '1.1'
  recorded_at: Tue, 01 Nov 2011 04:58:44 GMT
recorded_with: VCR 2.0.0
```

Disconnect your computer from the internet.  Run the test again. It should pass since
VCR is automatically replaying the recorded response when the request is made.
