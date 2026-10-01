---
title: XML - Resumen completo (explicado desde cero)
tags: [xml, lenguajes-de-marcas, asir, dtd, xsd, xpath, xslt]
creado: 2026-10-01
---

# XML explicado desde cero

> [!abstract] Léeme primero
> Esta nota está escrita **suponiendo que no sabes nada de XML**. Va de lo más tonto a lo más avanzado.
> Si lees las secciones **1 a 7** ya entiendes XML de verdad. De la 8 en adelante son las "herramientas" que lo rodean (DTD, XSD, XPath, XSLT...), que se estudian después.
> No intentes memorizar nada: lee, y cuando veas un ejemplo, **escríbelo tú en un fichero y pruébalo**.

---

# PARTE 1 · ENTENDER QUÉ ES XML

## 1. ¿Qué es XML? (en cristiano)

Imagina que tienes que guardar esta información:

```
Ali, 23 años, vive en Madrid
```

Tú lo entiendes perfectamente. **Un programa no.** El programa no sabe si "Madrid" es la ciudad, el apellido o el nombre del gato. Para él es un churro de letras.

Ahora lo mismo, pero **etiquetando cada dato**:

```xml
<persona>
  <nombre>Ali</nombre>
  <edad>23</edad>
  <ciudad>Madrid</ciudad>
</persona>
```

Eso es XML. Ya está. **XML es poner etiquetas alrededor de cada dato para decir qué es cada cosa.**

> [!note] La idea en una frase
> **XML** (*eXtensible Markup Language*, "lenguaje de marcas extensible") es una forma de **guardar datos en un fichero de texto, ordenados y etiquetados**, para que tanto una persona como un programa puedan entenderlos.

### Las tres palabras del nombre

| Palabra | Qué significa en realidad |
|---|---|
| **Markup** (marcas) | Los datos van "marcados" con etiquetas: `<nombre>Ali</nombre>` |
| **Extensible** | **Las etiquetas te las inventas tú.** No hay una lista oficial. `<nombre>`, `<patatas>`, `<routerCisco>`... lo que necesites |
| **Language** | Tiene unas reglas de escritura que hay que respetar |

### Lo que MÁS confunde al principio ⚠️

**XML no hace nada.** No es un lenguaje de programación. No tiene `if`, ni bucles, ni calcula nada. Es un **formato para guardar y transportar datos**, como lo es un `.csv` o un `.json`. Es un fichero de texto y punto.

Si abres un XML, no "pasa" nada. Alguien tiene que **leerlo con un programa** para que sirva de algo.

### XML vs HTML (la otra duda típica) ⭐

Se parecen muchísimo porque **los dos usan etiquetas**, pero su propósito es opuesto:

| | HTML | XML |
|---|---|---|
| ¿Para qué sirve? | **Mostrar** información en un navegador | **Guardar y transportar** información |
| Las etiquetas | Fijas, inventadas por el W3C (`<p>`, `<div>`, `<h1>`) | **Te las inventas tú** (`<libro>`, `<precio>`) |
| ¿Qué describen? | Cómo **se ve** el dato | Qué **es** el dato |
| ¿Perdona errores? | Sí, el navegador se apaña | **No.** Si hay un fallo, el programa se niega a leerlo entero |

> Resumen: **HTML dice "esto va en negrita". XML dice "esto es un precio".**

### ¿Y dónde me voy a encontrar XML? (spoiler: en todas partes)

| Dónde | Ejemplos que te vas a cruzar en ASIR |
|---|---|
| Configuración de servidores y apps | `server.xml` y `web.xml` de **Tomcat**, `pom.xml` de Maven, layouts de Android |
| Windows | Las **Tareas Programadas** se exportan en XML; respuestas de WMI |
| Documentos | Un `.docx` o un `.xlsx` **es un ZIP lleno de ficheros XML** (pruébalo: renombra un .docx a .zip y ábrelo) |
| Imágenes | Los **SVG** son XML |
| Noticias | Los **RSS** de un blog o un podcast |
| Empresa y Administración | Factura electrónica **Facturae**, SOAP, transferencias SEPA |

---

## 2. Tu primer XML (en 2 minutos)

Abre un editor de texto, escribe esto y guárdalo como `prueba.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persona>
  <nombre>Ali</nombre>
  <edad>23</edad>
</persona>
```

