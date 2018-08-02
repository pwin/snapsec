xquery version "3.0";
import module namespace http="http://expath.org/ns/http-client";
declare namespace s="http://www.w3.org/2005/sparql-results#";
declare variable $service := "http://localhost:3030/ds/sparql";

(:let $pred := request:get-parameter('pred','<http://example/update-base/#part_of>'):)
let $pred := 'http://example/update-base/#part_of'
(:let $query := concat(" PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>  PREFIX yoc: <http://example/update-base/#> select  ?from ?to ?label  where  {  ?from ", concat('<',$pred,'>')  , "  ?to . ?from ?label ?to .   } ")
:)

let $query := " PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>  PREFIX yoc: <http://example/update-base/#> select  ?from ?to ?label  where  {  ?from ?label ?to .   } "

let $sparql := concat($service,"?output=xml&amp;query=",encode-for-uri($query) )
let $request := <http:request href="{$sparql}" method="GET"/>
let $result :=  http:send-request($request)
(:let $serialize := util:declare-option("exist:serialize","method=text media-type=text/text"):)
let $nodes := for $n in distinct-values(($result[2]//s:binding[@name='from']/s:uri, $result[2]//s:binding[@name='to']/s:uri))
return  <Node id="{$n}" name="{normalize-space(tokenize($n,'/')[last()])}" dataURL=""/>
let $topNode := <Comment id="TopNode" name="Top Node" dataURL=""><![CDATA[The Top Node links nodes that lack a parent.]]></Comment>
let $topNodes := for $n in distinct-values(($result[2]//s:binding[@name='from']/s:uri, $result[2]//s:binding[@name='to']/s:uri))
where empty($result[2]//s:result/s:binding[@name='to'][s:uri=$n])
return <DirectedRelation fromID="TopNode" toID="{normalize-space($n)}"  labelText="TopLevel" color="0x12CDE4" letterSymbol="TL"/>

let $relations := for $r in $result[2]//s:result
return <DirectedRelation fromID="{normalize-space($r/s:binding[@name='from'])}" toID="{normalize-space($r/s:binding[@name='to'])}"  labelText="{normalize-space(tokenize($r/s:binding[@name='label'],'/')[last()])}"/>
return 
<RelationViewerData>
	<Settings appTitle="Relation browser demo" startID="TopNode" defaultRadius="150" maxRadius="180">
		<RelationTypes>
			<UndirectedRelation color="0x85CDE4" lineSize="4" labelText="association" letterSymbol="B"/>
			<DirectedRelation color="0xAAAAAA" lineSize="4"/>
			<MyCustomRelation color="0xB7C631" lineSize="4" labelText="created by" letterSymbol="C"/>		
		</RelationTypes>
		<NodeTypes>
			<Node/>
			<Comment/>
			<Person/>
			<Document/>
		</NodeTypes>
	</Settings>
<Nodes>{($topNode,$nodes)}</Nodes>
<Relations>{($topNodes,$relations)}</Relations>
</RelationViewerData>

