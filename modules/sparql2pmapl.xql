xquery version "3.0";
import module namespace http="http://expath.org/ns/http-client";
declare namespace s="http://www.w3.org/2005/sparql-results#";
declare variable $service := "http://localhost:3030/ds/sparql";

(:let $pred := request:get-parameter('pred','<http://example/update-base/#part_of>'):)
let $pred := 'http://example/update-base/#part_of'
(:let $query := concat(" PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>  PREFIX yoc: <http://example/update-base/#> select  ?from ?to ?label  where  {  ?from ", concat('<',$pred,'>')  , "  ?to . ?from ?label ?to . } ")
:)

let $query := " PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>  PREFIX yoc: <http://example/update-base/#> select  ?from ?to ?label  where  {  ?from ?label ?to .  filter not exists { VALUES ?q {(rdfs:label)} ?from ?q ?y .}   } "

let $sparql := concat($service,"?output=xml&amp;query=",encode-for-uri($query) )
let $request := <http:request href="{$sparql}" method="GET"/>
let $result :=  http:send-request($request)
let $topNodeID := util:uuid()
(:let $serialize := util:declare-option("exist:serialize","method=text media-type=text/text"):)
let $node2GUID := for $n in distinct-values(($result[2]//s:binding[@name='from']/s:uri, $result[2]//s:binding[@name='to']/s:uri))
return <Node guid="{util:uuid()}">{$n}</Node>
let $nodes := for $n in distinct-values(($result[2]//s:binding[@name='from']/s:uri, $result[2]//s:binding[@name='to']/s:uri))
return  <Node id="{concat('{',$node2GUID[.=$n]/@guid,'}')}" Display="{normalize-space(tokenize($n,'/')[last()])}"  Order="0" FontFamily="Calibri" FontSize="12" FontBold="false" FontItalic="false" FontStrikeOut="false" BorderStyle="Solid" BorderWidth="2" FontColor="FF000000" Marker="B1C6D9F0" />
let $topNode := <Node id="{concat('{',$topNodeID,'}')}" Display="Top Node" Order="0" FontFamily="Calibri" FontSize="14" FontBold="false" FontItalic="false" FontStrikeOut="false" BorderStyle="Solid" BorderWidth="2" FontColor="FF000000" Marker="FFC6D9F0" />
let $topNodes := for $n in distinct-values(($result[2]//s:binding[@name='from']/s:uri, $result[2]//s:binding[@name='to']/s:uri))
where empty($result[2]//s:result/s:binding[@name='to'][s:uri=$n])
return <DirectedRelation fromID="TopNode" toID="{normalize-space($n)}"  labelText="TopLevel" color="0x12CDE4" letterSymbol="TL"/>

let $relations := for $r in $result[2]//s:result
return <Reference Source="{concat('#/{', $node2GUID[.=normalize-space($r/s:binding[@name='from'])]/@guid, '}')}"  Target="{concat('#/{',$node2GUID[.=normalize-space($r/s:binding[@name='to'])]/@guid, '}')}"  to="{normalize-space($r/s:binding[@name='to'])}" Type="{normalize-space(tokenize($r/s:binding[@name='label'],'/')[last()])}" BiDir="false"  Hidden="false" RefRelativeX1="0" RefRelativeY1="0" RefRelativeX2="0" RefRelativeY2="0"/>

return 
<PocketMindMap Version="1.2" GUID="{concat('{',util:uuid(),'}')}" Creation="2013-09-19" StartmapID="PM0" Author="" Modified="2013-09-19" LastModifiedBy="" Revision="1">
    <ReferenceTypes>
        <ReferenceType Name="is key part" Color="FF548DD4" PenStyle="0" PenWidth="2" BiDir="true"
            Hidden="false" transitive="false"/>
        <ReferenceType Name="Requires" Color="FF548DD4" PenStyle="0" PenWidth="2" BiDir="true"
            Hidden="false" transitive="false"/>
    </ReferenceTypes>
    <References>{($relations)}</References>
    <Maps>
        <Map id="PM0" Name="test for export" Creation="2013-09-19" Modified="2013-09-19">
        <Nodes>
            {$topNode}
                    <Nodes>
                        {$nodes}
                    </Nodes>
            </Nodes>
            <Background Color="FFFFFFFF"/>
        </Map>
    </Maps>
    {$node2GUID}
</PocketMindMap>



(:<PocketMindMap Version="1.2" GUID="{63DB166A-EE07-40A7-A7C7-E4FA99EC29F3}" Creation="2013-09-19"
    StartmapID="PM0" Author="" Modified="2013-09-19" LastModifiedBy="" Revision="1">
    <ReferenceTypes>
        <ReferenceType Name="is key part" Color="FF548DD4" PenStyle="0" PenWidth="2" BiDir="true"
            Hidden="false" transitive="false"/>
        <ReferenceType Name="Requires" Color="FF548DD4" PenStyle="0" PenWidth="2" BiDir="true"
            Hidden="false" transitive="false"/>
    </ReferenceTypes>
    <References>
        <Reference Source="#/{A96BEC0C-7602-4616-AE83-DEF5B1ACE58E}"
            Target="#/{83D5E88F-E35B-4621-88F1-57C3B03ACA7D}" Type="is key part" BiDir="true"
            Hidden="false" RefRelativeX1="0" RefRelativeY1="0" RefRelativeX2="0" RefRelativeY2="0"/>
        <Reference Source="#/{A96BEC0C-7602-4616-AE83-DEF5B1ACE58E}"
            Target="#/{A036BFEB-2EAC-4C33-ADD2-7629FEE8F64D}" Type="Requires" BiDir="true"
            Hidden="false" RefRelativeX1="0" RefRelativeY1="0" RefRelativeX2="0" RefRelativeY2="0"/>
    </References>
    <Maps>
        <Map id="PM0" Name="test for export" Creation="2013-09-19" Modified="2013-09-19">
            <Nodes>
                <Node id="{A96BEC0C-7602-4616-AE83-DEF5B1ACE58E}" Display="test for export"
                    Order="0" FontFamily="Calibri" FontSize="14" FontBold="false" FontItalic="false"
                    FontStrikeOut="false" BorderStyle="Solid" BorderWidth="2" FontColor="FF000000"
                    Marker="FFC6D9F0">
                    <Nodes>
                        <Node id="{83D5E88F-E35B-4621-88F1-57C3B03ACA7D}" Display="thing a"
                            Order="0" FontFamily="Calibri" FontSize="12" FontBold="false"
                            FontItalic="false" FontStrikeOut="false" BorderStyle="Solid"
                            BorderWidth="2" FontColor="FF000000" Marker="B1C6D9F0"/>
                        <Node id="{A036BFEB-2EAC-4C33-ADD2-7629FEE8F64D}" Display="thing b"
                            Order="1" FontFamily="Calibri" FontSize="12" FontBold="false"
                            FontItalic="false" FontStrikeOut="false" BorderStyle="Solid"
                            BorderWidth="2" FontColor="FF000000" Marker="B1C6D9F0"/>
                    </Nodes>
                </Node>
            </Nodes>
            <Background Color="FFFFFFFF"/>
        </Map>
    </Maps>
</PocketMindMap>
:)

