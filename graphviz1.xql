import module namespace gv = "http://kitwallace.co.uk/ns/graphviz" at "/db/apps/graphviz/lib/graphviz.xqm";
declare namespace svg = "http://www.w3.org/2000/svg";
declare namespace dotml ="http://www.martin-loetzsch.de/DOTML";
declare namespace functx = "http://www.functx.com";
declare option exist:serialize "method=xhtml media-type=application/xhtml+xml";



declare function functx:word-count( $arg as xs:string? )  as xs:integer {
   count(tokenize($arg, '\W+')[. != ''])
 } ;
 
declare function functx:trim( $arg as xs:string? )  as xs:string {

   replace(replace($arg,'\s+$',''),'^\s+','')
 } ;

declare function functx:distinct-deep ( $nodes as node()* )  as node()* {

    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(functx:is-node-in-sequence-deep-equal(
                          .,$nodes[position() < $seq]))]
 } ;
declare function functx:is-node-in-sequence-deep-equal ( $node as node()? ,    $seq as node()* )  as xs:boolean {

   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 } ;
 
 
declare function local:clean-up-words($w){
  let $v := functx:trim($w)
  let $v0 :=   replace($v, '-', '_')
  let $v1 := replace($v0, ' ', '_')
  let $v2 := if(not($v1='')) then $v1
  else "EMPTY_ENTRY"
  return $v2
};

declare function local:triple-graph ($t) {
<dotml:graph rankdir="LR" nodesep="0.2" ranksep="0.2" size="20,16" >
 { for $triple in distinct-values(($t//subject,$t//object))
 where functx:word-count($triple)<=4
   return
    <dotml:node id="{local:clean-up-words($triple)}" style="filled" fillcolor="red"/>
 }
 <dotml:node id="TopNode" style="filled" fillcolor="blue"/>
 { let $rv := for $triple in $t//srch
   let $sub := $triple/subject
   let $obj := $triple/object
   let $pred := $triple/pred
   where functx:word-count($sub)<= 4 and functx:word-count($obj)<=4
   return
     <dotml:edge from="{local:clean-up-words($sub)}" to="{local:clean-up-words($obj)}" label="{$pred}"/>
   return functx:distinct-deep($rv)
 }
 {
   let $distinct-nodes := distinct-values(($t//subject[functx:word-count(.)<=4], $t//object[functx:word-count(.)<=4]))
   let $distinct-objects := distinct-values($t//object[functx:word-count(.)<=4])
   let $rv1 := for $n in distinct-values($distinct-nodes[not(.=$distinct-objects)])
   return
     <dotml:edge from="TopNode" to="{local:clean-up-words($n)}" label="topNode"/> 
   return functx:distinct-deep($rv1)
 }

</dotml:graph>
};



let $my-UID := request:get-parameter('UID', ())

let $isDba := xmldb:is-admin-user(xmldb:get-current-user())

let $t := if ($my-UID) then 
    let $tfile := concat("/db/datasets/snap/data/triples/", $my-UID, ".xml")
    return doc($tfile)//triples
else
    let $tfile := "/db/datasets/snap/data/triples"
    return collection($tfile)//triples

let $graph := local:triple-graph($t)
let $dot := gv:dotml-to-dot($graph)
let $svg := 
    if($isDba) then gv:dot-to-svg($dot)
        else
    system:as-user("admin", "sasadm1n", gv:dot-to-svg($dot))


return 
<html xmlns="http://www.w3.org/1999/xhtml" >
<body>

      <hr/>
      <table>
      <tr>
         <td>{$graph}</td>
         <td>
          <embed type="image/svg+xml" data="data:image/svg+xml;base64,{util:base64-encode($svg,true())}" width="600px" height="600px" />
         </td>
         <td>{$svg}</td>
             
      </tr>
      </table>
</body>
</html>