Ahora **arrástralo a tu navegador**. Verás el árbol de datos pintado, con sus etiquetas, y podrás plegar y desplegar ramas. Enhorabuena: eso significa que tu XML está bien escrito.

Ahora **rómpelo** a propósito: quita el `</nombre>` de cierre y recarga. El navegador te escupirá un **error en rojo** y no te mostrará nada.

> [!important] Primera lección, la más importante de todas
> XML es **estricto**. O está perfecto, o el programa lo rechaza **entero**. No existe el "medio bien". Esto, que parece una molestia, es justo su gracia: si un fichero XML se lee, sabes seguro que no está corrupto.

---

## 3. Las piezas de un XML, una a una

Vamos a desmontar este trozo:

```xml
<libro id="L001">
  <titulo>Cien años de soledad</titulo>
</libro>
```

### 3.1 Etiqueta (*tag*)

Una palabra entre `<` y `>`. Hay de dos tipos:

- **De apertura**: `<titulo>`
- **De cierre**: `</titulo>` ← fíjate en la **barra** `/`

### 3.2 Elemento

Es **el conjunto completo**: etiqueta de apertura + lo que hay dentro + etiqueta de cierre.

```
<titulo>Cien años de soledad</titulo>
└──┬──┘└────────┬───────────┘└──┬───┘
apertura     contenido        cierre
└──────────── el ELEMENTO ──────────┘
```

Si el elemento no tiene contenido, se puede escribir abreviado:

```xml
<portada></portada>   <!-- estas dos líneas -->
<portada/>            <!-- significan EXACTAMENTE lo mismo -->
```

### 3.3 Anidar (meter unos dentro de otros) 🪆

Esto es lo que hace que XML sea potente: **un elemento puede contener otros elementos**, como muñecas rusas.

```xml
<libro>
  <autor>
    <nombre>Gabriel</nombre>
    <apellidos>García Márquez</apellidos>
  </autor>
</libro>
```

Dibujado, queda un **árbol** (de ahí que se hable del "árbol XML"):

```text
libro
└── autor
    ├── nombre      → "Gabriel"
    └── apellidos   → "García Márquez"
```

Vocabulario que verás todo el rato: `autor` es **hijo** de `libro`; `nombre` y `apellidos` son **hermanos** entre sí e **hijos** de `autor`; `libro` es su **padre**. Cada cosita del árbol (un elemento, un texto, un atributo) se llama **nodo**.

### 3.4 El elemento raíz

Es el elemento que lo envuelve absolutamente todo, el tronco del árbol.

> [!warning] Regla de oro
> **Sólo puede haber UN elemento raíz.** Esto está MAL y el fichero no se abrirá:
> ```xml
> <persona>Ali</persona>
> <persona>Marta</persona>   <!-- ERROR: dos raíces -->
> ```
> La solución es siempre meterlo todo dentro de un elemento que haga de contenedor:
> ```xml
> <personas>
>   <persona>Ali</persona>
>   <persona>Marta</persona>
> </personas>
> ```

### 3.5 Atributo

Es información extra que va **dentro de la etiqueta de apertura**, con la forma `nombre="valor"`:

```xml
<libro id="L001" disponible="true">
```

Aquí `id` y `disponible` son atributos del elemento `libro`. Las comillas **son obligatorias** (valen las dobles `"` o las simples `'`, pero sé coherente).

---

## 4. La primera línea rara: `<?xml ... ?>`

```xml
<?xml version="1.0" encoding="UTF-8"?>
```

Esto se llama **declaración XML** o **prólogo**. No es un elemento (fíjate en los `?`), es una nota para el programa que va a leer el fichero. Tiene tres partes:

| Parte | Para qué sirve | Qué poner |
|---|---|---|
| `version="1.0"` | Versión de XML | Siempre `1.0` (existe la 1.1, pero nadie la usa) |
| `encoding="UTF-8"` | **Qué alfabeto usa el fichero** | Siempre `UTF-8`. Es lo que permite ñ, acentos, € |
| `standalone="no"` | Si el documento depende de otro fichero externo (un DTD) | Opcional; por defecto `yes` |

> [!warning] Dos trampas clásicas
> 1. Si pones la declaración, **tiene que ser lo primero del fichero**. Ni un espacio, ni un salto de línea, ni un comentario delante. Nada.
> 2. Si pones `encoding="UTF-8"` pero tu editor guarda en otro formato (o al revés), **los acentos y las ñ saldrán como símbolos raros**. Es el fallo nº 1 de los principiantes.

