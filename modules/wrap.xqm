xquery version "3.0";
(: ~
 : Module to create SPARQL update from XML 
 : 
 :)

module namespace wrap="http://kirmit:2020/exist/apps/snap/sparqlwrapper";
declare namespace httpclient= "http://exist-db.org/xquery/httpclient";
import module namespace functx="http://www.functx.com";

declare function wrap:update($graph as xs:string, $s as xs:string, $username, $password){
  let $url := doc('/db/apps/snapsec/config/config.xml')//sparqlupdate/text()
  let $content := concat("update=prefix ps:<http://gov.scot/policysnap/> Insert Data{ graph  <",$graph,"> { ", $s, " .  } }")
  let $credentials := concat($username, ':', $password)
  let $encode := util:base64-encode($credentials)
  let $value := concat('Basic ', $encode)
  let $headers :=
  <headers>
     <header name="Content-Type" value="application/x-www-form-urlencoded"/>
     <header name="Authorization" value="{$value}"/>
  </headers>
  return httpclient:post($url, $content, false(), $headers)
};




declare function wrap:wrap($s as xs:string){
    concat("ps:", replace(functx:trim($s),'(\p{P}|\p{Z})+', '_'))
};

declare function wrap:quote($s as xs:string){
    let $quote := "&#34;"
    return concat($quote,$quote,$quote, $s , $quote,$quote,$quote)
};

declare function wrap:createsparqlupdate($n as node()){
  let $graph := concat(":",$n//uid)
  let $username := doc('/db/apps/snapsec/config/config.xml')//uid/text()
  let $password := doc('/db/apps/snapsec/config/config.xml')//pwd/text()
  let $data := for $t in $n//srch
  return
    if (functx:trim($t/pred) eq "a" or functx:trim($t/pred) eq "Is (a)") then
        (wrap:update($graph, concat(wrap:wrap(functx:trim($t/subject)), " a ", wrap:wrap(functx:trim($t/object))), $username, $password))

    else if (functx:trim($t/pred) eq "same as" or functx:trim($t/pred) eq "sameas") then
        (wrap:update($graph, concat(wrap:wrap(functx:trim($t/subject)), " <http://www.w3.org/2002/07/owl#sameAs> ", wrap:wrap(functx:trim($t/object))), $username, $password))
            
    else if (functx:word-count($t/object) le 3) then 
        (wrap:update($graph, concat(wrap:wrap(functx:trim($t/subject)), "  ", wrap:wrap(functx:trim($t/pred)), "  ", wrap:wrap(functx:trim($t/object))), $username, $password))
                
    else if (functx:word-count($t/object) gt 3) then 
        (wrap:update($graph, concat(wrap:wrap(functx:trim($t/subject)), "  ", wrap:wrap(functx:trim($t/pred)), "  ", wrap:quote(functx:trim($t/object)),"^^<http://www.w3.org/2001/XMLSchema#string>"), $username, $password))
                
    else ()
    let $data1 := for $t in $n//srch
    return 
        if (functx:word-count($t/subject) le 3) then 
                (wrap:update($graph, concat(wrap:wrap(functx:trim($t/subject)), "  <http://www.w3.org/2000/01/rdf-schema#label>  ",  wrap:quote(functx:trim($t/subject)), "^^<http://www.w3.org/2001/XMLSchema#string>"), $username, $password))
        else ()

    let $data2 := for $t in $n//srch
    return 
        if (functx:word-count($t/object) le 3) then 
                (wrap:update($graph, concat(wrap:wrap(functx:trim($t/object)), "  <http://www.w3.org/2000/01/rdf-schema#label>  ",  wrap:quote(functx:trim($t/object)), "^^<http://www.w3.org/2001/XMLSchema#string>"), $username, $password))
        else ()        
                
return <responses>{($data, $data1, $data2)}</responses>                    
  
};


