-- 
-- Fix database cross-references in Ensembl RDF graph.
--

SET u{ENSEMBL_GRAPH_URI} http://plants.ensembl.org/Solanum_lycopersicum ;
SET u{SGN_GRAPH_URI} https://solgenomics.net/genome/Solanum_lycopersicum ;

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
WITH <$u{ENSEMBL_GRAPH_URI}>
DELETE { ?s rdfs:seeAlso ?o }
INSERT { ?s rdfs:seeAlso ?fixed }
WHERE { 
   ?s rdfs:seeAlso ?o .
   FILTER regex(?o, 'http://identifiers.org/(go|kegg)') .
   BIND(uri(replace(str(?o), '%253A', ':')) AS ?fixed)
} ;

SPARQL
WITH <$u{ENSEMBL_GRAPH_URI}>
DELETE { ?s <http://semanticscience.org/resource/SIO:000630> ?o }
INSERT { ?s <http://semanticscience.org/resource/SIO_000630> ?o }
WHERE { ?s <http://semanticscience.org/resource/SIO:000630> ?o } ;

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo: <http://purl.obolibrary.org/obo/>
WITH <$u{ENSEMBL_GRAPH_URI}>
DELETE { ?s rdfs:seeAlso ?o }
INSERT { ?s rdfs:seeAlso ?fixed }
WHERE {
   ?s a obo:SO_0000120 .
   ?s rdfs:seeAlso ?o .
   FILTER regex(?o, 'http://identifiers.org/ensembl') .
   BIND(uri(replace(str(?o), 'ensembl', 'ensembl.plant')) AS ?fixed)
} ;


-- 
-- Add chromosome type to Ensembl RDF graph.
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
INSERT INTO <$u{ENSEMBL_GRAPH_URI}> {
   ?chr2 a obo:SO_0000340
}  
WHERE {
   GRAPH <$u{SGN_GRAPH_URI}> {
      ?chr1 a obo:SO_0000340 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl/32/solanum_lycopersicum/SL2.50/', replace(str(?chr1), '.+ch0?', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
-- SPARQL
-- PREFIX obo: <http://purl.obolibrary.org/obo/>
-- WITH  <$u{ENSEMBL_GRAPH_URI}>
-- DELETE WHERE { ?s a obo:SO_0000340 } ;


-- 
-- Cross-link chromosomes in two RDF graphs.
--   graph URI: https://solgenomics.net/genome/Solanum_lycopersicum
--     chromosome URI: e.g. http://solgenomics.net/genome/Solanum_lycopersicum/chromosome/SL2.50ch01
--
--   graph URI: http://plants.ensembl.org/Solanum_lycopersicum
--     chromosome URI: e.g. http://rdf.ebi.ac.uk/resource/ensembl/32/solanum_lycopersicum/SL2.50/1
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
INSERT INTO <$u{SGN_GRAPH_URI}> {
   ?chr1 owl:sameAs ?chr2
}   
WHERE {
   GRAPH <$u{SGN_GRAPH_URI}> {
      ?chr1 a obo:SO_0000340 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl/32/solanum_lycopersicum/SL2.50/', replace(str(?chr1), '.+ch0?', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
-- SPARQL
-- PREFIX owl: <http://www.w3.org/2002/07/owl#>
-- WITH  <$u{SGN_GRAPH_URI}>
-- DELETE WHERE {
--    ?s owl:sameAs ?o .
--    ?s a obo:SO_0000340
-- } ;


--
-- Link chromosomes to ENA accessions.
--

SPARQL
PREFIX rdfs: <http://www.w3.org/2000/01/rdf-schema#>
PREFIX sgn-chr: <http://solgenomics.net/genome/Solanum_lycopersicum/chromosome/>
PREFIX ena: <http://identifiers.org/ena.embl/>
INSERT INTO <$u{SGN_GRAPH_URI}> {
   sgn-chr:SL2.50ch01 rdfs:seeAlso ena:CM001064.2 .
   sgn-chr:SL2.50ch02 rdfs:seeAlso ena:CM001065.2 .
   sgn-chr:SL2.50ch03 rdfs:seeAlso ena:CM001066.2 .
   sgn-chr:SL2.50ch04 rdfs:seeAlso ena:CM001067.2 .
   sgn-chr:SL2.50ch05 rdfs:seeAlso ena:CM001068.2 .
   sgn-chr:SL2.50ch06 rdfs:seeAlso ena:CM001069.2 .
   sgn-chr:SL2.50ch07 rdfs:seeAlso ena:CM001070.2 .
   sgn-chr:SL2.50ch08 rdfs:seeAlso ena:CM001071.2 .
   sgn-chr:SL2.50ch09 rdfs:seeAlso ena:CM001072.2 .
   sgn-chr:SL2.50ch10 rdfs:seeAlso ena:CM001073.2 .
   sgn-chr:SL2.50ch11 rdfs:seeAlso ena:CM001074.2 .
   sgn-chr:SL2.50ch12 rdfs:seeAlso ena:CM001075.2
} ;

--
-- Cross-link protein-coding genes in two RDF graphs.
--   graph URI: https://solgenomics.net/genome/Solanum_lycopersicum
--     gene URI: e.g. http://solgenomics.net/genome/Solanum_lycopersicum/gene/Solyc07g049530.2
--
--   graph URI: http://plants.ensembl.org/Solanum_lycopersicum
--     gene URI: e.g. http://rdf.ebi.ac.uk/resource/ensembl/Solyc07g049530.2
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
INSERT INTO <$u{SGN_GRAPH_URI}> {
   ?gene1 owl:sameAs ?gene2
}
WHERE {  
   GRAPH <$u{SGN_GRAPH_URI}> {
      ?gene1 a obo:SO_0000704 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl/', replace(str(?gene1), '.+/', ''))) AS ?gene2)
   }
   GRAPH <$u{ENSEMBL_GRAPH_URI}> {
      ?gene2 a obo:SO_0001217
   }
} ;


-- 
-- Add primary trascript type to Ensembl RDF graph.
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
INSERT INTO <$u{ENSEMBL_GRAPH_URI}> {
   ?chr2 a obo:SO_0000120
}  
WHERE {
   GRAPH <$u{SGN_GRAPH_URI}> {
      ?chr1 a obo:SO_0000120 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl.transcript/', replace(str(?chr1), '.+/', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
-- SPARQL
-- PREFIX obo: <http://purl.obolibrary.org/obo/>
-- WITH  <$u{ENSEMBL_GRAPH_URI}>
-- DELETE WHERE { ?s a obo:SO_0000120 } ;


-- 
-- Cross-link transcripts in two RDF graphs.
--   graph URI: https://solgenomics.net/genome/Solanum_lycopersicum
--     transcript URI: e.g. http://solgenomics.net/genome/Solanum_lycopersicum/prim_transcript/Solyc02g079500.2.1
--
--   graph URI: http://plants.ensembl.org/Solanum_lycopersicum
--     transcript URI: e.g. http://rdf.ebi.ac.uk/resource/ensembl.transcript/Solyc02g079500.2.1
--

SPARQL
PREFIX obo: <http://purl.obolibrary.org/obo/>
PREFIX owl: <http://www.w3.org/2002/07/owl#>
INSERT INTO <$u{SGN_GRAPH_URI}> {
   ?chr1 owl:sameAs ?chr2
}   
WHERE {
   GRAPH <$u{SGN_GRAPH_URI}> {
      ?chr1 a obo:SO_0000120 .
      BIND(uri(concat('http://rdf.ebi.ac.uk/resource/ensembl.transcript/', replace(str(?chr1), '.+/', ''))) AS ?chr2)
   }
} ;

--
-- Delete triples
--
-- SPARQL
-- PREFIX owl: <http://www.w3.org/2002/07/owl#>
-- WITH  <$u{SGN_GRAPH_URI}>
-- DELETE WHERE {
--    ?s owl:sameAs ?o .
--    ?s a obo:SO_0000120
-- } ;