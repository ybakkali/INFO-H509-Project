declare option saxon:output "indent=yes";
declare variable $root := .;

declare function local:print($author as xs:string,
                             $authors as xs:string*,
                             $distance as xs:integer)
{
  for $coauthor in $authors
  return <distance author1="{$author}" author2="{$coauthor}" distance="{$distance}"/>
};

declare function local:explore($author as xs:string,
                               $authors as xs:string*,
                               $checked_authors as xs:string*,
                               $distance as xs:integer)
{
  let $coauthors := distinct-values($root//*[author=$authors]/author[not(.=($authors,$checked_authors, $author))])
  return
    if (not(empty($coauthors))) then (
      local:print($author, $coauthors, $distance),
      local:explore($author, $coauthors, ($coauthors, $checked_authors), $distance+1)
    ) else (
      local:print($author, $coauthors, $distance)
    )
};

<distances>
{
  for $author in distinct-values(//author)
  return local:explore($author, ($author), (), 1)
}
</distances>
