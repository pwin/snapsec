xquery version "1.0";

(:declare namespace output = "http://www.w3.org/2010/xslt-xquery-serialization";
declare option output:method "html";
declare option output:media-type "text/html";
declare option output:omit-xml-declaration "yes";:)

declare option exist:serialize "method=html media-type=text/html omit-xml-declaration=yes";
let $out := 

<html>
<head>
<meta http-equiv="Expires" Content="-1" />
<meta http-equiv="Pragma" content="no-cache" />
<title>Snap Relation Browser</title>

</head>
<body bgcolor="#eefffd" >


<div id="movie" style="text-align:center;"/>
<!--text used in the movie-->
<object width="400" height="400"
 classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
 codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=8,0,0,0">
 <param name="SRC" value="RelationBrowser.swf"></param>
 <embed src="RelationBrowser.swf?dataSource=xmlTriples2relationBrowser.xql" width="400" height="400">
 </embed>
 </object> 
 
</body>
</html>

return $out