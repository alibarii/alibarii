---
title: XML - Resumen completo
tags: [xml, lenguajes-de-marcas, asir, dtd, xsd, xpath, xslt]
creado: 2026-10-01
---

# XML · Resumen completo

> [!abstract] En una frase
> **XML** (*eXtensible Markup Language*) es un metalenguaje para **estructurar y transportar datos** en texto plano, legible por humanos y por máquinas. No "hace" nada por sí mismo: **describe datos**, no presentación ni lógica.

> [!tip] Ficheros de ejemplo que acompañan a este resumen
> - `biblioteca.xml` → documento comentado línea a línea (el ejemplo principal)
> - `biblioteca.dtd` → la misma gramática en DTD
> - `biblioteca-xsd.xml` + `biblioteca.xsd` → la versión con **namespaces** validada por **XML Schema**
> - `biblioteca.xsl` → hoja **XSLT** que convierte el XML en una página HTML
> - `biblioteca-resultado.html` → resultado de aplicar esa transformación

---

## 1. Para qué sirve XML

| Uso | Ejemplos reales |
|---|---|
| Ficheros de configuración | `pom.xml` (Maven), `server.xml` / `web.xml` (Tomcat), `*.csproj`, layouts de Android, Tareas Programadas de Windows |
| Intercambio de datos entre sistemas | SOAP, facturación electrónica **Facturae**, SEPA, HL7 (sanidad), ONIX (libros) |
| Formatos de documento | OOXML (`.docx`, `.xlsx` son ZIP llenos de XML), ODF, **SVG**, **XHTML** |
| Sindicación de contenidos | **RSS**, Atom |
| Interoperabilidad / archivado | Esquemas oficiales, metadatos, exportaciones de BD |

**Características clave**: texto plano (portable), extensible (tú inventas las etiquetas), autodescriptivo, jerárquico (árbol), independiente de plataforma y lenguaje, estándar del **W3C**, soporta **Unicode**.

**Contras**: verboso (pesa más que JSON), parsearlo cuesta más CPU/RAM, curva de aprendizaje mayor (DTD/XSD/XPath/XSLT).

---

## 2. Anatomía de un documento

```xml
<?xml version="1.0" encoding="UTF-8" standalone="no"?>   <!-- 1. Prólogo -->
<!DOCTYPE biblioteca SYSTEM "biblioteca.dtd">            <!-- 2. DOCTYPE -->
<?xml-stylesheet type="text/xsl" href="biblioteca.xsl"?> <!-- 3. PI -->
<!-- 4. Comentario -->
<biblioteca nombre="IES Ejemplo">                        <!-- 5. Raíz + atributo -->
  <libro id="L001">                                      <!-- 6. Elemento -->
    <titulo>Cien años de soledad</titulo>                <!-- 7. Texto (#PCDATA) -->
    <resumen><![CDATA[ if (a < b && c) {...} ]]></resumen><!-- 8. CDATA -->
    <portada/>                                           <!-- 9. Elemento vacío -->
  </libro>
</biblioteca>
```

| Pieza | Qué es | Notas |
|---|---|---|
| **Prólogo / declaración XML** | `<?xml version encoding standalone?>` | Opcional pero **muy recomendable**; si está, debe ser la **primera línea**, sin nada delante (ni un espacio) |
| `encoding` | Juego de caracteres | Por defecto UTF-8. Si pones `ISO-8859-1` y guardas en UTF-8 → acentos rotos |
| `standalone` | `yes` = no depende de declaraciones externas; `no` = sí | |
| **DOCTYPE** | Enlaza con el DTD y puede declarar entidades | `SYSTEM "fich.dtd"` (local) / `PUBLIC "id" "url"` |
| **PI** (instrucción de proceso) | `<?destino datos?>` | Mensaje para la aplicación, p. ej. enlazar XSLT |
| **Elemento** | `<etiqueta>contenido</etiqueta>` | Puede contener texto, otros elementos o ambos (contenido mixto) |
| **Atributo** | `nombre="valor"` dentro de la etiqueta de apertura | Siempre entrecomillado, **no se puede repetir** en el mismo elemento |
| **Comentario** | `<!-- ... -->` | ⚠️ **No puede contener `--`** dentro ni acabar en `--->` |
| **CDATA** | `<![CDATA[ ... ]]>` | Todo es texto literal: ideal para código, HTML o símbolos `<` `&` |
| **Entidad** | `&nombre;` | Constante de texto |