---

## 5. Las 7 reglas que NO puedes romper ⭐⭐

Si cumples estas 7, tu XML está **"bien formado"** (*well-formed*) y cualquier programa podrá leerlo. Si te saltas una sola, **no se abre**.

### Regla 1 · Un solo elemento raíz
Ya visto arriba.

### Regla 2 · Todo lo que se abre, se cierra

```xml
<nombre>Ali            <!-- ❌ MAL -->
<nombre>Ali</nombre>   <!-- ✅ BIEN -->
<portada/>             <!-- ✅ BIEN (vacío, se cierra en la propia etiqueta) -->
```

### Regla 3 · Bien anidado, sin cruzarse

Piensa en paréntesis: el último que abres es el primero que cierras.

```xml
<a><b>texto</a></b>    <!-- ❌ MAL: se cruzan -->
<a><b>texto</b></a>    <!-- ✅ BIEN -->
```

### Regla 4 · Mayúsculas y minúsculas importan

XML es *case sensitive*: `<Libro>` y `<libro>` son **dos etiquetas distintas**.

```xml
<Nombre>Ali</nombre>   <!-- ❌ MAL -->
<nombre>Ali</nombre>   <!-- ✅ BIEN -->
```

### Regla 5 · Los atributos siempre entre comillas

```xml
<libro id=L001>        <!-- ❌ MAL -->
<libro id="L001">      <!-- ✅ BIEN -->
```

### Regla 6 · Un atributo no se puede repetir en el mismo elemento

```xml
<libro id="L001" id="L002">   <!-- ❌ MAL -->
```
Si necesitas varios valores, **no uses un atributo: usa elementos hijos.**

### Regla 7 · Los nombres de etiqueta tienen normas

- Empiezan por **letra** o `_`, **nunca por un número**.
- **Sin espacios** (usa `_` o junta las palabras: `fecha_alta`, `fechaAlta`).
- No pueden empezar por las letras `xml` (en mayúsculas o minúsculas): está reservado.
- Pueden llevar letras, números, `.`, `-` y `_`.

```xml
<1libro>      ❌      <mi libro>   ❌      <xmlDatos>   ❌
<libro1>      ✅      <mi_libro>   ✅      <datosXml>   ✅
```

---

## 6. Los caracteres prohibidos: `<` y `&`

Imagina que quieres escribir esto:

```xml
<empresa>Tom & Jerry S.L.</empresa>      <!-- ❌ ESTO FALLA -->
```

¿Por qué falla? Porque el símbolo `&` tiene un **significado especial** en XML (empieza una "entidad"), igual que `<` significa "empieza una etiqueta". El parser se vuelve loco.

### Solución A: entidades predefinidas (los 5 "apaños" de serie)

Se escribe un código que el parser traduce luego al carácter de verdad:

| Escribes esto | Aparece esto | Cuándo lo necesitas |
|---|---|---|
| `&lt;` | `<` | **Siempre** que quieras un menor-que en el texto |
| `&amp;` | `&` | **Siempre** que quieras un ampersand |
| `&gt;` | `>` | Recomendable |
| `&quot;` | `"` | Dentro de un atributo con comillas dobles |
| `&apos;` | `'` | Dentro de un atributo con comillas simples |

```xml
<empresa>Tom &amp; Jerry S.L.</empresa>   <!-- ✅ se leerá: Tom & Jerry S.L. -->
<condicion>Si a &lt; b entonces...</condicion>
```

> Memoriza al menos estas dos: **`&amp;` para `&`** y **`&lt;` para `<`**. Son el 95% de los casos.

También existen las **referencias numéricas**, por si necesitas un símbolo que no está en tu teclado: `&#169;` o `&#xA9;` dan `©`.

### Solución B: CDATA (cuando hay MUCHOS símbolos raros)

Si tienes que meter un trozo de código o de HTML, escapar símbolo a símbolo es un infierno. Para eso está **CDATA**: todo lo que metas dentro se trata como **texto literal**, el parser ni lo mira.

```xml
<codigo><![CDATA[
  if (stock > 0 && precio < 100) { comprar(); }
  <p>Esto NO es HTML, es texto.</p>
]]></codigo>
```

La sintaxis es siempre igual: se abre con `<![CDATA[` y se cierra con `]]>`. Lo único que **no** puede aparecer dentro es la propia secuencia `]]>`.

