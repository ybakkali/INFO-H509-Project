<all_proceedings>
  {
    for $proc in /dblp/proceedings
    let $crossrefs := string($proc/@key)
    return
      <proceedings>
        <proc_title>{$proc/title/text()}</proc_title>
        {
          for $crossref in $crossrefs
          let $articles := /dblp/*[crossref=$crossref]
          for $article in $articles
          return
            <title>{$article/title/text()}</title>
        }
      </proceedings>
  }
</all_proceedings>
