# INFO-H509-Project

Assignment 2:
command lines:
- run: java -jar xslt-tool.jar generate-author-pages.xslt dblp-exceprt.xml output


Assignment 3: 
command lines:
- run: java -cp saxon9he.jar net.sf.saxon.Query -s:"dblp-exceprt.xml" -q:"query2.xq" -o:"out_temp.xml"
- format: xmllint --format out_temp.xml   