### Entidades propias: tus "constantes de texto"

Puedes inventarte tus propias entidades para no repetir un texto largo. Se declaran arriba del todo, en el `DOCTYPE`:

```xml
<!DOCTYPE catalogo [
  <!ENTITY centro "IES Ejemplo · Departamento de Informática">
]>
<catalogo>
  <pie>Catálogo de &centro;</pie>   <!-- se expandirá al texto completo -->
</catalogo>
```

---

## 7. Comentarios

Igual que en HTML, para dejarte notas que el programa ignora:

```xml
<!-- Esto es un comentario y no forma parte de los datos -->
```

> [!warning] Trampa muy tonta en la que caí al escribir estos ficheros
> **Dentro de un comentario no puede haber dos guiones seguidos (`--`).**
> Esto revienta el fichero:
> ```xml
> <!-- ===== Sección libros =====
>      ------------------------- -->   ❌ los guiones seguidos fallan
> ```
> Usa `=` o `*` para hacer separadores decorativos.

---

> [!success] Hasta aquí, lo esencial
> Con las secciones 1 a 7 **ya sabes leer y escribir XML**. Lo que viene ahora son las herramientas del ecosistema: cómo obligar a que un XML tenga una estructura concreta (DTD/XSD), cómo buscar dentro de él (XPath), cómo convertirlo en otra cosa (XSLT) y cómo leerlo desde un programa.

---

# PARTE 2 · EL ECOSISTEMA XML

## 8. ¿Elemento o atributo? La duda eterna

El mismo dato se puede escribir de dos formas, y las dos son correctas:

```xml
<libro precio="19.95"/>                 <!-- como atributo -->
<libro><precio>19.95</precio></libro>   <!-- como elemento -->
```

¿Cuál elijo?

| Usa **ELEMENTO** si... | Usa **ATRIBUTO** si... |
|---|---|
| Es el dato en sí (el contenido) | Es un dato *sobre* el dato (metadato) |
| **Puede repetirse** (un libro con 3 géneros) | Es único y no se repite nunca |
| Puede crecer y tener partes dentro | Es un valor corto y simple |
| Puede ser largo o de varias líneas | Identifica o clasifica (`id`, `idioma`, `moneda`) |

> [!tip] Si dudas, elemento
> Un atributo **no se puede repetir** y **no puede tener hijos**. Si mañana necesitas más detalle, el elemento se amplía sin romper nada y el atributo te obliga a rehacerlo todo.

---

## 9. "Bien formado" vs "Válido" ⭐⭐ (pregunta segura de examen)

Analogía: rellenas una solicitud en papel.

- **Bien formado** = la has escrito con letra legible, sin tachones y en las casillas. *Se puede leer.*
- **Válido** = además, lo que has puesto **cumple las normas**: el DNI tiene 8 números y una letra, la fecha es una fecha real, el campo obligatorio no está vacío. *Se puede aceptar.*

| | Bien formado (*well-formed*) | Válido (*valid*) |
|---|---|---|
| Qué comprueba | La **sintaxis** de XML (las 7 reglas) | Que además **cumple una gramática** (DTD o XSD) |
| ¿Es obligatorio? | **Sí**, siempre | Sólo si el documento tiene DTD/XSD asociado |
| Ejemplo de fallo | Olvidar cerrar una etiqueta | Poner `<anio>mil novecientos</anio>` donde se esperaba un número |

> [!important] La frase que hay que saberse
> **Todo documento válido está bien formado, pero no todo documento bien formado es válido.**

¿Y para qué quiero validar? Para que, cuando otra empresa (o tu propio script) te mande un fichero, puedas comprobar **automáticamente** que trae todos los campos obligatorios y con el formato correcto, sin revisarlo a mano.

---

## 10. DTD · la forma antigua de poner reglas

Un **DTD** es un fichero donde describes **qué estructura debe tener** tu XML: qué elementos existen, en qué orden van y cuántas veces pueden aparecer.

```dtd
<!ELEMENT libro (titulo, autor, precio)>
<!ATTLIST libro id ID #REQUIRED>
<!ELEMENT titulo (#PCDATA)>
```

Traducido al castellano:
- *"Un `libro` contiene un `titulo`, luego un `autor` y luego un `precio`, **en ese orden**"*.
- *"`libro` tiene un atributo `id` que es un identificador único y es **obligatorio**"*.
- *"`titulo` contiene texto"* (`#PCDATA` = *Parsed Character Data*, o sea, texto normal).

