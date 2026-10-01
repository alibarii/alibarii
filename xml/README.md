# XML · ejemplo comentado + resumen

Material de estudio de XML (Lenguajes de Marcas / ASIR).

| Fichero | Qué es |
|---|---|
| `XML - Resumen completo.md` | Resumen de todo XML, listo para Obsidian |
| `biblioteca.xml` | Ejemplo principal, comentado línea a línea (DTD + entidades + CDATA + PI) |
| `biblioteca.dtd` | Gramática en DTD |
| `biblioteca-xsd.xml` | El mismo documento con namespaces |
| `biblioteca.xsd` | Gramática en XML Schema (tipos, patrones, cardinalidades) |
| `biblioteca.xsl` | Hoja XSLT: convierte el XML en una página HTML |
| `biblioteca-resultado.html` | Resultado de aplicar la transformación |

```bash
xmllint --noout --valid biblioteca.xml                      # válido contra el DTD
xmllint --noout --schema biblioteca.xsd biblioteca-xsd.xml  # válido contra el XSD
xsltproc biblioteca.xsl biblioteca.xml > catalogo.html      # transformar a HTML
```

Abrir `biblioteca.xml` directamente en el navegador también muestra el HTML,
porque el documento enlaza la hoja XSLT con `<?xml-stylesheet ...?>`.