### Entidades predefinidas (las 5 de serie)

| Entidad | Carácter | Cuándo es obligatoria |
|---|---|---|
| `&lt;` | `<` | **Siempre** en texto |
| `&amp;` | `&` | **Siempre** en texto |
| `&gt;` | `>` | Recomendada |
| `&quot;` | `"` | Dentro de atributos delimitados por `"` |
| `&apos;` | `'` | Dentro de atributos delimitados por `'` |

También existen las **referencias numéricas**: `&#169;` o `&#xA9;` → ©.

### Reglas para los nombres de etiqueta
- Empiezan por **letra** o `_` (nunca por número ni por las letras `xml` en cualquier combinación de mayúsculas).
- Pueden llevar letras, dígitos, `.`, `-`, `_`; **no espacios**.
- **Case sensitive**: `<Libro>` ≠ `<libro>`.

---

## 3. Bien formado vs. válido ⭐ (pregunta clásica de examen)

> [!important]
> **Bien formado (*well-formed*)** = cumple la **sintaxis** de XML.
> **Válido (*valid*)** = está bien formado **y además** cumple una gramática (DTD o XSD).
> Todo documento válido está bien formado; **lo contrario no es cierto**.

**Requisitos de "bien formado"**
1. Un **único elemento raíz**.
2. Toda etiqueta se cierra (`<a></a>` o `<a/>`).
3. Anidamiento correcto, sin cruces.
4. Mayúsculas/minúsculas coherentes en apertura y cierre.
5. Valores de atributo **entre comillas**.
6. Atributos no repetidos en un mismo elemento.
7. `<` y `&` escapados o dentro de CDATA.
8. La declaración XML, si existe, va la primera.

---

## 4. ¿Elemento o atributo?

| Usa **elemento** cuando… | Usa **atributo** cuando… |
|---|---|
| Es el dato en sí | Es un metadato del dato |
| Puede repetirse (`<genero>` x3) | Es único (`id`, `lang`) |
| Puede crecer / tener hijos | Es un valor corto y atómico |
| Puede ser largo o multilínea | Identifica o clasifica |

> [!tip] Regla práctica
> **Ante la duda, elemento.** Un atributo no se puede repetir, no admite estructura interna y es más incómodo de extender luego.

---

## 5. Espacios de nombres (namespaces)

Evitan colisiones de nombres cuando se mezclan vocabularios (mi `<titulo>` vs. el `<titulo>` de otro esquema).

```xml
<biblioteca xmlns="https://alibarii.github.io/biblioteca"          <!-- por defecto -->
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"  <!-- con prefijo -->
            xsi:schemaLocation="https://alibarii.github.io/biblioteca biblioteca.xsd">
```

- `xmlns="URI"` → namespace **por defecto** para ese elemento y sus descendientes sin prefijo.
- `xmlns:pre="URI"` → namespace **con prefijo**: `<pre:libro>`.
- La **URI es sólo un identificador único**, no hace falta que la página exista.
- Lo que identifica un namespace es **la URI**, no el prefijo (dos prefijos distintos con la misma URI son el mismo namespace).

---

## 6. DTD (Document Type Definition)

```dtd
<!ELEMENT libro (titulo, autor, editorial, anio, precio, generos, resumen)>
<!ATTLIST libro
          id         ID           #REQUIRED
          isbn       CDATA        #REQUIRED
          disponible (true|false) "true">
<!ELEMENT titulo (#PCDATA)>
<!ELEMENT generos (genero+)>
<!ENTITY  centro "IES Ejemplo">
```

**Sintaxis mínima**

