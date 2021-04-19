declare option saxon:output "indent=yes";

<authors_coauthors>
{
  for $author in distinct-values(//author)
  return element author
  {
    <name>{$author}</name>,
    let $coauthors := distinct-values(//*[author=$author]/author[not(.=$author)])
    return element coauthors
    {
      attribute number {count($coauthors)},
      for $coauthor in $coauthors
      return element coauthor
      {
        <name>{$coauthor}</name>,
        <nb_joint_pubs>{count(//*[author=$coauthor]/author[.=$author])}</nb_joint_pubs>
      }
    }
  }
}
</authors_coauthors>