**Los símbolos que hay que conocer:**

| Símbolo | Significa |
|---|---|
| *(nada)* | aparece **exactamente 1 vez** |
| `?` | 0 ó 1 vez (opcional) |
| `*` | 0 ó más veces |
| `+` | **1 ó más** veces |
| `,` | uno detrás de otro, **en ese orden** |
| `\|` | uno **u** otro |

**Tipos de atributo útiles**: `CDATA` (texto normal), `ID` (identificador **único** en todo el documento), `IDREF` (referencia a un `ID` que debe existir: es como una clave foránea), `(a\|b\|c)` (sólo se admite uno de esos valores).
**Obligatoriedad**: `#REQUIRED` (obligatorio), `#IMPLIED` (opcional), `"valor"` (valor por defecto).

**Cómo se enlaza al XML**, justo debajo de la declaración:

```xml
<!DOCTYPE biblioteca SYSTEM "biblioteca.dtd">
```
(`biblioteca` debe ser el nombre del **elemento raíz**).

---

## 11. XSD (XML Schema) · la forma moderna

El DTD tiene dos pegas gordas: **no entiende de tipos de datos** (para él todo es texto, así que no puede evitar que pongas "patata" en el año) y **tiene su propia sintaxis rara**.

El **XSD** arregla ambas cosas: está escrito **en XML** y tiene tipos de datos de verdad.

```xml
<xs:element name="anio">
  <xs:simpleType>
    <xs:restriction base="xs:gYear">     <!-- tiene que ser un AÑO -->
      <xs:minInclusive value="1450"/>    <!-- y estar entre 1450 -->
      <xs:maxInclusive value="2100"/>    <!-- y 2100 -->
    </xs:restriction>
  </xs:simpleType>
</xs:element>
```

**Vocabulario mínimo del XSD:**

| Concepto | Qué es |
|---|---|
| `xs:simpleType` | Un tipo que **sólo contiene texto/números**, sin hijos ni atributos |
| `xs:complexType` | Un tipo que **tiene hijos y/o atributos** |
| `xs:sequence` | Los hijos van **en ese orden** |
| `xs:choice` | Va **uno u otro** de los hijos |
| `xs:all` | Van todos, **en cualquier orden** |
| `minOccurs` / `maxOccurs` | Cuántas veces puede aparecer (`"unbounded"` = sin límite). Por defecto, 1 y 1 |
| `xs:restriction` | Pone límites a un tipo existente |

**Tipos de datos** que te da gratis: `xs:string`, `xs:integer`, `xs:decimal`, `xs:boolean`, `xs:date`, `xs:dateTime`, `xs:gYear`, `xs:anyURI`, `xs:ID`, `xs:IDREF`...
**Restricciones (facetas)**: `minInclusive`/`maxInclusive` (rangos), `minLength`/`maxLength`, `pattern` (expresión regular, p. ej. para validar un email o un ISBN), `enumeration` (lista cerrada de valores permitidos).

### DTD vs XSD ⭐

| | DTD | XSD |
|---|---|---|
| ¿Está escrito en XML? | ❌ sintaxis propia | ✅ sí |
| Tipos de datos | ❌ (todo es texto) | ✅ decenas |
| Rangos, regex, listas | ❌ | ✅ |
| Namespaces | ❌ | ✅ |
| Entidades | ✅ | ❌ |
| Longitud | Corto y rápido de escribir | Muy verboso |
| Se usa hoy en... | Documentos antiguos o simples | **Todo lo profesional** |

---

## 12. Namespaces (espacios de nombres)

**El problema:** juntas en un mismo fichero datos de dos sitios distintos y los dos tienen un elemento `<titulo>`. ¿Cuál es cuál? Chocan.

**La analogía:** es como los apellidos. En clase hay dos Marías, así que dices "María García" y "María López". El namespace es el apellido de tus etiquetas.

```xml
<biblioteca xmlns="https://alibarii.github.io/biblioteca">
```

- `xmlns="URI"` → **namespace por defecto**: todas las etiquetas de aquí para dentro "se apellidan" así.
- `xmlns:bib="URI"` → namespace **con prefijo**: ahora escribes `<bib:libro>`.

