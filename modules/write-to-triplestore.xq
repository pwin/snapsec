xquery version "3.0";
import module namespace wrap="http://kirmit:2020/exist/apps/snap/sparqlwrapper" at "wrap.xqm";

let $uid := request:get-parameter("uid", ())
let $retVal := if(string-length($uid) gt 0) then
    wrap:createsparqlupdate(doc(concat('/db/datasets/snap/data/triples/',$uid,'.xml')))
    else
        ()
    
return $retVal    