| Símbolo | Significado |
|---|---|
| *(sin símbolo)* | exactamente 1 |
| `?` | 0 ó 1 |
| `*` | 0 ó más |
| `+` | 1 ó más |
| `,` | secuencia **en ese orden** |
| `\|` | alternativa (uno u otro) |
| `#PCDATA` | texto analizable |
| `EMPTY` / `ANY` | elemento vacío / cualquier contenido |

**Tipos de atributo**: `CDATA` (texto), `ID` (identificador único en todo el documento), `IDREF` / `IDREFS` (referencia a un `ID` existente), `(a|b|c)` (lista cerrada), `NMTOKEN`, `ENTITY`.
**Modificadores**: `#REQUIRED`, `#IMPLIED` (opcional), `#FIXED "v"`, `"valor por defecto"`.

**Dónde se pone**
- *Interno*: `<!DOCTYPE raiz [ ...declaraciones... ]>`
- *Externo*: `<!DOCTYPE raiz SYSTEM "fich.dtd">`
- *Mixto*: externo + `[ ... ]` con añadidos (así están declaradas las entidades en `biblioteca.xml`).

---

## 7. XSD (XML Schema) — el sustituto moderno del DTD

```xml
<xs:element name="anio">
  <xs:simpleType>
    <xs:restriction base="xs:gYear">
      <xs:minInclusive value="1450"/>
      <xs:maxInclusive value="2100"/>
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

**Tipos básicos**: `xs:string`, `xs:integer`, `xs:decimal`, `xs:boolean`, `xs:date`, `xs:time`, `xs:dateTime`, `xs:gYear`, `xs:anyURI`, `xs:ID`, `xs:IDREF`, `xs:language`.
**Restricciones (facetas)**: `minInclusive` / `maxInclusive`, `minLength` / `maxLength`, `length`, `pattern` (regex), `enumeration`, `totalDigits`, `fractionDigits`, `whiteSpace`.
**Compositores**: `xs:sequence` (en orden), `xs:choice` (uno de ellos), `xs:all` (todos, en cualquier orden).
**Cardinalidad**: `minOccurs` / `maxOccurs` (`"unbounded"` = sin límite; por defecto ambos valen 1).
**Tipos**: `simpleType` (sólo texto) vs. `complexType` (con hijos y/o atributos); `simpleContent` = texto + atributos.

### DTD vs XSD ⭐

| | DTD | XSD |
|---|---|---|
| Sintaxis | Propia, no XML | **XML** (se parsea con las mismas herramientas) |
| Tipos de datos | Prácticamente sólo texto | **Decenas**, más tipos propios |
| Namespaces | ❌ | ✅ |
| Cardinalidad | `? * +` | `minOccurs` / `maxOccurs` con números exactos |
| Restricciones (regex, rangos) | ❌ | ✅ |
| Entidades | ✅ | ❌ |
| Verbosidad | Compacto | Muy verboso |
| Uso hoy | Legado / docs sencillos | **Estándar de facto** |

> Otras alternativas: **RELAX NG** (más legible) y **Schematron** (reglas de negocio con XPath).

---

## 8. XPath — el "lenguaje de rutas" ⭐

Sirve para **seleccionar nodos** dentro del árbol. Lo usan XSLT, XQuery, los parsers y herramientas como `xmllint`.

| Expresión | Selecciona |
|---|---|
| `/biblioteca/libros/libro` | Ruta **absoluta** desde la raíz |
| `//libro` | Todos los `libro`, **a cualquier profundidad** |
| `.` / `..` | Nodo actual / nodo padre |
| `@isbn` | El **atributo** isbn |
| `//libro/@*` | Todos los atributos de los libros |
| `//libro[1]` | El primer libro (los índices empiezan en **1**) |
| `//libro[last()]` | El último |
| `//libro[@disponible='true']` | **Predicado** por valor de atributo |
| `//libro[precio > 20]` | Predicado por valor de elemento |
| `//libro[titulo='X']/autor/apellidos` | Combinación |
| `//titulo \| //autor` | Unión de dos conjuntos |
| `//libro[contains(titulo,'soledad')]` | Función de texto |
| `count(//libro)` | Función numérica |
| `//genero/text()` | Nodos de texto |

