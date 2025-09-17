# Appunti — Elementi di Informatica Teorica (LuaLaTeX)

Progetto LaTeX pronto all'uso per scrivere appunti con **blocchi tipografici** (Definizioni, Teoremi, Lemmi, ecc.), **liste automatiche**, **numerazione centralizzata**, **titolo di Dimostrazione leggibile** e **build** semplice via `make`.

---

## 🔧 Requisiti

### Sistema consigliato

* **Linux / WSL / macOS**: consigliato.
* **Windows**: funziona, ma senza `rsync` il Makefile non copierà la cartella `res` (vedi FAQ).

### Software

* **TeX Live** con LuaLaTeX (o MacTeX / MiKTeX).
* **make** (già presente su Linux/macOS; su Windows usa WSL o Git Bash).
* **rsync** (Linux/macOS; opzionale su Windows).

### Pacchetti LaTeX (già inclusi in TeX Live "full")

* `fontspec`, `polyglossia`, `hyperref`, `geometry`, `xcolor`, `graphicx`
* `amsmath`, `amssymb`, `amsthm`, `mathtools`
* `tcolorbox` (con librerie theorems/skins/breakable), `tikz` (librerie `automata,positioning,arrows.meta`)
* `titlesec`, `tocloft`, `fancyhdr`
* `listings`

### Installazione per neofiti

#### Debian/Ubuntu
```bash
sudo apt install texlive-full make rsync
```

Oppure, per un'installazione più leggera:
```bash
sudo apt install texlive-luatex texlive-latex-recommended texlive-latex-extra texlive-fonts-extra texlive-lang-italian make rsync
```

#### Arch Linux
Su Arch i pacchetti TeX Live sono suddivisi. Per avere LuaLaTeX funzionante con i font Latin Modern installa almeno:
```bash
sudo pacman -S texlive-basic texlive-latex texlive-latexrecommended texlive-fontsrecommended make rsync
```

Poi aggiorna la cache dei font:
```bash
luaotfload-tool -u
```

---

## 📁 Struttura del progetto

```
.
├── build/                 # output compilazione (PDF, ausiliari, risorse copiate)
├── chapters/              # capitoli (sorgenti .tex)
├── res/                   # immagini e loghi (copiati automaticamente in build/)
├── sources/               # preambolo e blocchi tipografici
│   ├── preamble.tex
│   └── blocks.tex
├── main.tex               # documento principale
└── Makefile               # build automation (3 pass)
```

---

## 🔨 Compilazione

### Metodo consigliato (Makefile)

```bash
make            # compila in build/main.pdf
make clean      # pulisce la cartella build/
```

Il Makefile:

* esegue **3 pass** di LuaLaTeX (TOC e riferimenti sempre corretti);
* copia `res/` in `build/res/`;
* usa flag **-file-line-error -halt-on-error** per messaggi chiari.

### Alternativa (latexmk)

Se preferisci:

```bash
latexmk -lualatex -outdir=build main.tex
```

---

## ✍️ Come si scrive

### Capitoli

Aggiungi un nuovo capitolo in `chapters/` (es. `chapter3.tex`) e includilo in `main.tex`:

```tex
\input{chapters/chapter3.tex}
```

### Blocchi tipografici (tcolorbox)

Gli ambienti sono **numerati** e richiedono **titolo** e **chiave** (per i riferimenti).

> La **chiave** diventa l'etichetta: `thm:<chiave>`, `def:<chiave>`, ecc.

```tex
\begin{definizione}{Alfabeto}{alfabeto}
Testo della definizione...
\end{definizione}

\begin{teorema}{Chomsky}{chomsky}
Ogni grammatica regolare genera un linguaggio regolare.
\end{teorema}
```

**Riferimenti nel testo** (manuali, semplici):

```tex
Vedi Teorema~\ref{thm:chomsky} e Definizione~\ref{def:alfabeto}.
```

#### Versioni *senza numero*

Usa la **stellina** e **solo il titolo** (niente chiave):

```tex
\begin{teorema*}{Teorema non numerato}
...
\end{teorema*}
```

#### Dimostrazione (titolo leggibile)

Titolo opzionale tra `[...]`; i link nel titolo sono **bianchi** (leggibili sullo sfondo blu scuro):

```tex
\begin{dimostrazione}[del Teorema~\ref{thm:chomsky}]
Schizzo della prova...
\end{dimostrazione}
```

#### Altri blocchi disponibili

**Numerati**: `lemma`, `proposizione`, `corollario`, `assioma`, `esempio`, `esercizio`

**Box informativi** (non numerati): `nota{Titolo}`, `attenzione{Titolo}`, `suggerimento{Titolo}`

---

## 🔢 Numerazione centralizzata (sezione vs capitolo)

La numerazione degli ambienti (teoremi, definizioni, ecc.) è controllata da **una sola riga** in `sources/blocks.tex`:

```tex
\providecommand{\tcbwithin}{section}  % default
% Per numerare per capitolo:
% \renewcommand{\tcbwithin}{chapter}
```

Cambia `section` in `chapter` e **tutti** i blocchi seguiranno quel criterio.

---

## 📋 Indici e Liste

In `main.tex` trovi:

```tex
\tableofcontents
\listofteorema
\listofdefinizione
```

I **wrapper** (`\listofteorema`, `\listofdefinizione`, ecc.) stampano una **lista globale** e la **aggiungono all'Indice (ToC)**.

