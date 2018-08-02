xquery version "3.0";
(:declare option exist:serialize "method=xhtml media-type=text/html indent=yes";:)
 
(: save-new.xq :)
let $app-collection := '/db/apps/snapsec'
let $data-collection := '/db/datasets/snap/data/triples'
let $uid := doc('/db/apps/snapsec/config/config.xml')//uid/text()
let $pwd := doc('/db/apps/snapsec/config/config.xml')//pwd/text()
 
(: this is where the form "POSTS" documents to this XQuery using the POST method of a submission :)
let $item := request:get-data()
 
(: get the next ID from the next-id.xml file :)
let $id := if(string($item//uid) != '') then string($item//uid) else "U1234567"

let $file := concat(xs:string($id), '.xml')

(: this logs you into the collection :)
(:let $login := xmldb:login($app-collection,'admin','sasadm1n'):)

(: this creates the new file with a still-empty id element :)

let $store := try { 
    system:as-user($uid, $pwd, xmldb:store($data-collection, $file, $item))
} catch * {$err:code , $err:description, $err:value}

let $table := for $i in $item//srch
        return
         <triple><s>{$i/subject}</s><pred>{$i/pred}</pred><obj>{$i/object}</obj></triple>

return
<p>
<p>Save Result: {$store}</p>
<triples>
{$table}
</triples>
<store_response>{$store}</store_response>
</p>