> [!warning] Lo que más choca
> Esa URI **parece una página web pero no lo es**. Es sólo un identificador único, elegido porque los dominios ya son únicos de por sí. **No hace falta que exista ni que se pueda abrir en el navegador.**

Para decirle al validador dónde está el esquema se usa este par de atributos (que vienen de un namespace estándar, `xsi`):

```xml
<biblioteca xmlns="https://alibarii.github.io/biblioteca"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="https://alibarii.github.io/biblioteca biblioteca.xsd">
```

El `schemaLocation` son **pares**: primero el namespace, luego el fichero `.xsd` que lo define.

---

## 13. XPath · buscar dentro del XML

**XPath es como las rutas de carpetas de Linux, pero para moverte por el árbol XML.** Si sabes usar `cd /home/ali/documentos`, ya sabes el 70% de XPath.

| Expresión XPath | Qué selecciona | Equivalente mental |
|---|---|---|
| `/biblioteca/libros/libro` | Ruta exacta desde la raíz | ruta absoluta |
| `//libro` | **Todos** los `libro`, estén donde estén | `find / -name libro` |
| `.` | El nodo actual | `.` |
| `..` | El padre | `..` |
| `@isbn` | El **atributo** isbn (la arroba = atributo) | — |
| `//libro[1]` | El primer libro (**se empieza a contar en 1**, no en 0) | — |
| `//libro[last()]` | El último |  |
| `//libro[@disponible='true']` | Los libros **cuyo atributo** disponible es true | un `WHERE` de SQL |
| `//libro[precio > 20]` | Los libros con precio mayor que 20 | otro `WHERE` |
| `//libro[titulo='X']/autor/apellidos` | Los apellidos del autor de ese libro | un "join" |
| `count(//libro)` | **Cuántos** libros hay | `COUNT(*)` |
| `//titulo/text()` | El texto de dentro, sin las etiquetas | — |

Los corchetes `[ ]` se llaman **predicados** y son el "filtro": *de todos estos, quédate sólo con los que cumplan...*

Pruébalo ahora mismo en la terminal:

```bash
xmllint --xpath "count(//libro)" biblioteca.xml
xmllint --xpath "//libro[@disponible='true']/titulo/text()" biblioteca.xml
```

Funciones que te sacarán de apuros: `contains()`, `starts-with()`, `concat()`, `substring()`, `string-length()`, `normalize-space()`, `sum()`, `not()`, `position()`.

---

## 14. XSLT · convertir el XML en otra cosa

Tu XML tiene los datos, pero es feo de leer para una persona. **XSLT es una plantilla que lo convierte en HTML** (o en texto, o en otro XML distinto).

Analogía: el XML son los datos de una carta (nombre, dirección, importe) y el XSLT es el **documento de Word con los huecos**; al juntarlos sale la carta terminada.

```xml
<xsl:template match="/">                     <!-- "cuando llegues a la raíz, haz esto" -->
  <h1><xsl:value-of select="//titulo"/></h1> <!-- imprimir un valor -->
  <xsl:for-each select="//libro">            <!-- repetir para cada libro -->
    <xsl:sort select="anio"/>                <!-- ordenándolos por año -->
    <p><xsl:value-of select="titulo"/></p>
  </xsl:for-each>
</xsl:template>
```

Lo único que hay que entender: **XSLT usa XPath** (lo de `select="//libro"`) para decidir de dónde saca los datos.

Las 5 instrucciones que cubren casi todo:

| Instrucción | Para qué |
|---|---|
| `xsl:template match="..."` | Define una plantilla para los nodos que casen con esa ruta |
| `xsl:value-of select="..."` | Imprime un valor |
| `xsl:for-each select="..."` | Bucle sobre un conjunto de nodos |
| `xsl:if test="..."` | Condición simple (no hay `else`) |
| `xsl:choose` / `when` / `otherwise` | El if-elseif-else completo |

Para que el navegador lo aplique solo al abrir el XML, se enlaza así dentro del XML:

```xml
<?xml-stylesheet type="text/xsl" href="biblioteca.xsl"?>
```

Esa línea con `<? ?>` se llama **instrucción de proceso (PI)**: no es un dato, es un recado para el programa que lee el fichero.

> Primo hermano: **XQuery**, que es más parecido a SQL y se usa para consultar grandes colecciones de documentos XML. Regla rápida: **XSLT transforma, XQuery consulta.**

---

## 15. Leer XML desde un programa: DOM vs SAX ⭐

