<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:f="dblp">

	<xsl:function name="f:removeIllegalCharacters">
		<xsl:param name="s"/>
		<xsl:value-of select="replace($s, '[&#x007F;-&#x009F;]', '=')"/>
	</xsl:function>

	<xsl:function name="f:getLastname">
		<xsl:param name="fullname"/>
		<xsl:value-of select="substring-after($fullname, ' ')"/>
	</xsl:function>

	<xsl:function name="f:getFirstname">
		<xsl:param name="fullname"/>
		<xsl:value-of select="substring-before($fullname, ' ')"/>
	</xsl:function>

	<xsl:function name="f:getFirstLetterOfLastname">
		<xsl:param name="lastname"/>
		<xsl:value-of select="lower-case(substring($lastname,1,1))"/>
	</xsl:function>

	<xsl:function name="f:getPath">
		<xsl:param name="fullname"/>
		<xsl:variable name="lastname" select="f:getLastname($fullname)"/>
		<xsl:variable name="firstname" select="f:getFirstname($fullname)"/>
		<xsl:variable name="flol" select="lower-case(substring($lastname,1,1))"/>
		<xsl:value-of select="concat('/', $flol, '/', replace($lastname, ' ', '_'), '.', replace($firstname, ' ', '_'), '.html')"/>
	</xsl:function>


	<xsl:template match="/">
		<html>
			<head><title>DBLP index</title></head>
			<body>
				<h1>Authors and editors</h1>
				<xsl:variable name="publications" select="/dblp/*"/>

				<xsl:for-each select="distinct-values(/dblp/*/(author | editor))">
					<xsl:sort select="f:removeIllegalCharacters(.)"/>
					<xsl:variable name="originalFullname" select="."/>
					<xsl:variable name="fullname" select="f:removeIllegalCharacters(.)"/>

					<h3><a href="{concat('dblp', f:getPath($fullname))}"><xsl:value-of select="$fullname"/></a></h3>
					<xsl:variable name="current_publications" select="$publications[(author | editor)=$originalFullname]"/>
					
					<xsl:call-template name="construct_author_page">
						<xsl:with-param name="author" select="$originalFullname"/>
						<xsl:with-param name="unsorted_author_publications" select="$current_publications"/>
					</xsl:call-template>

				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

	<xsl:template name="construct_author_page" >
		<xsl:param name="author"/>
		<xsl:param name="unsorted_author_publications"/>

		<xsl:variable name="fullname" select="f:removeIllegalCharacters($author)"/>
		<xsl:result-document href="{concat('dblp', f:getPath($fullname))}" version="1.0" encoding="UTF-8" method="html" indent="yes">
		
		<xsl:variable name="author_publications" as="element()+">
			<xsl:perform-sort select="$unsorted_author_publications">
				<xsl:sort select="year" data-type="number" order="descending"/>
				<xsl:sort select="title" order="ascending"/>
			</xsl:perform-sort>
		</xsl:variable>

			<html>
				<head>
					<title>
						<xsl:value-of select="$fullname"/>
					</title>
				</head>
				<body>
					<h1>
						<xsl:value-of select="$fullname"/>
					</h1>

					<xsl:call-template name="construct_table">
						<xsl:with-param name="author" select="$author"/>
						<xsl:with-param name="author_publications" select="$author_publications"/>
					</xsl:call-template>

					<xsl:call-template name="construct_index">
						<xsl:with-param name="author" select="$author"/>
						<xsl:with-param name="author_publications" select="$author_publications"/>
					</xsl:call-template>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

	<xsl:template name="construct_table" >
		<xsl:param name="author"/>
		<xsl:param name="author_publications"/>
		<p>
			<table border="1">
				<xsl:for-each select="$author_publications">
					<xsl:variable name="pos" select="last()-position()+1"/>
					
					<xsl:if test="not(preceding-sibling::*[1]/year=./year) or position()=1">
						<tr><th colspan="3" bgcolor="#FFFFCC"><xsl:value-of select="year"/></th></tr>
					</xsl:if>

					<tr>
						<td align="right" valign="top"><a name="p{$pos}"/><xsl:value-of select="$pos"/></td>
						<td valign="top" width="16">
							<xsl:if test="ee">
								<a href="{ee}">
									<img alt="Electronic Edition" title="Electronic Edition" src="http://www.informatik.uni-trier.de/~ley/db/ee.gif" border="0" height="16" width="16"/>
								</a>
							</xsl:if>
						</td>
						<td>
							<xsl:for-each select="author | editor">
								<xsl:variable name="tempAuthor" select="f:removeIllegalCharacters(.)"/>
								<a href="{concat('..', f:getPath($tempAuthor))}">
									<xsl:value-of select="$tempAuthor"/>
								</a>,
							</xsl:for-each>

							<xsl:value-of select="title"/>

							<xsl:if test="booktitle">
							, <xsl:value-of select="booktitle"/>
							</xsl:if>

							<xsl:if test="pages">
							, <xsl:value-of select="pages"/>
							</xsl:if>

							<xsl:if test="year">
							, <xsl:value-of select="year"/>
							</xsl:if>

							<xsl:if test="address">
							, <xsl:value-of select="address"/>
							</xsl:if>

							<xsl:if test="journal">
							, <xsl:value-of select="journal"/>
							</xsl:if>

							<xsl:if test="volume">
							, <xsl:value-of select="volume"/>
							</xsl:if>

							<xsl:if test="number">
							, <xsl:value-of select="number"/>
							</xsl:if>

							<xsl:if test="month">
							, <xsl:value-of select="month"/>
							</xsl:if>

							<xsl:if test="publisher">
							, <xsl:value-of select="publisher"/>
							</xsl:if>

							<xsl:if test="note">
							, <xsl:value-of select="note"/>
							</xsl:if>

							<xsl:if test="isbn">
							, ISBN <xsl:value-of select="isbn"/>
							</xsl:if>

							<xsl:if test="series">
							, <xsl:value-of select="series"/>
							</xsl:if>

							<xsl:if test="school">
							, <xsl:value-of select="school"/>
							</xsl:if>

							<xsl:if test="chapter">
							, <xsl:value-of select="chapter"/>
							</xsl:if>
						</td>
					</tr>
				</xsl:for-each>
			</table>
		</p>
	</xsl:template>

	<xsl:template name="construct_index" >
		<xsl:param name="author"/>
		<xsl:param name="author_publications"/>
		<h2> Co-author index </h2>
			<p>
				<table border="1">
					<xsl:for-each select="distinct-values($author_publications/(author | editor)[not(.=$author)])">
						<xsl:sort select="f:getLastname(f:removeIllegalCharacters(.))"/>
						<xsl:variable name="coAuthor" select="."/>
						<xsl:variable name="coAuthorFullname" select="f:removeIllegalCharacters(.)"/>
						<tr>
							<td align="right">
								<a href="{concat('..', f:getPath($coAuthorFullname))}"><xsl:value-of select="$coAuthorFullname"/></a>
							</td>
							<td align="left">
								<xsl:for-each select="$author_publications">
									<xsl:if test="./editor = $coAuthor or ./author = $coAuthor">
										<xsl:variable name="pos" select="last()-position()+1"/>
										[<a href="#p{$pos}"><xsl:value-of select="$pos"/></a>]
									</xsl:if>
								</xsl:for-each>
							</td>
						</tr>
					</xsl:for-each>
				</table>
			</p>
	</xsl:template>

</xsl:stylesheet>