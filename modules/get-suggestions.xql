xquery version "3.0";
declare namespace exist="http://exist.sourceforge.net/NS/exist";
declare option exist:serialize "method=xml media-type=text/xml indent=yes";
let $collection-path := '/db/datasets/snap/data/triples'
let $search-str := request:get-parameter('search', '')
return
<suggestions>{
      let $termColl :=  for $term in (collection($collection-path))//srch[contains(normalize-space(lower-case(subject)),lower-case($search-str)) or contains(normalize-space(lower-case(object)),lower-case($search-str))] 
       return    ($term/subject[contains(normalize-space(lower-case(.)),lower-case($search-str))] , $term/object[contains(normalize-space(lower-case(.)),lower-case($search-str))] )[1]/text()
       for $i in distinct-values($termColl)
       return <s>{$i}</s>
}</suggestions>