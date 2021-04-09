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
		<html>
			<body>
				<xsl:variable name="publications" select="/dblp/*"/>

				<xsl:for-each select="distinct-values(/dblp/*/(author | editor))">
					<xsl:variable name="originalFullname" select="."/>
					<xsl:variable name="fullname" select="replace(., '[&#x007F;-&#x009F;]', '=')"/>
					<h2><!--TODO-->
						<xsl:value-of select="$fullname"/>
					</h2>
					<xsl:result-document href="{concat('temp', f:getPath($fullname))}" version="1.0" encoding="UTF-8" method="html" indent="yes" omit-xml-declaration="no"><!--TODO HTML-->
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
								<xsl:variable name="currentPublications" select="$publications[(author | editor)=$originalFullname]"/>
								<p>
									<table border="1">
										<xsl:for-each-group select="$currentPublications" group-by="year">
											<xsl:sort select="year"/>
											<tr><th colspan="3" bgcolor="#FFFFCC"><xsl:value-of select=" current-grouping-key()"/></th></tr>
											<xsl:for-each select="current-group()">
												<tr>
													<td align="right" valign="top"><a name="p5"/>5</td><!--TODO-->
													<td valign="top">
														<a href="http://doi.acm.org/10.1145/1878500.1878506">
															<img alt="Electronic Edition" title="Electronic Edition" src="http://www.informatik.uni-trier.de/~ley/db/ee.gif" border="0" height="16" width="16"/>
														</a>
													</td>
													<td>
														<a href="../w/Whiteneck:James.html">James Whiteneck</a>, <xsl:value-of select="title"/>
													</td>
												</tr>
											</xsl:for-each>
										</xsl:for-each-group>
									</table>
								</p>
								<h2> Co-author index </h2>
								<p>
									<table border="1">
										<tr>
											<td align="right">
												aha ha
											</td>
											<td align="left">
												just got faded
											</td>
										</tr>
									</table>
								</p>
							</body>
						</html>
					</xsl:result-document>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>

</xsl:stylesheet>