<?xml version="1.0" encoding="ISO-8859-1" ?>
<xsl:stylesheet version="1.0" xmlns="http://www.w3.org/1999/xhtml" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  
  <xsl:variable name="gpocollection">Federal Register</xsl:variable>
  <xsl:variable name="frnumber" select="FEDREG/NO"/>
  <xsl:variable name="frvolume" select="FEDREG/VOL"/>
  <xsl:variable name="frdate" select="FEDREG/DATE"/> 
  <xsl:variable name="frunitname" select="FEDREG/UNITNAME"/> 
    
  <xsl:template match="/">
      <style type="text/css">
        h4 { float: none !important;}
        th,td {border: 1px solid black;}
		  /* General */	
		  .E-04 {margin-left:3pt;margin-right:3pt;font-weight:bold;}
		  .E-03, .URL {font-style:italic;}
		  .E-52 {font-size:6pt;vertical-align:sub;}
		  .APP {margin-top:12pt;margin-bottom:0pt;font-weight:bolder;font-size:12pt;display:block;width:100%;text-align:center;}
		  .SU, .E-51, .FTREF {font-size:6pt;vertical-align:top;}
		  
			/* Content, Separate Parts in this Issue, Reader Aids Reference*/		
			.AGCY-HD, .PTS-HED, .PTS-HD, .AIDS-HED {margin-top:12pt;margin-bottom:0pt;font-weight:bolder;font-size:12pt;display:block;}
			.CAT-HD {margin-top:4pt;margin-bottom:0pt;font-weight:bolder;font-size:8pt;display:block;}
			.SEE-HED {font-style:italic;}
			.SEE {margin-top:1pt;margin-bottom:0pt;display:block;}
			.SJ {display:block;}			
			.SJDENT {margin-left:10pt;display:block;}
			.SUBSJ {margin-left:20pt;display:block;}			
			.SSJDENT {margin-left:35pt;display:block;}
			.PTS, .AIDS {font-family:sans-serif;font-size:10pt;}
			
			/* GPO Tables */
			.GPOTABLE {margin-top:10pt;margin-bottom:10pt;display:block;border-collapse:collapse;empty-cells:show;
			border-bottom-style:solid;border-top-style:solid;border-width:1px; border-color:black;}
			.GPOTABLE-TTITLE {text-align:center}			
			.CHED {font-size:8pt;padding:5px;font-weight:bold;border-top-style:solid;border-bottom-style:solid;border-width:1px; border-color:black;}
			.ENT {font-size:8pt;padding:5px;}
			.TNOTE {font-size:8pt;padding-left:15px;}
			.TRPRTPAGE, .TDPRTPAGE {width:100%;}

        </style>
        <xsl:apply-templates/>
        <xsl:apply-templates mode="footnotes" />
  </xsl:template>
  
  <!-- Tags being Ignored -->
  <xsl:template match="FTNT | FRDOC | BILCOD | PREAMB | CNTNTS | UNITNAME | INCLUDES | EDITOR | EAR | FRDOCBP | HRULE | FTREF | NOLPAGES | OLPAGES">
  </xsl:template>

  <xsl:template match="PTS | AIDS">
    <hr/>
    <xsl:call-template name="apply-span"/>
  </xsl:template>
     
  <xsl:template match="SIG/FP | SIG/NAME | SIG/TITLE">
    <xsl:call-template name="apply-span"/>
    <p class="P-NMRG" />
  </xsl:template>

  <xsl:template match="GPOTABLE">
    <table>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>      
      </xsl:attribute>
      <xsl:apply-templates/>
    </table>
  </xsl:template>

  <xsl:template match="TTITLE">
    <xsl:choose>
      <xsl:when test="not(node())">
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-span"/>
      </xsl:otherwise>
    </xsl:choose>    
  </xsl:template>
  
  <xsl:template match="ROW">
    <tr>
      <xsl:apply-templates/>
    </tr>
  </xsl:template>
  
  
  <xsl:template match="TNOTE | TDESC | SIGDAT">
    <tr>
      <td>
        <xsl:attribute name="colspan">9999</xsl:attribute>
        <xsl:attribute name="class">
          <xsl:value-of select="name()"/>
        </xsl:attribute>
        <xsl:apply-templates/>
      </td>
    </tr>
  </xsl:template>
  
  <xsl:template match="BOXHD">
    <thead>
      <tr>
        <xsl:for-each select="CHED">
          <th><xsl:value-of select="text()" /></th>
        </xsl:for-each>
        <!-- <xsl:for-each select="CHED[@H=1]">
          <th>
            <xsl:attribute name="colspan">
              FOOBARBAZ
            </xsl:attribute>
            <xsl:value-of select="text()" />
          </th>
        </xsl:for-each> -->
      </tr>
      <!-- <tr>
        <xsl:for-each select="CHED[@H=2]">
          <th><xsl:value-of select="text()" /></th>
        </xsl:for-each>
      </tr> -->
    </thead>
  </xsl:template>
  
  <!-- <xsl:template match="CHED">
    <th>
      <xsl:apply-templates/>
    </th>
  </xsl:template> -->
  
  <xsl:template match="ENT">
    <td>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:if test="@A">
        <xsl:attribute name="colspan">
          <xsl:value-of select="1 + @A" />
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </td>
  </xsl:template>

  <xsl:template match="E">
    <span>
      <xsl:attribute name="class">E-<xsl:value-of select="@T"/></xsl:attribute>  
      <xsl:apply-templates/>	
    </span>
  </xsl:template>
  
  <xsl:template match="GPH/GID">
    <span class="GID">		
      [IMAGE ONLY IN PDF:<xsl:text> </xsl:text><xsl:value-of select="."/>] 
    </span>
  </xsl:template>
   
  <xsl:template match="STARS">
    <span class="STARS">		
      <xsl:text>* * * * *</xsl:text>
    </span>
  </xsl:template>
  
  <xsl:template match="HD[@SOURCE = 'HED']"></xsl:template>
  
  <xsl:template match="HD[@SOURCE = 'HD1']">
    <h3><xsl:apply-templates/></h3>
  </xsl:template>
  
  <xsl:template match="HD[@SOURCE = 'HD2']">
    <h4><xsl:apply-templates/></h4>
  </xsl:template>
  
  <xsl:template match="HD[@SOURCE = 'HD3']">
    <h5><xsl:apply-templates/></h5>
  </xsl:template>
  
  <xsl:template match="HD[@SOURCE = 'HD4']">
    <h6><xsl:apply-templates/></h6>
  </xsl:template>
  
  <xsl:template match="P">
    <p><xsl:apply-templates/></p>
  </xsl:template>
  
  <!-- Default Template Handling -->
  <xsl:template match="*" priority="-10">
    <xsl:choose>
      <xsl:when test="not(node())">
        <!--  DEBUG: Enable to detect empty tags.
        <span>
          [EMPTY-NODE <xsl:value-of select="name()"/>]  
        </span>
        -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="apply-span"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
 
  <xsl:template name="apply-span">
    <span>
      <xsl:attribute name="class">
        <xsl:value-of select="name()"/><xsl:text> </xsl:text><xsl:value-of select="name(parent::*)"/>-<xsl:value-of select="name()"/>
      </xsl:attribute>
      <xsl:apply-templates/>
    </span>	
  </xsl:template>
  
  <xsl:template match="SU[count(ancestor::GPOTABLE) > 0]">
    <sup>
      <xsl:value-of select="text()"/>
    </sup>
  </xsl:template>
  
  <xsl:template match="SU[count(ancestor::GPOTABLE) = 0]">
    <xsl:variable name="number"><xsl:value-of select="text()"/></xsl:variable>
    <sup>
      <a>
        <xsl:attribute name="id">citation-<xsl:value-of select="$number" /></xsl:attribute>
        <xsl:attribute name="href">#footnote-<xsl:value-of select="$number" /></xsl:attribute>
        [<xsl:value-of select="$number"/>]
      </a>
    </sup>
  </xsl:template>
  
  <xsl:template match="SU[count(ancestor::FTNT) > 0]">
    <xsl:variable name="number"><xsl:value-of select="text()"/></xsl:variable>
    <a>
      <xsl:attribute name="id">footnote-<xsl:value-of select="$number" /></xsl:attribute>
      <xsl:attribute name="href">#citation-<xsl:value-of select="$number" /></xsl:attribute>
      <xsl:value-of select="$number"/>
    </a>
    <xsl:text>. </xsl:text>
  </xsl:template>
  
  <xsl:template mode="footnotes" match="FTNT">
    <xsl:apply-templates/>
  </xsl:template>
  
  <xsl:template mode="footnotes" match="*[name(.) != 'FTNT']|text()">
    <xsl:apply-templates mode="footnotes"/>
  </xsl:template>
</xsl:stylesheet>