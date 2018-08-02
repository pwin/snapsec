xquery version "3.0";
import module namespace http="http://expath.org/ns/http-client";



declare variable $service := "http://localhost:3030/ds/sparql";

(:let $pred := request:get-parameter('pred','<http://example/update-base/#part_of>'):)
let $pred := '<http://example/update-base/#part_of>'
let $query := concat(" PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>  PREFIX yoc: <http://example/update-base/#> select  ?from ?to ?label  where  {  ?from ", $pred  , "  ?to . ?from ?label ?to .   } ")

let $sparql := concat($service,"?output=xml&amp;query=",encode-for-uri($query) )
let $request := <http:request href="{$sparql}" method="GET"/>
let $result :=  http:send-request($request)
let $serialize := util:declare-option("exist:serialize","method=text media-type=text/text")
let $xsl := doc("/db/apps/snap/resources/styles/sparqlResult2dot.xsl")
return 
  transform:transform($result,$xsl,())