Cuando programas, hay dos formas de leer un XML:

- **DOM**: te lees **el libro entero** y lo dejas abierto encima de la mesa. Puedes ir a cualquier página en cualquier momento y hasta tachar y escribir. Pero ocupa toda la mesa (**memoria**).
- **SAX**: alguien te **lee el libro en voz alta** y tú vas apuntando sólo lo que te interesa. No ocupa sitio, pero pasa una sola vez y hacia delante; no puedes volver atrás ni cambiar nada.

| | **DOM** | **SAX** | **StAX / iterparse** |
|---|---|---|---|
| Cómo lee | Carga **todo el árbol** en memoria | Por **eventos**, según va leyendo | Flujo, pero **tú** pides el siguiente trozo |
| Memoria | Mucha | Mínima | Mínima |
| Navegar libremente | ✅ | ❌ sólo hacia delante | ❌ |
| Modificar el documento | ✅ | ❌ | limitado |
| Cuándo usarlo | Ficheros normales; hay que editar o saltar | Ficheros **enormes** (GB), sólo extraer datos | Punto medio |

```python
# DOM con la librería estándar de Python
import xml.etree.ElementTree as ET

arbol = ET.parse("biblioteca.xml")
raiz  = arbol.getroot()

for libro in raiz.findall(".//libro"):            # findall acepta XPath (básico)
    print(libro.get("isbn"),                      # .get() → un ATRIBUTO
          libro.find("titulo").text)              # .text  → el TEXTO de un elemento

libro = raiz.find(".//libro[@id='L001']")
libro.find("precio").text = "21.00"               # modificar
arbol.write("salida.xml", encoding="utf-8", xml_declaration=True)
```

```python
# Streaming, para un fichero gigante que no cabe en memoria
for evento, elem in ET.iterparse("enorme.xml", events=("end",)):
    if elem.tag == "libro":
        print(elem.findtext("titulo"))
        elem.clear()        # soltar la memoria de ese trozo
```

---

## 16. Comprobar y manipular XML desde la terminal

`xmllint` viene de serie en casi cualquier Linux. Es tu mejor amigo para los ejercicios:

```bash
# ¿Está bien formado? (si no dice nada, es que está perfecto)
xmllint --noout biblioteca.xml

# ¿Es válido contra su DTD?
xmllint --noout --valid biblioteca.xml

# ¿Es válido contra un XSD?
xmllint --noout --schema biblioteca.xsd biblioteca-xsd.xml

# Dejarlo bien indentado
xmllint --format feo.xml > bonito.xml

# Buscar con XPath
xmllint --xpath "//libro[@disponible='true']/titulo/text()" biblioteca.xml

# Transformar con XSLT
xsltproc biblioteca.xsl biblioteca.xml > catalogo.html

# Editar desde un script (paquete xmlstarlet)
xmlstarlet ed -u "//precio" -v "9.99" biblioteca.xml
```

> `--noout` significa "no me imprimas el fichero entero, dime sólo si hay errores".

---

## 17. XML vs JSON vs YAML

Los tres sirven para guardar datos estructurados. Hoy conviven:

| | XML | JSON | YAML |
|---|---|---|---|
| Pinta | `<a>1</a>` | `{"a": 1}` | `a: 1` |
| Legibilidad | Regular (muy verboso) | Buena | Muy buena |
| Tamaño | Grande | Pequeño | Pequeño |
| Tipos de dato | Sólo con XSD | Nativos | Nativos |
| ¿Comentarios? | ✅ | ❌ | ✅ |
| Validación por esquema | ✅ XSD (muy maduro) | JSON Schema | JSON Schema |
| Buscar / transformar | XPath, XSLT, XQuery | JSONPath, `jq` | — |
| Manda en... | Empresa, documentos, SOAP, Administración | **APIs web / REST** | **DevOps**: Docker, Kubernetes, Ansible |

Resumen honesto: para una API nueva hoy se usa JSON; XML sigue siendo el rey en configuración empresarial, documentos y sector público, y **te lo vas a encontrar sí o sí** administrando sistemas.

---

## 18. Errores típicos (y de examen) ⚠️

