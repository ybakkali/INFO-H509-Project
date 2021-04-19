declare option saxon:output "indent=yes";

for $proc in /dblp/proceedings
return element proceedings
{
  <proc_title>{data($proc/title)}</proc_title>,
  for $crossref in data($proc/@key), $article in /dblp/*[crossref=$crossref]
  return
    <title>{data($article/title)}</title>
}
