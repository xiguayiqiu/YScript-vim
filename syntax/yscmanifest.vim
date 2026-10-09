if exists("b:current_syntax")
  finish
endif

syntax match yscManifestComment /^\s*#.*$/
syntax match yscManifestKeyword /^\s*\%(models\|res\|dep\)\>/
syntax match yscManifestHash /\<h1:[A-Za-z0-9+\/]\+=[=]*/
syntax region yscManifestString start=/"/ skip=/\\./ end=/"/
syntax match yscManifestDelimiter /[][]\|:/

highlight default link yscManifestComment Comment
highlight default link yscManifestKeyword Keyword
highlight default link yscManifestHash Number
highlight default link yscManifestString String
highlight default link yscManifestDelimiter Delimiter

let b:current_syntax = "yscmanifest"