- [ ] Algo escrito **antes** de `<?xml ... ?>` (hasta un espacio).
- [ ] **Dos elementos raíz**.
- [ ] `<Libro>...</libro>` → mayúsculas distintas en apertura y cierre.
- [ ] Etiquetas cruzadas: `<a><b></a></b>`.
- [ ] Atributo sin comillas: `id=L001`.
- [ ] El mismo atributo repetido en un elemento.
- [ ] Un `&` suelto en el texto (→ `&amp;`).
- [ ] Dos guiones `--` dentro de un comentario.
- [ ] Nombre de etiqueta que empieza por número o lleva espacios.
- [ ] `encoding` declarado distinto de cómo guarda el editor → acentos rotos.
- [ ] En el DTD, cambiar el **orden** de los hijos cuando se usó `,`.
- [ ] Un `IDREF` que apunta a un `ID` que no existe → bien formado, pero **no válido**.
- [ ] Validar con XSD y olvidar el namespace o el `xsi:schemaLocation`.

---

## 19. Glosario rápido

| Término | En una línea |
|---|---|
| **Etiqueta** (*tag*) | `<nombre>` o `</nombre>` |
| **Elemento** | Apertura + contenido + cierre |
| **Atributo** | `clave="valor"` dentro de la etiqueta de apertura |
| **Nodo** | Cualquier pieza del árbol (elemento, atributo, texto, comentario) |
| **Elemento raíz** | El que contiene a todos los demás; sólo puede haber uno |
| **Prólogo / declaración** | La línea `<?xml version... ?>` |
| **PI** (instrucción de proceso) | `<?destino datos?>`, un recado para el programa |
| **#PCDATA** | Texto normal, que el parser sí analiza |
| **CDATA** | Texto literal que el parser **no** analiza |
| **Entidad** | Atajo de texto: `&amp;`, `&centro;` |
| **Parser** | El programa que lee el XML y avisa si está mal |
| **DTD / XSD** | Las "reglas" que definen qué estructura es correcta |
| **Namespace** | El "apellido" de las etiquetas, para que no choquen |
| **XPath** | Rutas para seleccionar nodos |
| **XSLT** | Plantilla que transforma el XML en otra cosa |
| **Bien formado** | Cumple la sintaxis |
| **Válido** | Bien formado **+** cumple su DTD/XSD |

---

## 20. Chuleta de 10 líneas

```text
<?xml version="1.0" encoding="UTF-8"?>   -> siempre lo primero del fichero
1 sola raíz | todo se cierra | bien anidado | case sensitive | atributos con comillas
&lt; &gt; &amp; &quot; &apos;            -> los 5 escapes de serie
<![CDATA[ texto literal ]]>              -> escape masivo
<!-- comentario sin dos guiones seguidos -->
Bien formado = sintaxis   |   Válido = sintaxis + gramática (DTD/XSD)
DTD: ? * + , |  ID/IDREF  |  XSD: tipos, patrones, minOccurs/maxOccurs, namespaces
XPath: //libro[@id='L001']/titulo/text()      ( @ = atributo, [] = filtro )
XSLT: template + value-of + for-each + if/choose  -> HTML
DOM = todo en memoria y editable | SAX = flujo, sin memoria, sólo lectura
```

---

## 21. Ficheros de ejemplo que acompañan a esta nota

| Fichero | Qué mirar en él |
|---|---|
| `biblioteca.xml` | El ejemplo grande, **comentado línea a línea**. Ábrelo en el navegador |
| `biblioteca.dtd` | Las reglas en DTD. Pruébalo: `xmllint --noout --valid biblioteca.xml` |
| `biblioteca-xsd.xml` + `biblioteca.xsd` | Lo mismo con namespaces y tipos de datos |
| `biblioteca.xsl` | La plantilla XSLT que lo convierte en una tabla HTML |
| `biblioteca-resultado.html` | El resultado ya generado, para que veas la diferencia |

### Ejercicios para practicar

1. Abre `biblioteca.xml` en el navegador y localiza el elemento raíz.
2. Añade un cuarto libro copiando la estructura de otro y valida: `xmllint --noout --valid biblioteca.xml`.
3. **Rómpelo a propósito** (quita un cierre, cambia una mayúscula, borra un `&amp;`) y lee el error que da `xmllint`. Aprender a leer errores vale más que memorizar reglas.
4. Quita el elemento `<editorial>` de un libro y valida: ¿por qué falla ahora, si el XML sigue "bien escrito"?
5. Pon `libro_prestado="L999"` en un socio y valida: acabas de ver qué es un `IDREF` roto.
6. Escribe un XPath que saque sólo los títulos de los libros publicados después del año 2000.
