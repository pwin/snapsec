xquery version "3.0";
declare option exist:serialize "method=xhtml media-type=text/xml indent=yes process-xsl-pi=no";
import module namespace request="http://exist-db.org/xquery/request";
import module namespace session="http://exist-db.org/xquery/session";
import module namespace util="http://exist-db.org/xquery/util";
let $attribute := request:set-attribute("betterform.filter.ignoreResponseBody", "true")
let $version := "2013-12-09"


let $form :=
<html xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xf="http://www.w3.org/2002/xforms" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:ev="http://www.w3.org/2001/xml-events" 
>

   <head>
   <meta http-equiv="cache-control" content="max-age=0" />
   <meta http-equiv="cache-control" content="no-cache" />
   <meta http-equiv="expires" content="0" />
   <meta http-equiv="expires" content="Tue, 01 Jan 1980 1:00:00 GMT" />
   <meta http-equiv="pragma" content="no-cache" />
      <title>Edit Triples</title>
      
         <script type="text/javascript">      <![CDATA[
        // adding a gmail style function to stop the user from moving away from the page..
        function unloadMessage(){message = "This form has not yet been submitted to the database\nAll data will be lost."
         return message;}
        function setBunload(on){window.onbeforeunload = (on) ? unloadMessage : null;}
        setBunload(true);
        function dirty() {
            setBunload(true);
        }
        function clean() {
            setBunload(false);
        }
        ]]>
      </script>
      
      
      
       <style type="text/css">
<![CDATA[
       @namespace xf url("http://www.w3.org/2002/xforms");

        body {
             font-family: Helvetica, Ariel, Verdana, sans-serif;
        }
           
           /* align the labels but not the save label */
            xf|output xf|label, xf|input xf|label, xf|textarea xf|label, xf|select1 xf|label {
                 display: inline-block;
                 width: 30ex;
                 text-align: right;
                 vertical-align: top;
                 margin-right: 1ex;
                 font-weight: bold;
             }

xf|input, xf|select1, xf|textarea, xf|ouptut {
//       display: block;
       margin: 1ex;
  }

.xforms-invalid .xforms-value {background-color: pink; }


.block-form {
  margin-left: 3pt;
  margin-top: 3pt;
  margin-bottom: 3pt;
}

//.block-form span.xforms-control > span {
//  display:inline-block; 
//  white-space:nowrap; 
//}

.block-form label.xforms-label {
   display:inline-block; 
   width:10em;
   font-size: 12px;
   font-color:red;
   text-align:left; 
   margin-right:4px;
}

.block-form span.xforms-input.row,
 span.xforms-select1.row,
 span.xforms-textarea.row,
 span.xforms-secret.row,
 span.xforms-output.row {
    display:block;
    font-size: 12px;
    width:10em;
 }

.block-form-section > div.xforms-group-content {
  padding-bottom: 10px; 
  margin: 2px; 
  width: 15em;
}

.block-form-section .xforms-group-label {
  display: inline-block; 
}

//.wide .xforms-value { 
//  width: 32em;
//}

      div.wholeform
		  {
		  margin:1em; 
		  border: solid thin #603479;
		  width:11cm;
		  height:auto;
		  background-color:white;
		  }


]]>
       </style>
    </head>
    <body>
      <div id="xforms" class="wholeform">
        <div style="display:none">
        <xf:model version="0.1" id="triples">
        <xf:instance id="rdf1">
        <rdf1 xmlns=''/>
        </xf:instance>
        <xf:instance id="rdf2">
        <rdf2 xmlns=''/>
        </xf:instance>
        <xf:instance id="entities">
        <entities xmlns=''/>
        </xf:instance>
        <xf:instance id="preds">
        <preds xmlns=''/>
        </xf:instance>        


      <xf:submission id="save" method="post" action="save.xq" instance="instance('rdf1')" replace="all">
      <xf:message level="modeless" ev:event="xforms-submit-error">Submit Error</xf:message>
      <xf:toggle case="save-done" ev:event="xforms-submit-done"/>
      </xf:submission>
   
    </xf:model>
</div>

 <center><h2>RDF Editor</h2> [v. {$version}]</center>
 <div>
    <div class="block-form">
    <xf:repeat nodeset="instance('rdf1')">
      <div class="block-form">
        <div class="block-form-section" style="background-color: lightblue;">
      <xf:repeat nodeset="instance('rdf1')//triple" id="repeatTriple">
      <div>
        <span><xf:input ref="subject" incremental="true"><xf:label>S</xf:label></xf:input></span>
        <span><xf:input ref="PoliceForce" incremental="true"><xf:label>P</xf:label></xf:input></span>
        <span><xf:input ref="AccidentReference" incremental="true"><xf:label>O</xf:label></xf:input></span>
        </div>     
        <xf:trigger>
          <xf:label>del Triple</xf:label>
          <xf:delete nodeset="." at="1" ev:event="DOMActivate" if="count(instance('rdf1')//triple) &gt; 1"/>
        </xf:trigger>
        </div>
      <br/>
      <xf:group id="insertElementButtons" appearance="bf:horizontalTable">
      <xf:label>Add Element Buttons</xf:label>
      <xf:trigger id="insertRDFbutton">
        <xf:label>+ RDF</xf:label>
        <xf:insert nodeset="//triple" at="index('repeatTriple')" position="after" ev:event="DOMActivate"/>
      </xf:trigger>
    </xf:group>
    </xf:repeat>
</div>
           
   <hr/>
   <hr/>
   <hr/>
<div style="align:right;">
        <xf:submit submission="save" appearance="full">
            <xf:label>Save Record</xf:label>
        </xf:submit> 
</div>

                
            <xf:switch>
           <xf:case id="save-done" resource="javascript:clean();"/>
           </xf:switch>
 
       <!-- </xf:group> -->
        </div>
        </div>

    </body>
</html>

let $xslt-pi := processing-instruction xml-stylesheet {'type="text/xsl" href="/exist/xsltforms/xsltforms.xsl"'}
let $xslt-debug := processing-instruction xsltforms-options  {'debug="no"'}            
return ($xslt-pi, $xslt-debug, $form)