**Ejes**: `child::`, `parent::`, `ancestor::`, `descendant::`, `following-sibling::`, `preceding-sibling::`, `attribute::`, `self::`.
**Funciones útiles**: `text()`, `name()`, `position()`, `last()`, `count()`, `concat()`, `contains()`, `starts-with()`, `substring()`, `string-length()`, `normalize-space()`, `sum()`, `not()`.

```bash
# Probar XPath desde la terminal
xmllint --xpath "//libro[@disponible='true']/titulo/text()" biblioteca.xml
```

---

## 9. XSLT — transformar XML en otra cosa

XSLT es un lenguaje **declarativo escrito en XML** que convierte un XML en HTML, texto u otro XML aplicando **plantillas** que casan con rutas XPath.

```xml
<xsl:template match="/">            <!-- plantilla que casa con la raíz -->
  <xsl:value-of select="@nombre"/>  <!-- imprimir valor -->
  <xsl:for-each select="//libro">   <!-- bucle -->
    <xsl:sort select="anio" data-type="number"/>
    <xsl:if test="@disponible='true'"> ... </xsl:if>
    <xsl:choose>                    <!-- if / else if / else -->
      <xsl:when test="precio > 20">Caro</xsl:when>
      <xsl:otherwise>Barato</xsl:otherwise>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>
```

- Se enlaza desde el XML con `<?xml-stylesheet type="text/xsl" href="hoja.xsl"?>` → el navegador lo transforma al abrirlo.
- Desde la terminal: `xsltproc biblioteca.xsl biblioteca.xml > salida.html`
- **XQuery** es el otro lenguaje de consulta (más parecido a SQL, para grandes colecciones de documentos). XSLT transforma, XQuery consulta.

---

## 10. Procesar XML desde código: DOM vs SAX ⭐

| | **DOM** | **SAX** | **StAX / iterparse** |
|---|---|---|---|
| Modelo | Carga **todo el árbol** en memoria | Lee en **flujo**, lanza eventos | Flujo, pero controlado por el programa (*pull*) |
| Memoria | Alta (ficheros grandes = problema) | Mínima | Mínima |
| Navegación | Libre, en cualquier dirección | Sólo hacia delante, una pasada | Hacia delante, bajo demanda |
| Modificar el documento | ✅ | ❌ | Limitado |
| Cuándo usarlo | Ficheros pequeños/medianos, hay que editar o saltar de un lado a otro | Ficheros enormes, sólo extraer datos | Punto medio |

```python
# DOM con la librería estándar de Python
import xml.etree.ElementTree as ET

arbol = ET.parse("biblioteca.xml")
raiz  = arbol.getroot()

for libro in raiz.findall(".//libro"):           # XPath (soporte parcial)
    print(libro.get("isbn"), libro.find("titulo").text)

libro = raiz.find(".//libro[@id='L001']")
libro.find("precio").text = "21.00"
arbol.write("salida.xml", encoding="utf-8", xml_declaration=True)
```

```python
# Streaming para ficheros muy grandes
for evento, elem in ET.iterparse("enorme.xml", events=("end",)):
    if elem.tag == "libro":
        print(elem.findtext("titulo"))
        elem.clear()          # liberar memoria
```

---

## 11. Herramientas de terminal (muy útiles en ASIR)

```bash
# ¿Está bien formado?
xmllint --noout biblioteca.xml

# ¿Es válido contra su DTD?
xmllint --noout --valid biblioteca.xml

# ¿Es válido contra un XSD?
xmllint --noout --schema biblioteca.xsd biblioteca-xsd.xml

# Formatear / indentar
xmllint --format feo.xml > bonito.xml

# Consultar con XPath
xmllint --xpath "count(//libro)" biblioteca.xml

# Transformar con XSLT
xsltproc biblioteca.xsl biblioteca.xml > catalogo.html

# xmlstarlet: editar desde scripts
xmlstarlet ed -u "//precio" -v "9.99" biblioteca.xml
```

