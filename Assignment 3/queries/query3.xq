declare option saxon:output "indent=yes";
declare variable $root := .;

declare function local:print($author as xs:string, $authors as xs:string*, $distance as xs:integer)
{
  for $coauthor in $authors
  return <distance author1="{$author}" author2="{$coauthor}" distance="{$distance}"/>
};

declare function local:getAllCoAuthor($authors as xs:string*, $checked_authors as xs:string*)
{
  let $a := distinct-values($root//*[author=$authors]/author[not(.=$authors) and not(.=$checked_authors)])
  return $a
};

declare function local:explore($author as xs:string, $authors as xs:string*, $distance as xs:integer, $checked_authors as xs:string*)
{
  let $coauthors := local:getAllCoAuthor($authors, ($checked_authors, $author))
  let $checked := ($coauthors, $checked_authors)
  return (
    local:print($author, $coauthors, $distance)
    if (not(empty($coauthors))) then (
      local:explore($author, $coauthors, $distance+1, $checked)
    ) else ()
  )
};

<distances>
{
  for $author in distinct-values(//author)
  return (local:explore($author, ($author), 1, ()))
}
</distances>
