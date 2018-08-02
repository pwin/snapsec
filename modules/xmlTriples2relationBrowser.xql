xquery version "3.0";

let $uid := request:get-parameter('uid',()) 

let $tripleDoc := 
if ($uid and $uid != 'undefined') then  doc(concat('/db/datasets/snap/data/triples/', $uid, '.xml')) 
else collection('/db/datasets/snap/data/triples')


let $distinct-nodes := distinct-values(($tripleDoc//subject, $tripleDoc//object))
let $spotlight-nodes := $tripleDoc[pred='Spotlight']
let $distinct-objects := distinct-values($tripleDoc//object)
let $nodes := for $n in $distinct-nodes

return  <Node id="{$n}" name="{normalize-space(tokenize($n,'/')[last()])}" dataURL=""/>

(:
let $comments := for $n in $distinct-nodes
return <Comment dataURL=""  id="{$n}" name="{normalize-space(tokenize($n,'/')[last()])}"><![CDATA[{normalize-space(tokenize($n,'/')[last()])}]]</Comment>
:)
let $comments := for $n in $spotlight-nodes
return <Comment dataURL=""  id="{$n/subject}" name="{normalize-space(tokenize($n/subject,'/')[last()])}"><![CDATA[{normalize-space(tokenize($n/object,'/')[last()])}]]></Comment>


let $topNode := <Comment id="TopNode" name="Top Node" dataURL=""><![CDATA[The Top Node links nodes that lack a parent.]]></Comment>
let $topNodes := ()
let $topNodes := for $n in distinct-values($distinct-nodes[not(.=$distinct-objects)]) 
return <DirectedRelation fromID="TopNode" toID="{normalize-space($n)}"  labelText="TopLevel" color="0x12CDE4" letterSymbol="TL"/>

let $relations := for $r in $tripleDoc//srch
return <DirectedRelation fromID="{normalize-space($r/subject)}" toID="{normalize-space($r/object)}"  labelText="{normalize-space($r/pred)}"/>
return 
<RelationViewerData>
	<Settings appTitle="Relation browser demo {$uid}" startID="TopNode" defaultRadius="150" maxRadius="180">
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
<Nodes>{($topNode,$nodes,$comments)}</Nodes>
<Relations>{($topNodes,$relations)}</Relations>
</RelationViewerData>