---

## 12. XML vs JSON vs YAML

| | XML | JSON | YAML |
|---|---|---|---|
| Legibilidad | Media (verboso) | Buena | Muy buena |
| Tamaño | Grande | Pequeño | Pequeño |
| Tipos de dato | Sólo con XSD | Nativos (número, bool, null) | Nativos |
| Comentarios | ✅ | ❌ | ✅ |
| Atributos / metadatos | ✅ | ❌ (hay que simular) | ❌ |
| Validación por esquema | ✅ XSD (maduro) | JSON Schema | JSON Schema |
| Namespaces | ✅ | ❌ | ❌ |
| Consulta / transformación | XPath, XSLT, XQuery | JSONPath, jq | — |
| Dónde manda hoy | Configuración empresarial, documentos, SOAP, sector público | APIs REST, web | Configuración DevOps (Docker, K8s, Ansible) |

---

## 13. Errores típicos (y de examen) ⚠️

- [ ] Poner **algo antes** de `<?xml ... ?>` (hasta un espacio o un BOM falla).
- [ ] **Dos raíces** en el mismo documento.
- [ ] `<Libro>...</libro>` → mayúsculas distintas.
- [ ] Etiquetas cruzadas: `<a><b></a></b>`.
- [ ] Atributo sin comillas: `id=L001`.
- [ ] Atributo repetido en el mismo elemento.
- [ ] `&` suelto en texto (`Tom & Jerry` → `Tom &amp; Jerry`).
- [ ] `--` dentro de un comentario.
- [ ] Nombre de etiqueta que empieza por número o contiene espacios.
- [ ] Declarar `encoding="ISO-8859-1"` y guardar el fichero en UTF-8.
- [ ] En el DTD, el **orden** de los hijos importa con `,` (no es un conjunto).
- [ ] Un `IDREF` que apunta a un `ID` que no existe → **no válido**.
- [ ] Olvidar `xsi:schemaLocation` o el namespace al validar con XSD.

---

## 14. Glosario rápido

| Término | Definición en una línea |
|---|---|
| **Nodo** | Cada pieza del árbol: elemento, atributo, texto, comentario, PI |
| **Elemento raíz** | El único elemento que contiene a todos los demás |
| **#PCDATA** | *Parsed Character Data*: texto que el parser sí analiza |
| **CDATA** | Texto literal que el parser **no** analiza |
| **Entidad** | Atajo de texto que se expande con `&nombre;` |
| **DTD / XSD** | Gramáticas que definen qué es válido |
| **Namespace** | URI que da unicidad a los nombres de etiqueta |
| **XPath** | Lenguaje para seleccionar nodos |
| **XSLT** | Lenguaje para transformar XML en otro formato |
| **XQuery** | Lenguaje de consulta sobre colecciones XML |
| **Parser** | Programa que lee el XML (DOM, SAX, StAX) |
| **Documento bien formado** | Cumple la sintaxis |
| **Documento válido** | Bien formado **+** conforme a su DTD/XSD |

---

## 15. Chuleta de 10 líneas

```text
<?xml version="1.0" encoding="UTF-8"?>   -> siempre lo primero
1 sola raíz · todo se cierra · bien anidado · case sensitive · atributos con comillas
&lt; &gt; &amp; &quot; &apos;            -> las 5 entidades predefinidas
<![CDATA[ texto literal ]]>              -> escape masivo
<!-- comentario sin dos guiones seguidos -->
Bien formado = sintaxis   |   Válido = sintaxis + gramática (DTD/XSD)
DTD: ? * + , |  ID/IDREF  |  XSD: tipos, patrones, minOccurs/maxOccurs, namespaces
XPath: //libro[@id='L001']/titulo/text()
XSLT: template + value-of + for-each + if/choose  -> HTML
DOM = todo en memoria, editable | SAX = flujo, rápido, sólo lectura
```
