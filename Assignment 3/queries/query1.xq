<authors_coauthors>
  {
    for $author in distinct-values(/dblp//author)
    let $publications := /dblp/*[author=$author]
    return
    element author
      {
        <name>{$author}</name>,
        let $coauthors := distinct-values(/$publications//author)
        let $number := count(distinct-values(/$publications//author))
        return
        <coauthors number="{$number - 1}">
          {
            for $coauthor in $coauthors
            let $joint := count(/dblp/*[author=$coauthor])
            where $coauthor != $author
            return
            <coauthor>
            <name>{$coauthor}</name>
            <nb_joint_pubs>{$joint}</nb_joint_pubs>
            </coauthor>
          }
        </coauthors>
      }
  }
</authors_coauthors>
