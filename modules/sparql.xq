xquery version "3.0";

declare variable $headers := 
    <headers> 
        <header name="Content-Type" value="application/x-www-form-urlencoded"/>
        <header name="Accept" value="application/sparql-results+xml"/> 
    </headers>; 

declare variable $sparqlendpoint := doc('/db/apps/snapsec/config/config.xml')//sparqlquery/text();

declare function local:post($payload) { 
    let $uri := xs:anyURI($sparqlendpoint)
    return 
        httpclient:post($uri, $payload, false(), $headers) 
}; 


let $s := ""
let $p := string-join(for $i in request:get-parameter-names()
return concat($s,$i,"=",request:get-parameter($i,''),"&amp;")
)

return local:post($p)//httpclient:body/*
