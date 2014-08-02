window.RustKit.controller 'Base64', [->
  class Base64
    #https://developer.mozilla.org/en-US/docs/Web/JavaScript/Base64_encoding_and_decoding
    utf8_to_b64:(str) ->
      window.btoa(unescape(encodeURIComponent(str)));
    b64_to_utf8: (str) ->
      decodeURIComponent(escape(window.atob(str)));
