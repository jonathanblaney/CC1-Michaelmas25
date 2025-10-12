<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.tei-c.org/ns/1.0"
    version="2.0" exclude-result-prefixes="#all">

    <xsl:output method="text" indent="yes" encoding="UTF-8"/>

    <!-- Create a variable that sets the value of the delimiter -->
    <xsl:variable name="delimiter" select="','"/>


    <xsl:template name="xml_to_csv" match="/">

        <!--column headings-->
        <xsl:text>Organism</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Organism Type</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Organism ID</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Date</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Place</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Place ID</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Latitude</xsl:text>
        <xsl:value-of select="$delimiter"/>
        <xsl:text>Longitude</xsl:text>
        <xsl:text>&#xa;</xsl:text>

        <!--goes through each entry in the notebook-->
        <xsl:for-each select="//*:div[@type='entry']">
            
            <!--gets the information common to each entry - the place name, place name id and date-->
            <xsl:variable name="place_id" select=".//*:placeName[1]/@key"/>
            <xsl:variable name="place_name" select=".//*:placeName[1]"/>
            <xsl:variable name="date" select=".//*:date/@when"/>
            
            <!--uses the Wikidata API and the place name id to fetch the latitude and longitude-->
            <!--builds the place name id into the URI to send off to the Wikidata site-->
            <xsl:variable name="place_uri"
                select="concat('https://www.wikidata.org/w/api.php?action=wbgetentities&amp;sites=enwiki&amp;ids=', $place_id, '&amp;format=xml')"/>
            
            <xsl:message select="$place_uri"/>
            
            <!--the URI pulls back an XML file from which we can derive the latitude and longitude-->
            <xsl:variable name="latitude">
                
                <xsl:value-of
                    select="document($place_uri)//*:property[@id='P625'][1]//*:value/@latitude"/>
                
            </xsl:variable>
            
            <xsl:variable name="longitude">
                
                <xsl:value-of
                    select="document($place_uri)//*:property[@id='P625'][1]//*:value/@longitude"/>
                
            </xsl:variable>
            
            <!--goes through each organism in the entry-->
            <xsl:for-each select=".//*:name">
                
                <!--gets the organism name, type and id-->
                <xsl:variable name="organism" select="."/>
                <xsl:variable name="organism_type" select="@type"/>
                <xsl:variable name="organism_id" select="@key"/>
                
                <!--writes the whole entry to the output file-->
                <!--organism name and place name might contain commas, so they need to be surrounded by double quotes so they don't split into separate columns-->
                <xsl:text>"</xsl:text><xsl:value-of select="normalize-space($organism)"/><xsl:text>"</xsl:text>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$organism_type"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$organism_id"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$date"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:text>"</xsl:text><xsl:value-of select="normalize-space($place_name)"/><xsl:text>"</xsl:text>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$place_id"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$latitude"/>
                <xsl:value-of select="$delimiter"/>
                <xsl:value-of select="$longitude"/>
                <xsl:text>&#xa;</xsl:text>
                
                
            </xsl:for-each>
            
        </xsl:for-each>

    </xsl:template>

</xsl:stylesheet>
