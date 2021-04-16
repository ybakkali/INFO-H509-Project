<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:f="http://www.test.com">

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
		<xsl:result-document href="index.html" version="1.0" encoding="UTF-8" method="html" indent="yes">
			<html>
				<head><title>DBLP index</title></head>
				<body>
					<h1>Authors and editors</h1>
					<xsl:variable name="publications" select="/dblp/*"/>

					<xsl:for-each select="distinct-values(/dblp/*/(author | editor))">
						<xsl:sort select="replace(., '[&#x007F;-&#x009F;]', '=')"/>
						<xsl:variable name="originalFullname" select="."/>
						<xsl:variable name="fullname" select="replace(., '[&#x007F;-&#x009F;]', '=')"/>

						<h3><a href="{concat('dblp', f:getPath($fullname))}"><xsl:value-of select="$fullname"/></a></h3>

						<xsl:result-document href="{concat('dblp', f:getPath($fullname))}" version="1.0" encoding="UTF-8" method="html" indent="yes">
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
									<xsl:variable name="currentPublications" as="element()+">
										<xsl:perform-sort select="$publications[(author | editor)=$originalFullname]">
											<xsl:sort select="year" data-type="number" order="descending"/>
											<xsl:sort select="title" order="ascending"/>
										</xsl:perform-sort>
									</xsl:variable>

									<p>
										<table border="1">
											<xsl:for-each select="$currentPublications">
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
														<a href="../w/Whiteneck:James.html">James Whiteneck</a>, <xsl:value-of select="title"/>
													</td>
												</tr>
											</xsl:for-each>
										</table>
									</p>
									<h2> Co-author index </h2>
									<p>
										<table border="1">
											<xsl:for-each select="distinct-values($currentPublications/(author | editor)[not(.=$originalFullname)])">
												<xsl:sort select="f:getLastname(replace(., '[&#x007F;-&#x009F;]', '='))"/>
												<xsl:variable name="coAuthor" select="."/>
												<xsl:variable name="coAuthorFullname" select="replace(., '[&#x007F;-&#x009F;]', '=')"/>
												<tr>
													<td align="right">
														<a href="{concat('..', f:getPath($coAuthorFullname))}"><xsl:value-of select="$coAuthorFullname"/></a>
													</td>
													<td align="left">
														<xsl:for-each select="$currentPublications">
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
								</body>
							</html>
						</xsl:result-document>
					</xsl:for-each>
				</body>
			</html>
		</xsl:result-document>
	</xsl:template>

</xsl:stylesheet>