**Liste disponibili**: `\listoflemma`, `\listofproposizione`, `\listofcorollario`, `\listofassioma`, `\listofesempio`, `\listofesercizio`.

> **Nota**: le liste sono **globali** per l'intero documento (comportamento standard di tcolorbox). Se vuoi liste **per capitolo** servono macro ad hoc (non incluse di default).

---

## 🎨 Stile e Font

### Colori istituzionali

Modificabili in `sources/preamble.tex`:

```tex
\definecolor{uninaPrimary}{HTML}{1B415D}   % blu
\definecolor{uninaSecondary}{HTML}{D93C24} % rosso
```

### Font (con fallback automatici)

* **Serif**: **Libertinus Serif** → fallback **Latin Modern Roman**
* **Sans**: **Libertinus Sans** → fallback **Latin Modern Sans**  
* **Mono**: **JetBrains Mono** → fallback **Fira Code** → fallback **Latin Modern Mono**

Se non hai i font opzionali installati, verranno usati i fallback: il build **non fallisce**.

---

## 🛠️ Pacchetti utili già pronti

### TikZ per automi e grafi

```tex
\begin{tikzpicture}[auto, on grid]
  \node[state, initial]   (q0) {$q_0$};
  \node[state, accepting] (q1) [right=of q0] {$q_1$};
  \path[->]
    (q0) edge[bend left] node {a} (q1)
    (q1) edge[bend left] node {b} (q0);
\end{tikzpicture}
```

### Listings per codice

```tex
\begin{lstlisting}[language=C, caption={Esempio C}, label={lst:ciao}]
#include <stdio.h>
int main(){ printf("Ciao!\n"); }
\end{lstlisting}
```

---

## 📝 Convenzioni utili

### Label dei blocchi

Usa la chiave subito nel `\begin{...}{Titolo}{chiave}` (non usare `\label{...}` dentro al box).

### Riferimenti

Usa i prefissi coerenti:

* `thm:chiave`, `def:chiave`, `lem:chiave`, `prop:chiave`, `cor:chiave`, `axs:chiave`
* `ex:chiave` (esempio), `exr:chiave` (esercizio)

### Immagini

Mettile in `res/` e includile così:

```tex
\includegraphics[width=0.28\textwidth]{res/uni_logo.pdf}
```

---

## 🔧 Risoluzione problemi (FAQ)

### 1) "No file main.toc / main.teorema / main.definizione"
Normale alla **prima** compilazione. Il Makefile fa 3 pass: si sistema da solo. Se persiste, esegui `make clean && make`.

### 2) "Environment `*` already defined"
Non creare manualmente ambienti "stellati". Con tcolorbox, la forma `\begin{teorema*}{Titolo}` esiste **già**.

### 3) Link blu nel titolo della Dimostrazione
Già sistemato: nel titolo della box i link sono **bianchi**; nel corpo restano blu.

### 4) Logo/immagini non trovate
Controlla il percorso: deve essere sotto `res/`. Il Makefile copia `res/` in `build/res/`.

### 5) Windows senza `rsync`

* **Soluzione rapida**: installa **Git Bash** (include `rsync`) o WSL.
* **Oppure**: commenta la riga `rsync` nel Makefile e copia manualmente `res/` in `build/`.

### 6) Lingua/accenti
Usiamo `polyglossia` con `\setmainlanguage{italian}`: sillabazione e date in italiano.

### 7) Riferimenti "undefined"
Compila almeno **due volte** (il Makefile ne fa 3). Se rimane, verifica di aver usato la **chiave** corretta e il **prefisso** giusto (`thm:`, `def:`, …).

---

## ⚙️ Personalizzazione rapida

### Numerazione per capitolo

```tex
% in sources/blocks.tex
\renewcommand{\tcbwithin}{chapter}
```

### Aggiungere capitoli

Crea `chapters/chapterN.tex` e aggiungi in `main.tex`:

```tex
\input{chapters/chapterN.tex}
```

### Aggiungere una nuova "famiglia" di blocco

Per esempio "Osservazione": duplica uno dei `\NewTcbTheorem` in `sources/blocks.tex` cambiando colore, nome e **prefisso label** (ultimo argomento).

---

## 📖 Esempio minimo di blocchi

```tex
\chapter{Esempi}

\section{Blocchi base}

\begin{definizione}{Alfabeto}{alfabeto}
Un alfabeto è un insieme finito e non vuoto di simboli, denotato con $\Sigma$.
\end{definizione}

\begin{teorema}{Chomsky}{chomsky}
Ogni grammatica regolare genera un linguaggio regolare.
\end{teorema}

\begin{dimostrazione}[del Teorema~\ref{thm:chomsky}]
Idea della prova...
\end{dimostrazione}

Vedi anche Definizione~\ref{def:alfabeto}.
```

---

## 🔄 Build riproducibile

* **Output**: `build/main.pdf`
* **Risorse replicate**: `build/res/`
* **Compilatore**: **LuaLaTeX** (compatibile con `fontspec` e `polyglossia`)
* **Flag utili attivi**: `-file-line-error -halt-on-error`

---

## 💡 Consigli finali

* Usa un editor con integrazione LaTeX (VS Code + *LaTeX Workshop*, TeXstudio, TeXmaker).
* Commita spesso: LaTeX è testuale, il diff è prezioso.
* Mantieni i concetti in **blocchi**; migliora leggibilità e si autoindicizzano nelle "Liste".
