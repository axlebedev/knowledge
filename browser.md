# How browsers work
https://www.html5rocks.com/en/tutorials/internals/howbrowserswork/#Introduction

# 1 Introduction
## 1.1 The browsers we will talk about
_Desktop_: [Chrome](https://github.com/WebKit/webkit), [FF](https://dxr.mozilla.org), Safari  
_Mobile_: Android Browser, Chrome, iPhone Safari

## 1.2 The browser's main functionality
The main function of a browser is to present the web resource,
request it from the server and display it in the browser window
(HTML, also can be PDF, image etc.)  
The location of the resource is specified by **URI** (Uniform Resource Identifier).  
The way the browser interprets and displays HTML files
is specified in the HTML and CSS specifications maintained by W3C.  
UI (adress bar, forward/back etc.) are not specified at standart.  

## 1.3 The browser's high level structure
1. **The user interface**: this includes the address bar, back/forward button, bookmarking menu, etc.
   Every part of the browser display except the window where you see the requested page.
1. **The browser engine**: marshals actions between the UI and the rendering engine.
1. **The rendering engine**: responsible for displaying requested content.
   For example if the requested content is HTML, 
   the rendering engine parses HTML and CSS, and displays the parsed content on the screen.
1. **Networking**: for network calls such as HTTP requests,
   using different implementations for different platform behind a platform-independent interface.
1. **UI backend**: used for drawing basic widgets like combo boxes and windows.
   This backend exposes a generic interface that is not platform specific.
   Underneath it uses operating system user interface methods.
1. **JavaScript interpreter**. Used to parse and execute JavaScript code.
1. **Data storage**. This is a persistence layer.
   The browser may need to save all sorts of data locally, such as cookies.
   Browsers also support storage mechanisms such as localStorage, IndexedDB, WebSQL and FileSystem.

![Browsers structure](./img/browsers-1-3.png)

Browsers such as Chrome run multiple instances of the rendering engine:
one for each tab. Each tab runs in a separate process.

# 2 The rendering engine
The responsibility is rendering, that is display of 
the requested contents on the browser screen.

## 2.1 Rendering engines
Different browsers use different rendering engines:  
Internet Explorer uses Trident,  
Firefox uses Gecko,  
Safari uses WebKit.  
Chrome and Opera (from version 15) use Blink, a fork of WebKit
webkit.org

## 2.2 The main flow
The rendering engine will start getting the contents from the networking layer.
This will usually be done in 8kB chunks.

After that, the basic flow of the rendering engine:

![Main flow of the rendering engine](./img/browsers-2-2.png)

Step 1 **Parsing**:
1. parse the HTML document
1. **elements** => **DOM nodes** in **"content tree"**.

Step 2 **Render tree**:
1. **style** data (external CSS files and style elements).
1. Style with HTML visual instructions => **render tree**.
Render tree contains rectangles with visual attributes like color and dimensions.

Step 3 **Layout**:
1. Each node receives the exact coordinates where it should appear on the screen

Step 4 **Paing**:
1. Traverse render tree and render each node using UI backend layer

Rendering engine will try to render nodes ASAP, not wait for whole HTML.

## 2.3 Main flow examples

![webkit main flow](./img/browsers-2-3.png)  
webkit main flow

![Main flow examplesMain flow of the rendering engine](./img/browsers-2-32.jpg)  
Mozilla's Gecko rendering engine main flow

We can see that although WebKit and Gecko use slightly different terminology,
the flow is basically the same.

Gecko-Webkit terminology/logic diff:  

| Gecko | Webkit |
|---|---|
| _"Frame tree"_: each element is a frame | _"Render Tree"_: consists of _"Render Objects"_  |
| _"Reflow"_ | _"Layout"_ |
|  | _"Attachment"_ - term for connecting DOM nodes and visual information |
| _"Content sink"_: extra layer between the HTML and the DOM tree, is a factory for making DOM elements. |  |

# 3 Parsing and DOM tree construction
## 3.1 Parsing: general
The result of parsing is a tree of nodes that represent the structure of the document.
This is called a parse tree or a syntax tree.

### 3.1.1 Grammars
Parsing is based on syntax rules. Context-free grammar

### 3.1.2 Parser–Lexer combination
![flow of parsing](./img/browsers-3-1-2.png)  
Figure: from source document to parse trees

Parser goes through document, asks lexer for each new token.  
If there is rule for it - ok, add it to parse tree.  
If not - store it and ask lexer for next token...
If no rule for current collection of tokens - raise an exception, document is invalid.

### 3.1.3 Translation
Example: source code compilation:  
![source code compilation](./img/browsers-3-1-3.png)  

### 3.1.4 Parsing example, 3.1.5 Formal definitions for vocabulary and syntax
Example: parsing expression `2 + 3 - 1`  
We'll get this parse tree:  
![make parse three](./img/browsers-3-1-4.png)  

_Vocabulary_: Our language can include integers, plus signs and minus signs.
_Syntax_:  
The language syntax building blocks are `expressions`, `terms` and `operations`.  
Language can include any number of expressions.  

Vocabulary is usually expressed by regular expressions.  
`INTEGER`: `0|[1-9][0-9]*`  
`PLUS`: `+`  
`MINUS`: `-`  

Syntax is usually defined in a format called BNF:  
`expression` :=  `term operation term`  
`operation` :=  `PLUS | MINUS`  
`term` := `INTEGER | expression`  

OK, we have a context-free grammar.

Let's analyze the input 2 + 3 - 1. 
1. `2` => `term`
1. `2 + 3` => `term + 3` => `term operation integer` => `term operation term` => `expression` => `term`
1. `2 + 3 - 1` => `term - 1`  => `term operation integer` => `term operation term` => `expression` => `term`

`2 + +` will not match any rule and therefore is an invalid input.


### 3.1.6 Types of parsers
1. Top down parser:  
First - higher level rules  
`2 + 3 - 1` => `expression - 1` => `expression`  
2. Bottom up parser:    
Gradually reduce to syntax rules, from first symbol to right  

| Stack | Input |
|---|---|
| | `2 + 3 - 1` |
| `term` | `+ 3 - 1` |
| `term operation` | `3 - 1` |
| `expression` | `- 1` |
| `expression operation` | `1` |
| `expression` | |

### 3.1.7 Generating parsers automatically
There are tools to generate parser automatically, giving them syntax rules and vocabulary.  
Webkit uses `Flex` for generating lexer, `Bison` for generating parser.  

## 3.2 HTML Parser
Its job is to parse HTML markup into parse tree.

### 3.2.1 The HTML grammar definition
The vocabulary and syntax of HTML are defined in specifications created by the W3C organization

### 3.2.2 Not a context free grammar
There is a formal format for defining HTML–*DTD (Document Type Definition)* –
but it is not a context free grammar.  
CSS and JS **are** context-free.  
XML is context-free too. But HTML is not - its approach is to be more "forgiving":
we can omit some open/close tags, or whole certain tags.  
So, HTML makes work more easy for web-page authors, and makes job extremely more difficult
to write formal grammar: its grammar is not context free. HTML can not be parsed by XML parsers.

### 3.2.3 HTML DTD
HTML definition is in a DTD format.  
There are a few variations of the DTD. The strict mode conforms solely to
the specifications but other modes contain support for markup used by browsers
in the past. The purpose is backwards compatibility with older content.  
The current strict DTD is [here](http://www.w3.org)

### 3.2.4 DOM
The _"parse tree"_ is a tree of DOM element and attribute nodes.
It is the object presentation of the HTML document and
the interface of HTML elements to the outside world like JavaScript.
The root of the tree is the "Document" object.

**Example**:  
Input:  
```HTML
<html>
  <body>
    <p>
      Hello World
    </p>
    <div> <img src="example.png"/></div>
  </body>
</html>
```
Output:  
![DOM output](./img/browsers-3-2-4.png)  

Like HTML, DOM is [specified](http://www.w3.org/DOM/DOMTR) by the W3C  
The tree is constructed of the elements that implement one of DOM interfaces.
Each browser has its own implementations.

### 3.2.5 The parsing algorithm
HTML is not strict context-free grammar. Reasens are:  
1. Forgiving nature of language
2. Traditional error tolerance to support well known errors in HTML
3. DOM can be changed dynamically (by JS for instance)

[Parsing algorithm is described in details](http://www.whatwg.org/specs/web-apps/current-work/multipage/parsing.html):  
Two stages: tokenization and construction of tree.  
Available tokens:
* Start tags
* End tags
* Attribute names
* Attribute values

![HTML Parsing flow](./img/browsers-3-2-5.png)  
HTML Parsing flow (from HTML5 spec)

### 3.2.6 The tokenization algorithm
The algorithm is expressed as a state machine:
consume one or multiple characters, update next state.
Decision is influenced by current tokenization state and tree construction state.

It can be shown on picture:
![tokenization state machine](./img/browsers-3-2-6.png)  

### 3.2.7 Tree construction algorithm
When the parser is created the Document object is created.  
The DOM tree with the Document in its root will be modified and elements will be added to it during construction.. 
Token => DOM element.  
The element is added to the DOM tree, and also the stack of open elements. Stack is used to correct nesting mismatches and unclosed tags.  
The algorithm is described as a state machine.  
The states are called "insertion modes".

**Example**:  
Input:  
```HTML
<html>
  <body>
    Hello world
  </body>
</html>
```

States of tree construction (inside of blocks - current state of state machine).  
![tree construction states](./img/browsers-3-2-7.gif)  

### 3.2.8 Actions when parsing is finished
After tree construction (step-by-step):
1. Run `deferred` scripts
2. Document state set to 'complete'
3. 'Load' event is fired

[Full algorithm of tokenization and tree construction](https://www.w3.org/TR/html5/syntax.html#html-parser)

### 3.2.9 Browser error tolerance
There are known invalid HTML constructs repeated on many sites,
and the browsers try to fix them.

The HTML5 specification does define some of these requirements.
(WebKit summarizes this nicely in the comment at the beginning of the HTML parser class.)

The HTML5 specification does define some of these requirements. 
WebKit summarizes this nicely in the comment at the beginning of the HTML parser class:
```
The parser parses tokenized input into the document,
building up the document tree.
If the document is well-formed, parsing it is straightforward.

Unfortunately, we have to handle many HTML documents
that are not well-formed, so the parser has to be tolerant about errors.

We have to take care of at least the following error conditions:

1. The element being added is explicitly forbidden inside some outer tag.
   In this case we should close all tags up 
   to the one which forbids the element, and add it afterwards.
2. We are not allowed to add the element directly.
   It could be that the person writing the document forgot
   some tag in between (or that the tag in between is optional).
   This could be the case with the following tags:
   HTML HEAD BODY TBODY TR TD LI (did I forget any?).
3. We want to add a block element inside an inline element.
   Close all inline elements up to the next higher block element.
4. If this doesn't help, close elements until we 
   are allowed to add the element–or ignore the tag.
```

Some Webkit error handle examples:
```c++
// </br> instead of <br>
if (t->isCloseTag(brTag) && m_document->inCompatMode()) {
    reportError(MalformedBRError);
    t->beginTag = true;
}

// <table> in another <table>, but not in cell:
// <table>
//     <table>
//         <tr><td>inner table</td></tr>
//     </table>
//     <tr><td>outer table</td></tr>
// </table>
// becomes:
// <table>
//     <tr><td>outer table</td></tr>
// </table>
// <table>
//     <tr><td>inner table</td></tr>
// </table>
if (m_inStrayTableContent && localName == tableTag)
    popBlock(tableTag);

// if a form is inside another form, outer form is ignored:
if (!m_currentFormElement) {
    m_currentFormElement = new HTMLFormElement(formTag,    m_document);
}

// too deep hierarchy
// from webkit source:
// www.liceo.edu.mx is an example of a site that achieves
// a level of nesting of about 1500 tags, all from a bunch of <b>s.
// We will only allow at most 20 nested tags
// of the same type before just ignoring them all together.
bool HTMLParser::allowNestedRedundantTag(const AtomicString& tagName)
{
    unsigned i = 0;
    for (
        HTMLStackElem* curr = m_blockStack;
        i < cMaxRedundantTagDepth && curr && curr->tagName == tagName;
        curr = curr->next, i++
    ) { }
    return i != cMaxRedundantTagDepth;
}

// no closing 'body' or 'html' tag
// from webkit source:
// Support for really broken HTML.
// We never close the body tag, since some stupid web pages 
// close it before the actual end of the doc.
// Let's rely on the end() call to close things.
if (t->tagName == htmlTag || t->tagName == bodyTag )
    return;
```

## 3.3 CSS parsing
CSS is [context free grammar](https://www.w3.org/TR/css-syntax-3/).

### 3.3.1 WebKit CSS parser
WebKit uses `Flex` and `Bison` parser generators
As you recall from the parser introduction, Bison creates a bottom up shift-reduce parser.  
Firefox uses a top down parser written manually.  
In both cases each CSS file is parsed into a **StyleSheet object**.  
Each object contains CSS rules. The CSS rule objects contain selector and
declaration objects and other objects corresponding to CSS grammar.

![Parsing css](./img/browsers-3-3-12.png)  

## 3.4 The order of processing scripts and style sheets
### 3.4.1 Scripts
We expect the scripts to be executed immediately as `<script>` tag is reached,  
Parsing of document is halted until script is executed.  
If script is external - wait for load and execution.  
HTML5 has `defer` attribute - script will be executed **after document construction ends**.  
Also HTML5 adds option to execute script asyncroniously in separate thread.

### 3.4.2 Speculative parsing
Modern Webkit and Firefox optimization: while executeing script these browsers 
continue parse document, but only search for external resourses and load it.
**DOM tree is not modified by this additional parser**, only load external resources.

### 3.4.3 Style sheets
It seems that style sheets dont modify DOM, but it's a quite common case when
script ask for style properties.  
Firefox blocks all script when not all stylesheets are loaded and parsed.  
Webkit blocks script only when it tries to access styles.

# 4 Render tree construction
The render tree is constructed while the DOM tree is constructed.
The render tree consists of visual elements in the order in which they will be displayed.

**The purpose of this tree** is to enable painting the contents in their correct order.

Firefox calls the elements in the render tree **"frames"**.  
WebKit uses the term **renderer** or **render object**. 

A renderer knows how to lay out and paint itself and its children. 

WebKit's [`RenderObject`](https://github.com/WebKit/webkit/blob/master/Source/WebCore/rendering/RenderObject.h) class:
```c++
// it's old code, see new at link
class RenderObject{
  virtual void layout();
  virtual void paint(PaintInfo);
  virtual void rect repaintRect();
  Node* node;  //the DOM node
  RenderStyle* style;  // the computed style
  RenderLayer* containgLayer; //the containing z-index layer
}
```

Each renderer represents rectangular area, contains geometry information.  
Form controls and tables have special frames.

## 4.1 The render tree relation to the DOM tree
Not all DOM elements have corresponded renderer: `<head>` will not, elements with `display: none` too.
These elements will not be represented at render tree.

Some DOM elements have multiple render objects:  
`<select>` will have 3 object for example, inline text that broken into several lines will
have a renderer for each line (like in PDF).

![DOM tree and render tree](./img/browsers-4-1.png)  
Figure: The render tree and the corresponding DOM tree. 
The "Viewport" is the initial containing block. In WebKit it will be the `RenderView` object

## 4.2 The flow of constructing the tree
In Firefox presentation is registered as listener for DOM updates.

in Webkit process of resolving style and creating renderer is called [`Attachment`](https://github.com/WebKit/webkit/blob/master/Source/WebCore/rendering/RenderAttachment.h)
When node is inserted to DOM, `attach` is called.

The root render (`html`/`body`) object is [`RenderView`](https://github.com/WebKit/webkit/blob/master/Source/WebCore/rendering/RenderView.h).
It's dimensions are the viewport. The rest of the tree is created as DOM node inserted.

## 4.3 Style Computation
Building render tree requires computation of each render object visual props (by calculating
style props for each element).

Style is consisted of:
* style sheets of various origins
* inline style elements
* visual properties in HTML (like `bgcolor` for SVG)

The origins of style-sheets:
* browser's default stylesheets
* stylesheets provided by webpage
* user's stylesheets (by chrome extensions for example)

Difficulties of style computation:
1. Style data is a very large construct.
2. Finding matching selector can cause perf problems.
3. Applying the rules involves conplex cascade rules.

### 4.3.1 Sharing style data
In Webkit node references to [`RenderStyle`](https://github.com/WebKit/webkit/blob/master/Source/WebCore/rendering/style/RenderStyle.h)
objects. Nodes can share on style object if:
1. Nodes are siblings
2. Same mouse state
3. Neither has an id
4. Tag names are same
4. Class attrs are same
5. Set of mapped attrs are identical
6. Link states match.
7. Focus states match.
8. None affected by attribute selector
9. No inline style attribute
10. No sibling selectors at all, in all document (`+`, `:first-child`...)

### 4.3.2 Firefox rule tree
Webkit style objects are not stored in tree, DOM node points to its style.  
Firefox has 2 trees for easier style processing: 

![FF style trees](./img/browsers-4-3-2.png)  

Context contains end values: for example, percent values computed to px.
Rule tree allows to share these values between elements and not compute them again. 

All rules are stored in the tree, bottom nodes have higher priority.
It's constructed lazily: when node style needs to be computed - it's computed and added to tree.


#### 4.3.2.1 Division into structs
#### 4.3.2.2 Computing the style contexts using the rule tree
### 4.3.3 Manipulating the rules for an easy match
### 4.3.4 Applying the rules in the correct cascade order
#### 4.3.4.1 Style sheet cascade order
#### 4.3.4.2 Specificity
#### 4.3.4.3 Sorting the rules
## 4.4 Gradual process

# 5 Layout
## 5.1 Dirty bit system
## 5.2 Global and incremental layout
## 5.3 Asynchronous and synchronous layout
## 5.4 Optimizations
## 5.5 The layout process
## 5.6 Width calculation
## 5.7 Line breaking

# 6 Painting
## 6.1 Global and incremental
## 6.2 The painting order
## 6.3 Firefox display list
## 6.4 WebKit rectangle storage

# 7 Dynamic changes

# 8 The rendering engine's threads
## 8.1 Event loop

# 9 CSS2 visual model
## 9.1 The canvas
## 9.2 CSS box model
## 9.3 Positioning scheme
## 9.4 Box types
## 9.5 Positioning
### 9.5.1 Relative
### 9.5.2 Floats
### 9.5.3 Absolute and fixed
## 9.6 Layered representation

# 10 Resources
