<?xml version="1.0" encoding="UTF-8"?>
<!--
  biblioteca.xsl · HOJA DE ESTILO XSLT 1.0
  ===========================================================================
  XSLT es un lenguaje (escrito en XML) que TRANSFORMA un XML en otra cosa:
  HTML, texto, otro XML... Trabaja por PLANTILLAS (templates) que "casan"
  con nodos del árbol mediante expresiones XPath.

  El XML biblioteca.xml ya la enlaza con la instrucción de proceso
  xml-stylesheet, así que basta con abrirlo en un navegador para verlo
  renderizado como una página web.
  ===========================================================================
-->
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- Plantilla principal: casa con la raíz del documento ("/") -->
  <xsl:template match="/">
    <html>
      <head>
        <meta charset="UTF-8"/>
        <!-- value-of = "imprime el valor de esta expresión XPath" -->
        <title>Catálogo · <xsl:value-of select="biblioteca/@nombre"/></title>
        <style>
          body { font-family: system-ui, sans-serif; margin: 2rem; }
          table { border-collapse: collapse; width: 100%; }
          th, td { border: 1px solid #ccc; padding: .5rem .75rem; text-align: left; }
          th { background: #f0f0f0; }
          .no { color: #b00; } .si { color: #080; }
        </style>
      </head>
      <body>
        <h1><xsl:value-of select="biblioteca/@nombre"/></h1>
        <p>Total de libros: <xsl:value-of select="count(//libro)"/></p>

        <table>
          <tr><th>ISBN</th><th>Título</th><th>Autor</th><th>Año</th>
              <th>Precio</th><th>Disponible</th></tr>

          <!-- for-each recorre un conjunto de nodos; sort los ordena -->
          <xsl:for-each select="biblioteca/libros/libro">
            <xsl:sort select="anio" data-type="number" order="ascending"/>
            <tr>
              <td><xsl:value-of select="@isbn"/></td>
              <td><xsl:value-of select="titulo"/></td>
              <!-- concat() es una función XPath -->
              <td><xsl:value-of select="concat(autor/nombre, ' ', autor/apellidos)"/></td>
              <td><xsl:value-of select="anio"/></td>
              <td><xsl:value-of select="precio"/>
                  <!-- xsl:text obliga a imprimir ese espacio: XSLT descarta
                       el texto en blanco suelto que hay entre etiquetas -->
                  <xsl:text> </xsl:text>
                  <xsl:value-of select="precio/@moneda"/></td>
              <td>
                <!-- choose / when / otherwise = el if-else de XSLT -->
                <xsl:choose>
                  <xsl:when test="@disponible = 'true'">
                    <span class="si">Sí</span>
                  </xsl:when>
                  <xsl:otherwise>
                    <span class="no">Prestado</span>
                  </xsl:otherwise>
                </xsl:choose>
              </td>
            </tr>
          </xsl:for-each>
        </table>

        <h2>Socios</h2>
        <ul>
          <xsl:for-each select="biblioteca/socios/socio">
            <li>
              <xsl:value-of select="nombre"/> (<xsl:value-of select="email"/>)
              <!-- if sin else; el test es una expresión XPath booleana -->
              <xsl:if test="@libro_prestado">
                — tiene prestado:
                <!-- Salto a otro punto del árbol con un predicado [ ] -->
                <xsl:value-of select="//libro[@id = current()/@libro_prestado]/titulo"/>
              </xsl:if>
            </li>
          </xsl:for-each>
        </ul>

        <p><em><xsl:value-of select="biblioteca/pie"/></em></p>
      </body>
    </html>
  </xsl:template>

</xsl:stylesheet>
