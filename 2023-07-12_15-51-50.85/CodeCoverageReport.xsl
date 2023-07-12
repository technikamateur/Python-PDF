<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html" doctype-public="XSLT-compat" omit-xml-declaration="yes" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>Trace Code Coverage Report from <xsl:value-of select="/Header/Name"/></title>
				<meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
				<STYLE TYPE="text/css">
    body   { text-align:left; font-size: 8pt; color: #000000; font-family: Arial; }
    p      { font-size: 9pt; color: #000000; font-family: Arial; }
    h1     { font-size: 18pt; color: #000000; font-weight: bold; font-family: Arial; }
    h2     { font-size: 14pt; color: #000000; font-weight: bold; font-family: Arial; }
    h3     { font-size: 12pt; color: #000000; font-weight: bold; font-family: Arial; }
    h4     { font-size: 10pt; color: #000000; font-weight: bold; font-family: Arial; }
    h5     { font-size: 10pt; color: #000000; font-weight: bold; font-family: Arial; }
    h6     { font-size: 10pt; color: #000000; font-weight: bold; font-family: Arial; }
    li     { font-size: 9pt; color: #000000; font-family: Arial; }
    ul     { font-size: 9pt; color: #000000; font-family: Arial; }
    ol     { font-size: 9pt; color: #000000; font-family: Arial; }
    td     { font-size: 9pt; color: #000000; font-family: Arial; }
    th     { font-size: 10pt; color: #000000; font-family: Arial; }
    tr     { font-size: 10pt; color: #000000; font-family: Arial; }
    b      { font-weight: bold }
    code   { font-size: 6pt; color: #000000; font-family: Courier; }
    small  { font-size: 8pt; color: #000000; font-family: Arial; }
    center { color: #000000; font-family: Arial; }
    @page  { size:portrait; margin-top:1cm;margin-bottom:1cm;margin-left:3cm;margin-left:2cm; }
    .code   { white-space: pre; font-size: 6pt; color: #000000; font-family: Courier; }
    .coverage100 { background-color: #008000; }
    .coverage50 { background-color: #FFFF00; }
    .coverageerror { background-color: #FF0000; }
    .comment   { font-size: 8pt; background-color: #FFF0E0; color: #000000; font-family: Arial; }
    td.comment { position: relative; top:0; left:0; }
    textarea {
      width: 100%;
      height: 100%;
      -webkit-box-sizing: border-box;
         -moz-box-sizing: border-box;
              box-sizing: border-box;
      overflow: auto;
      resize: none;
      position: absolute; top: 0; left: 0;
      border: 1 solid blue; 
    }
    .debuginfo {
      background-color: #B3FFB3;
      font-family: Courier New, Sans;
      display:none;
    }
          </STYLE>
			</head>
			<!-- This calls the HTMLReportView callback to open its own context menu.
           The 'return false' prevents opening of the browsers context menu.
      -->
			<body oncontextmenu="javascript:window.external.show_contextmenu(); return false;">
				<DIV ALIGN="CENTER" STYLE="background:darkblue;">
					<h2><font color="white">Universal Debug Engine Code Coverage Report</font></h2>
				</DIV>
				<table border="1" width="80%" id="table1">
					<tr>
						<td width="8%"><strong>UDE version</strong></td>
						<td width="12%"><strong>Last modified</strong></td>
						<td width="12%"><strong>Storage identifier</strong></td>
						<td width="48%"><strong>Comment</strong></td>
					</tr>
					<tr>
						<td><xsl:value-of select="/stg/Header/Version"/></td>
						<td><xsl:value-of select="/stg/Header/Date"/></td>
						<td><xsl:value-of select="/stg/Header/Identifier"/></td>
						<td><xsl:value-of select="/stg/Header/Comment"/></td>
					</tr>
				</table>
				<h3><u>UDE Storage Source contains following Coverage Data Sets:</u></h3>
				<table border="1" width="80%" id="table3">
					<tr>
						<td width="10%"><b>Creation date</b></td>
						<td width="10%"><b>Coverage mode</b></td>
						<td width="37%"><b>Program</b></td>
						<td width="7%"><b>Start time</b></td>
						<td width="7%"><b>Stop time</b></td>
						<td width="7%"><b>Controller</b></td>
					</tr>
					<xsl:for-each select="/stg/UDE_CodeCoverage_Data_Set_Collection/CodeCoverage_Data_Set">
						<xsl:variable name="blockID">CodeCoverageDataSet_<xsl:value-of select="position()"/></xsl:variable>
						<tr>
							<td><a href="#{$blockID}"><xsl:value-of select="Data_Set_Creation_Time"/></a></td>
							<td><xsl:value-of select="Coverage_Mode"/></td>
							<td><xsl:value-of select="Running_Program"/></td>
							<td><xsl:value-of select="Trace_Start_Time"/></td>
							<td><xsl:value-of select="Trace_Stop_Time"/></td>
							<td><xsl:value-of select="Target_Controller"/></td>
						</tr>
					</xsl:for-each>
				</table>
				<xsl:for-each select="/stg/UDE_CodeCoverage_Data_Set_Collection/CodeCoverage_Data_Set">
					<xsl:variable name="blockID">CodeCoverageDataSet_<xsl:value-of select="position()"/></xsl:variable>
					<xsl:variable name="coverage_mode"><xsl:value-of select="Coverage_Mode"/></xsl:variable>
					<xsl:variable name="coverage_submode"><xsl:value-of select="Coverage_SubMode"/></xsl:variable>
					<xsl:variable name="include_sources"><xsl:value-of select="Include_Sources"/></xsl:variable>
					<xsl:variable name="assembly_mode">
						<xsl:if test="$coverage_mode = 'Statement Coverage Mode' or ($coverage_mode = 'Branch Coverage Mode' and $coverage_submode = 'Calculate branch coverage from machine code (MCB coverage)')">On</xsl:if>
						<xsl:if test="not($coverage_mode = 'Statement Coverage Mode' or ($coverage_mode = 'Branch Coverage Mode' and $coverage_submode = 'Calculate branch coverage from machine code (MCB coverage)'))">Off</xsl:if>
					</xsl:variable>
					<DIV style="page-break-before:always;background:blue;&gt;" ALIGN="CENTER">
						<h2><a name="{$blockID}"><font color="white">Code Coverage Report of Trace Coverage Data Set from <xsl:value-of select="Data_Set_Creation_Time"/>
								</font></a></h2>
					</DIV>
					<table border="1" width="80%" id="table1">
						<tr>
							<td width="10%"><strong>Executed program</strong></td>
							<td width="80%"><xsl:value-of select="Running_Program"/></td>
						</tr>
						<xsl:if test="$coverage_submode != ''">
							<tr>
								<td width="10%"><strong>Coverage Sub Mode</strong></td>
								<td width="80%"><xsl:value-of select="Coverage_SubMode"/></td>
							</tr>
						</xsl:if>
					</table>
					<p></p>
					<table border="1" width="80%" id="table2">
						<tr>
							<td width="20%"><strong>Start time</strong></td>
							<td width="20%"><strong>Stop time</strong></td>
							<td width="20%"><strong>Controller</strong></td>
							<td width="20%"><strong>Number of covered ranges</strong></td>
						</tr>
						<tr>
							<td><xsl:value-of select="Trace_Start_Time"/></td>
							<td><xsl:value-of select="Trace_Stop_Time"/></td>
							<td><xsl:value-of select="Target_Controller"/></td>
							<td><xsl:value-of select="Coverage_Range_Count"/></td>
						</tr>
					</table>
					<h3>Coverage overview about function ranges:</h3>
					<table style="empty-cells:show" border="1" width="80%" id="table3">
						<tr>
							<td width="30%"><strong>Range or function name</strong></td>
							<td width="30%"><strong>Source name</strong></td>
							<xsl:choose>
								<xsl:when test="$coverage_mode = 'Branch Coverage Mode'">
									<td width="10%"><strong>Statement coverage in %</strong></td>
									<td width="10%"><strong>MCB coverage in %</strong></td>
									<td width="10%"><strong>Remarks</strong></td>
								</xsl:when>
								<xsl:otherwise>
									<td width="10%"><strong>Totale coverage in %</strong></td>
								</xsl:otherwise>
							</xsl:choose>
						</tr>
						<xsl:for-each select="Function">
							<xsl:variable name="blockID1"><xsl:value-of select="$blockID"/>_CoverageRange_<xsl:value-of select="position()"/></xsl:variable>
							<xsl:variable name="TotalCoverage"><xsl:value-of select="TotalCoverage_Percent"/></xsl:variable>
							<xsl:variable name="TotalBranchCoverage"><xsl:value-of select="TotalBranchCoverage_Percent"/></xsl:variable>
							<tr>
								<td><a href="#{$blockID1}"><xsl:value-of select="Name"/></a></td>
								<td><xsl:value-of select="SourceName"/></td>
								<xsl:choose>
									<xsl:when test="$TotalCoverage = '100'">
										<td class="coverage100"><xsl:value-of select="$TotalCoverage"/></td>
									</xsl:when>
									<xsl:when test="$TotalCoverage &gt; '0' and $TotalCoverage &lt; '100'">
										<td class="coverage50"><xsl:value-of select="$TotalCoverage"/></td>
									</xsl:when>
									<xsl:otherwise>
										<td><xsl:value-of select="$TotalCoverage"/></td>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
									<xsl:choose>
										<xsl:when test="$TotalBranchCoverage = '100'">
											<td class="coverage100"><xsl:value-of select="$TotalBranchCoverage"/></td>
										</xsl:when>
										<xsl:when test="$TotalBranchCoverage &gt; '0' and $TotalBranchCoverage &lt; '100'">
											<td class="coverage50"><xsl:value-of select="$TotalBranchCoverage"/></td>
										</xsl:when>
										<xsl:otherwise>
											<td><xsl:value-of select="$TotalBranchCoverage"/></td>
										</xsl:otherwise>
									</xsl:choose>
									<td><xsl:value-of select="BranchCoverage_Warning"/></td>
								</xsl:if>
							</tr>
						</xsl:for-each>
					</table>
					<xsl:for-each select="Function">
						<xsl:variable name="blockID1"><xsl:value-of select="$blockID"/>_CoverageRange_<xsl:value-of select="position()"/></xsl:variable>
						<xsl:variable name="TotalCoverage_Percent"><xsl:value-of select="TotalCoverage_Percent"/></xsl:variable>
						<xsl:variable name="TotalBranchCoverage_Percent"><xsl:value-of select="TotalBranchCoverage_Percent"/></xsl:variable>
						<DIV style="page-break-before:always;background:lightblue;" ALIGN="CENTER">
							<h2><a name="{$blockID1}"><font color="white">Code Coverage Function Range <xsl:value-of select="Name"/></font></a></h2>
						</DIV>
						<table border="1" width="80%" id="table4">
							<tr>
								<td width="15%"><strong>Root source module path</strong></td>
								<td width="65%"><xsl:value-of select="SourceModulePath"/></td>
							</tr>
						</table>
						<p></p>
						<table border="1" width="80%" id="table5">
							<tr>
								<td width="20%"><strong>Root source name</strong></td>
								<td width="10%"><strong>Overall number of source lines</strong></td>
								<td width="15%"><strong>Start address</strong></td>
								<td width="10%"><strong>Length of range</strong></td>
								<xsl:choose>
									<xsl:when test="$coverage_mode = 'Branch Coverage Mode'">
										<td width="10%"><strong>Statement coverage in %</strong></td>
										<td width="10%"><strong>MCB coverage in %</strong></td>
									</xsl:when>
									<xsl:otherwise>
										<td width="10%"><strong>Totale coverage in %</strong></td>
									</xsl:otherwise>
								</xsl:choose>
							</tr>
							<tr>
								<td><xsl:value-of select="SourceName"/></td>
								<td><xsl:value-of select="SourceLines/SourceLineCount"/></td>
								<td><xsl:value-of select="StartAddress"/></td>
								<td><xsl:value-of select="RangeLength"/></td>
								<xsl:choose>
									<xsl:when test="$TotalCoverage_Percent = '100'">
										<td class="coverage100"><xsl:value-of select="$TotalCoverage_Percent"/></td>
									</xsl:when>
									<xsl:when test="$TotalCoverage_Percent &gt; '0' and $TotalCoverage_Percent &lt; '100'">
										<td class="coverage50"><xsl:value-of select="$TotalCoverage_Percent"/></td>
									</xsl:when>
									<xsl:otherwise>
										<td><xsl:value-of select="$TotalCoverage_Percent"/></td>
									</xsl:otherwise>
								</xsl:choose>
								<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
									<xsl:choose>
										<xsl:when test="$TotalBranchCoverage_Percent = '100'">
											<td class="coverage100"><xsl:value-of select="$TotalBranchCoverage_Percent"/></td>
										</xsl:when>
										<xsl:when test="$TotalBranchCoverage_Percent &gt; '0' and $TotalBranchCoverage_Percent &lt; '100'">
											<td class="coverage50"><xsl:value-of select="$TotalBranchCoverage_Percent"/></td>
										</xsl:when>
										<xsl:otherwise>
											<td><xsl:value-of select="$TotalBranchCoverage_Percent"/></td>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:if>
							</tr>
						</table>
						<h3>Overview about included Source Modules:</h3>
						<table border="1" width="90%" id="table10">
							<tr>
								<td width="5%"><strong>Source module index</strong></td>
								<td width="20%"><strong>Source name</strong></td>
								<td width="60%"><strong>Source module path</strong></td>
								<td width="5%"><strong>Number of source lines</strong></td>
							</tr>
							<xsl:for-each select="SourceFiles/SourceModule">
								<tr>
									<td><xsl:value-of select="SourceModuleIndex"/></td>
									<td><xsl:value-of select="SourceModuleName"/></td>
									<td><xsl:value-of select="SourceModulePath"/></td>
									<td><xsl:value-of select="SourceLineCount"/></td>
								</tr>
							</xsl:for-each>
						</table>
						<h3>Coverage Overview about Source Line Ranges:</h3>
						<xsl:choose>
							<xsl:when test="$include_sources = 'Yes'">
								<table border="1" width="100%" id="table6" style="empty-cells:show">
									<tr>
										<td width="5%"><strong>Source module index</strong></td>
										<td width="10%"><strong>Line number</strong></td>
										<td width="10%"><strong>Start address</strong></td>
										<td width="5%"><strong>Range length</strong></td>
										<td width="5%"><strong>Unreached instructions</strong></td>
										<xsl:choose>
											<xsl:when test="$coverage_mode = 'Branch Coverage Mode'">
												<td width="5%"><strong>Partly covered instructions</strong></td>
												<td width="5%"><strong>Statement coverage in %</strong></td>
												<td width="5%"><strong>MCB coverage in %</strong></td>
											</xsl:when>
											<xsl:otherwise>
												<td width="15%"><strong>Coverage in %</strong></td>
											</xsl:otherwise>
										</xsl:choose>
										<td width="40%"><strong>Source Line(s)</strong></td>
										<td width="10%"><strong>Comment</strong></td>
									</tr>
									<xsl:for-each select="SourceLines/Source_Line">
										<xsl:variable name="blockID2"><xsl:value-of select="$blockID1"/>_SourceLine_<xsl:value-of select="position()"/></xsl:variable>
										<xsl:variable name="NoOfCodeRanges"><xsl:value-of select="count(CodeRange)"/></xsl:variable>
										<xsl:variable name="CorrespondingSourceModuleIndex"><xsl:value-of select="SourceModuleIndex"/></xsl:variable>
										<xsl:variable name="LineNo"><xsl:value-of select="LineNumber"/></xsl:variable>
										<xsl:variable name="AssemblyTableLineID"><xsl:value-of select="$blockID1"/>_AssemblyTable_Module_<xsl:value-of select="SourceModuleIndex"/>_Line_<xsl:value-of select="LineNumber"/></xsl:variable>
										<xsl:variable name="SourceTableLineID"><xsl:value-of select="$blockID1"/>_SourceTable_Line_Module_<xsl:value-of select="SourceModuleIndex"/>_<xsl:value-of select="LineNumber"/></xsl:variable>
										<xsl:variable name="UnreachedInstructions"><xsl:value-of select="Unreached_Instructions/Instruction_Count"/></xsl:variable>
										<xsl:variable name="UncompleteCoveredInstructions"><xsl:value-of select="UncompleteCovered_Instructions/Instruction_Count"/></xsl:variable>
										<xsl:variable name="TotalCoverage"><xsl:value-of select="TotalCoverage_Percent"/></xsl:variable>
										<xsl:variable name="TotalBranchCoverage"><xsl:value-of select="TotalBranchCoverage_Percent"/></xsl:variable>
										<xsl:variable name="CurrentSourceLine"><xsl:value-of select="SourceLine"/></xsl:variable>
										<xsl:for-each select="CodeRange">
											<xsl:variable name="CurrentIndex"><xsl:value-of select="position()"/></xsl:variable>
											<xsl:choose>
												<xsl:when test="$CurrentIndex = '1'">
													<tr>
														<xsl:choose>
															<xsl:when test="$assembly_mode = 'On'">
																<td rowspan="{$NoOfCodeRanges}" valign="top"><xsl:value-of select="$CorrespondingSourceModuleIndex"/></td>
																<td rowspan="{$NoOfCodeRanges}" valign="top"><a name="{$SourceTableLineID}" href="#{$AssemblyTableLineID}"><xsl:value-of select="$LineNo"/></a></td>
															</xsl:when>
															<xsl:otherwise>
																<td rowspan="{$NoOfCodeRanges}" valign="top"><xsl:value-of select="$CorrespondingSourceModuleIndex"/></td>
																<td rowspan="{$NoOfCodeRanges}" valign="top"><xsl:value-of select="$LineNo"/></td>
															</xsl:otherwise>
														</xsl:choose>
														<td><xsl:value-of select="StartAddress"/></td>
														<td><xsl:value-of select="RangeLength"/></td>
														<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$UnreachedInstructions"/></td>
														<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
															<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$UncompleteCoveredInstructions"/></td>
														</xsl:if>
														<xsl:choose>
															<xsl:when test="$TotalCoverage = '100'">
																<td class="coverage100" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalCoverage"/></td>
															</xsl:when>
															<xsl:when test="$TotalCoverage &gt; '0' and $TotalCoverage &lt; '100'">
																<td class="coverage50" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalCoverage"/></td>
															</xsl:when>
															<xsl:otherwise>
																<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalCoverage"/></td>
															</xsl:otherwise>
														</xsl:choose>
														<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
															<xsl:choose>
																<xsl:when test="$TotalBranchCoverage = '100'">
																	<td class="coverage100" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:when>
																<xsl:when test="$TotalBranchCoverage &gt; '0' and $TotalBranchCoverage &lt; '100'">
																	<td class="coverage50" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:when>
																<xsl:when test="$TotalBranchCoverage = 'Not available'">
																	<td class="coverageerror" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:when>
																<xsl:otherwise>
																	<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<td rowspan="{$NoOfCodeRanges}" class="code"><xsl:value-of select="$CurrentSourceLine"/></td>
														<td rowspan="{$NoOfCodeRanges}" class="comment">
															<textarea class="comment" onchange="javascript:window.external.set_modified()"></textarea>
														</td>
													</tr>
												</xsl:when>
												<xsl:otherwise>
													<tr>
														<td><xsl:value-of select="StartAddress"/></td>
														<td><xsl:value-of select="RangeLength"/></td>
													</tr>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
								</table>
							</xsl:when>
							<xsl:otherwise>
								<!-- ! Include Sources -->
								<table style="empty-cells:show" border="1" width="60%" id="table6">
									<tr>
										<td width="5%"><strong>Source module index</strong></td>
										<td width="10%"><strong>Line number</strong></td>
										<td width="10%"><strong>Start address</strong></td>
										<td width="5%"><strong>Range length</strong></td>
										<td width="10%"><strong>Unreached instructions</strong></td>
										<xsl:choose>
											<xsl:when test="$coverage_mode = 'Branch Coverage Mode'">
												<td width="10%"><strong>Partly covered instructions</strong></td>
												<td width="10%"><strong>Statement coverage in %</strong></td>
												<td width="10%"><strong>MCB coverage in %</strong></td>
											</xsl:when>
											<xsl:otherwise>
												<td width="10%"><strong>Coverage in %</strong></td>
											</xsl:otherwise>
										</xsl:choose>
										<td width="10%"><strong>Comment</strong></td>
									</tr>
									<xsl:for-each select="SourceLines/Source_Line">
										<xsl:variable name="blockID2"><xsl:value-of select="$blockID1"/>_SourceLine_<xsl:value-of select="position()"/></xsl:variable>
										<xsl:variable name="NoOfCodeRanges"><xsl:value-of select="count(CodeRange)"/></xsl:variable>
										<xsl:variable name="CorrespondingSourceModuleIndex"><xsl:value-of select="SourceModuleIndex"/></xsl:variable>
										<xsl:variable name="LineNo"><xsl:value-of select="LineNumber"/></xsl:variable>
										<xsl:variable name="AssemblyTableLineID"><xsl:value-of select="$blockID1"/>_AssemblyTable_Module_<xsl:value-of select="SourceModuleIndex"/>_Line_<xsl:value-of select="LineNumber"/></xsl:variable>
										<xsl:variable name="SourceTableLineID"><xsl:value-of select="$blockID1"/>_SourceTable_Line_Module_<xsl:value-of select="SourceModuleIndex"/>_<xsl:value-of select="LineNumber"/></xsl:variable>
										<xsl:variable name="UnreachedInstructions"><xsl:value-of select="Unreached_Instructions/Instruction_Count"/></xsl:variable>
										<xsl:variable name="UncompleteCoveredInstructions"><xsl:value-of select="UncompleteCovered_Instructions/Instruction_Count"/></xsl:variable>
										<xsl:variable name="TotalCoverage"><xsl:value-of select="TotalCoverage_Percent"/></xsl:variable>
										<xsl:variable name="TotalBranchCoverage"><xsl:value-of select="TotalBranchCoverage_Percent"/></xsl:variable>
										<xsl:for-each select="CodeRange">
											<xsl:variable name="CurrentIndex"><xsl:value-of select="position()"/></xsl:variable>
											<xsl:choose>
												<xsl:when test="$CurrentIndex = '1'">
													<tr>
														<xsl:choose>
															<xsl:when test="$assembly_mode = 'On'">
																<td rowspan="{$NoOfCodeRanges}" valign="top"><xsl:value-of select="$CorrespondingSourceModuleIndex"/></td>
																<td rowspan="{$NoOfCodeRanges}" valign="top"><a name="{$SourceTableLineID}" href="#{$AssemblyTableLineID}"><xsl:value-of select="$LineNo"/></a></td>
															</xsl:when>
															<xsl:otherwise>
																<td rowspan="{$NoOfCodeRanges}" valign="top"><xsl:value-of select="$CorrespondingSourceModuleIndex"/></td>
																<td rowspan="{$NoOfCodeRanges}" valign="top"><xsl:value-of select="$LineNo"/></td>
															</xsl:otherwise>
														</xsl:choose>
														<td><xsl:value-of select="StartAddress"/></td>
														<td><xsl:value-of select="RangeLength"/></td>
														<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$UnreachedInstructions"/></td>
														<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
															<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$UncompleteCoveredInstructions"/></td>
														</xsl:if>
														<xsl:choose>
															<xsl:when test="$TotalCoverage = '100'">
																<td class="coverage100" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalCoverage"/></td>
															</xsl:when>
															<xsl:when test="$TotalCoverage &gt; '0' and $TotalCoverage &lt; '100'">
																<td class="coverage50" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalCoverage"/></td>
															</xsl:when>
															<xsl:otherwise>
																<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalCoverage"/></td>
															</xsl:otherwise>
														</xsl:choose>
														<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
															<xsl:choose>
																<xsl:when test="$TotalBranchCoverage = '100'">
																	<td class="coverage100" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:when>
																<xsl:when test="$TotalBranchCoverage &gt; '0' and $TotalBranchCoverage &lt; '100'">
																	<td class="coverage50" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:when>
																<xsl:when test="$TotalBranchCoverage = 'Not available'">
																	<td class="coverageerror" rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:when>
																<xsl:otherwise>
																	<td rowspan="{$NoOfCodeRanges}"><xsl:value-of select="$TotalBranchCoverage"/></td>
																</xsl:otherwise>
															</xsl:choose>
														</xsl:if>
														<td rowspan="{$NoOfCodeRanges}" class="comment">
															<textarea class="comment" onchange="javascript:window.external.set_modified()"></textarea>
														</td>
													</tr>
												</xsl:when>
												<xsl:otherwise>
													<tr>
														<td><xsl:value-of select="StartAddress"/></td>
														<td><xsl:value-of select="RangeLength"/></td>
													</tr>
												</xsl:otherwise>
											</xsl:choose>
										</xsl:for-each>
									</xsl:for-each>
								</table>
							</xsl:otherwise>
						</xsl:choose>
						<h3>Uncovered Instructions of Source Lines:</h3>
						<table border="1" width="50%" id="table6">
							<tr>
								<td width="5%"><strong>Source module index</strong></td>
								<td width="10%"><strong>Line number</strong></td>
								<td width="10%"><strong>Start address</strong></td>
								<td width="10%"><strong>Range length</strong></td>
							</tr>
							<xsl:for-each select="SourceLines/Source_Line">
								<xsl:variable name="blockID2"><xsl:value-of select="$blockID1"/>_SourceLine_<xsl:value-of select="position()"/></xsl:variable>
								<xsl:variable name="source_module_index"><xsl:value-of select="SourceModuleIndex"/></xsl:variable>
								<xsl:variable name="source_line_number"><xsl:value-of select="LineNumber"/></xsl:variable>
								<xsl:for-each select="Unreached_Instructions/Instruction">
									<xsl:variable name="blockID3">block<xsl:value-of select="position()"/></xsl:variable>
									<tr>
										<td><xsl:value-of select="$source_module_index"/></td>
										<td><xsl:value-of select="$source_line_number"/></td>
										<td><xsl:value-of select="StartAddress"/></td>
										<td><xsl:value-of select="Length"/></td>
									</tr>
								</xsl:for-each>
							</xsl:for-each>
						</table>
						<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
							<h3>Partly covered Instructions of Source Lines:</h3>
							<table border="1" width="64%" id="table7">
								<tr>
									<td width="5%"><strong>Source module index</strong></td>
									<td width="10%"><strong>Line number</strong></td>
									<td width="10%"><strong>Start address</strong></td>
									<td width="10%"><strong>Range length</strong></td>
									<td width="10%"><strong>Type of Branch</strong></td>
									<td width="11%"><strong>No. of not taken Branches</strong></td>
								</tr>
								<xsl:for-each select="SourceLines/Source_Line">
									<xsl:variable name="blockID2"><xsl:value-of select="$blockID1"/>_SourceLine_<xsl:value-of select="position()"/></xsl:variable>
									<xsl:variable name="source_module_index"><xsl:value-of select="SourceModuleIndex"/></xsl:variable>
									<xsl:variable name="source_line_number"><xsl:value-of select="LineNumber"/></xsl:variable>
									<xsl:for-each select="UncompleteCovered_Instructions/Instruction">
										<xsl:variable name="blockID3">block<xsl:value-of select="position()"/></xsl:variable>
										<tr>
											<td><xsl:value-of select="$source_module_index"/></td>
											<td><xsl:value-of select="$source_line_number"/></td>
											<td><xsl:value-of select="StartAddress"/></td>
											<td><xsl:value-of select="Length"/></td>
											<td><xsl:value-of select="JumpType"/></td>
											<td><xsl:value-of select="UntakeJumpCount"/></td>
										</tr>
									</xsl:for-each>
								</xsl:for-each>
							</table>
							<h3>Not taken Branches of all Instructions of Source Lines:</h3>
							<table border="1" width="50%" id="table8">
								<tr>
									<td width="5%"><strong>Source module index</strong></td>
									<td width="10%"><strong>Line number</strong></td>
									<td width="10%"><strong>Branch address</strong></td>
									<td width="10%"><strong>Destination address</strong></td>
								</tr>
								<xsl:for-each select="SourceLines/Source_Line">
									<xsl:variable name="blockID2"><xsl:value-of select="$blockID1"/>_SourceLine_<xsl:value-of select="position()"/></xsl:variable>
									<xsl:variable name="source_module_index"><xsl:value-of select="SourceModuleIndex"/></xsl:variable>
									<xsl:variable name="source_line_number"><xsl:value-of select="LineNumber"/></xsl:variable>
									<xsl:for-each select="UncompleteCovered_Instructions/Instruction">
										<xsl:variable name="blockID3">block<xsl:value-of select="position()"/></xsl:variable>
										<xsl:variable name="branch_address"><xsl:value-of select="StartAddress"/></xsl:variable>
										<xsl:for-each select="NotTakenBranch">
											<xsl:variable name="blockID4">subblock<xsl:value-of select="position()"/></xsl:variable>
											<tr>
												<td><xsl:value-of select="$source_module_index"/></td>
												<td><xsl:value-of select="$source_line_number"/></td>
												<td><xsl:value-of select="$branch_address"/></td>
												<td><xsl:value-of select="DestinationAddress"/></td>
											</tr>
										</xsl:for-each>
									</xsl:for-each>
								</xsl:for-each>
							</table>
						</xsl:if>
						<xsl:if test="$assembly_mode = 'On'">
							<h3>Complete Listing of disassembled Instructions:</h3>
							<table border="1" width="50%" id="table9">
								<tr>
									<td width="5%"><strong>Source module index</strong></td>
									<td width="10%"><strong>Line number</strong></td>
									<td width="10%"><strong>Start address</strong></td>
									<td width="50%"><strong>Instruction</strong></td>
									<td width="10%"><strong>Statement Coverage</strong></td>
									<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
										<td width="10%"><strong>MCB Coverage</strong></td>
									</xsl:if>
								</tr>
								<xsl:for-each select="SourceLines/Source_Line">
									<xsl:variable name="blockID2"><xsl:value-of select="$blockID1"/>_SourceLine_<xsl:value-of select="position()"/></xsl:variable>
									<xsl:variable name="source_module_index"><xsl:value-of select="SourceModuleIndex"/></xsl:variable>
									<xsl:variable name="source_line_number"><xsl:value-of select="LineNumber"/></xsl:variable>
									<xsl:variable name="AssemblyTableLineID"><xsl:value-of select="$blockID1"/>_AssemblyTable_Module_<xsl:value-of select="SourceModuleIndex"/>_Line_<xsl:value-of select="LineNumber"/></xsl:variable>
									<xsl:variable name="SourceTableLineID"><xsl:value-of select="$blockID1"/>_SourceTable_Module_<xsl:value-of select="SourceModuleIndex"/>_Line_<xsl:value-of select="LineNumber"/></xsl:variable>
									<xsl:variable name="NoOfInstructions"><xsl:value-of select="Instructions/InstructionCount"/></xsl:variable>
									<xsl:for-each select="Instructions/Instruction">
										<xsl:variable name="CurrentIndex"><xsl:value-of select="position()"/></xsl:variable>
										<xsl:variable name="CoverageResult"><xsl:value-of select="Coverage_Percent"/></xsl:variable>
										<xsl:variable name="BranchCoverageResult"><xsl:value-of select="BranchCoverage_Percent"/></xsl:variable>
										<xsl:variable name="blockID3">block<xsl:value-of select="position()"/></xsl:variable>
										<xsl:choose>
											<xsl:when test="$CurrentIndex = '1'">
												<tr>
													<td rowspan="{$NoOfInstructions}" valign="top"><xsl:value-of select="$source_module_index"/></td>
													<td rowspan="{$NoOfInstructions}" valign="top"><a href="#{$SourceTableLineID}" name="{$AssemblyTableLineID}"><xsl:value-of select="$source_line_number"/></a></td>
													<td><xsl:value-of select="StartAddress"/></td>
													<td><xsl:value-of select="Code"/></td>
													<xsl:choose>
														<xsl:when test="$CoverageResult = '100'">
															<td class="coverage100"><xsl:value-of select="Coverage_Percent"/></td>
														</xsl:when>
														<xsl:otherwise>
															<td><xsl:value-of select="Coverage_Percent"/></td>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
														<xsl:choose>
															<xsl:when test="$BranchCoverageResult = '100'">
																<td class="coverage100"><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:when>
															<xsl:when test="$BranchCoverageResult &gt; '0' and $BranchCoverageResult &lt; '100'">
																<td class="coverage50"><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:when>
															<xsl:when test="$BranchCoverageResult = 'Not available'">
																<td class="coverageerror"><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:when>
															<xsl:otherwise>
																<td><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</tr>
											</xsl:when>
											<xsl:otherwise>
												<tr>
													<td><xsl:value-of select="StartAddress"/></td>
													<td><xsl:value-of select="Code"/></td>
													<xsl:choose>
														<xsl:when test="$CoverageResult = '100'">
															<td class="coverage100"><xsl:value-of select="Coverage_Percent"/></td>
														</xsl:when>
														<xsl:otherwise>
															<td><xsl:value-of select="Coverage_Percent"/></td>
														</xsl:otherwise>
													</xsl:choose>
													<xsl:if test="$coverage_mode = 'Branch Coverage Mode'">
														<xsl:choose>
															<xsl:when test="$BranchCoverageResult = '100'">
																<td class="coverage100"><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:when>
															<xsl:when test="$BranchCoverageResult &gt; '0' and $BranchCoverageResult &lt; '100' ">
																<td class="coverage50"><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:when>
															<xsl:when test="$BranchCoverageResult = 'Not available'">
																<td class="coverageerror"><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:when>
															<xsl:otherwise>
																<td><xsl:value-of select="BranchCoverage_Percent"/></td>
															</xsl:otherwise>
														</xsl:choose>
													</xsl:if>
												</tr>
											</xsl:otherwise>
										</xsl:choose>
									</xsl:for-each>
								</xsl:for-each>
							</table>
						</xsl:if>
						<xsl:for-each select="UDEDebug">
							<div class="debuginfo">
								<h3>UDE Debug Information</h3>
								<table border="1" width="100%">
									<tr>
										<th>Address</th>
										<th>Length</th>
										<th>Disassembly</th>
										<th>Type</th>
										<th>Module</th>
										<th>Line</th>
										<th>Source</th>
										<th>Count</th>
										<th>C0</th>
										<th>C1</th>
										<th>FallThrough</th>
										<th>Successors</th>
									</tr>
									<xsl:for-each select="Instruction">
										<tr>
											<td><xsl:value-of select="Address"/></td>
											<td><xsl:value-of select="Length"/></td>
											<td><xsl:value-of select="Disasm"/></td>
											<td><xsl:value-of select="Type"/></td>
											<td><xsl:value-of select="Module"/></td>
											<td><xsl:value-of select="Sourceline"/></td>
											<td><xsl:value-of select="Source"/></td>
											<td><xsl:value-of select="HitCount"/></td>
											<td><xsl:value-of select="C0"/></td>
											<td><xsl:value-of select="C1"/></td>
											<td><xsl:value-of select="FallThrough"/></td>
											<td>
												<table border="0" width="100%">
													<xsl:for-each select="Successor">
														<tr>
															<td><xsl:value-of select="Address"/></td>
															<td><xsl:value-of select="HitCount"/></td>
															<td><xsl:value-of select="FromSource"/></td>
														</tr>
													</xsl:for-each>
												</table>
											</td>
										</tr>
									</xsl:for-each>
								</table>
							</div>
						</xsl:for-each>
						<!-- end of debuginfo -->
					</xsl:for-each>
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
