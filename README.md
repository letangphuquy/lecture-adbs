# lectures-dbms

Lecture slides for **COMP5330 Advanced Database Systems** (VinUniversity), written in LaTeX Beamer with a theme that follows the VinUni slide guideline: navy `#1F4983` and red `#C72027`, Montserrat titles, Lato body text, a red title triangle, a red footer rule and the campus-photo title slide.

## Layout

```
lectures-dbms/
├── theme/
│   ├── beamerthemeVinUni.sty        # the theme: colours, fonts, title/section/closing slides, macros
│   └── assets/                      # VinUni backgrounds and logos (from the official template)
├── week05-query-evaluation-optimisation/
│   ├── main.tex                     # metadata + \input of each section
│   ├── sections/
│   │   ├── 00-opening.tex           # Lesson plan §0  (Act 0)
│   │   ├── 01-l13-processing-models.tex
│   │   ├── 02-l14-plan-space.tex
│   │   ├── 03-l15-plan-space-example.tex
│   │   ├── 04-wrap-up.tex
│   │   └── 99-style-examples.tex    # appendix: copy-paste layout examples
│   └── figures/
├── templates/new-week/              # skeleton for the next week
├── build.ps1                        # Windows build script
├── build.sh                         # POSIX sh build script (Linux / macOS / Git Bash)
└── Makefile                         # make wrapper around build.sh
```

Week 5 follows the outline of `ADB_Week5/Week5_LessonPlan_EN.md` (with matching `_VI.md`). Every section and frame title is there already. Frame bodies are `\placeholder{...}` boxes that say what goes on the slide and which source slides to use, e.g. `[L13, s.3]`.

## Build

You need a TeX distribution (MiKTeX or TeX Live) with `latexmk`. The packages used are `lato`, `montserrat`, `inconsolata`, `fontawesome5` and `tcolorbox`.

| Task | Windows (PowerShell) | Linux / macOS / Git Bash | make |
|---|---|---|---|
| Build all weeks | `.\build.ps1` | `./build.sh` | `make` |
| Build one week | `.\build.ps1 week05` | `./build.sh week05` | `make week05` |
| Rebuild on save | `cd week05-*; latexmk -pvc` | `cd week05-*/ && latexmk -pvc` | `make watch W=week05` |
| Remove build output | `.\build.ps1 -Clean` | `./build.sh --clean` | `make clean` |
| New week from template | `Copy-Item -Recurse templates\new-week week06-<topic>` | `./build.sh --new week06-<topic>` | `make new W=week06-<topic>` |

The PDF is written to `<week>/build/main.pdf`. You can also run `latexmk` inside a week folder. To leave out the appendix, set `\showexamplesfalse` in `main.tex`.

`.gitattributes` keeps `build.sh` and `Makefile` on LF line endings, so they still work after a Windows checkout.

## Writing slides: cheat sheet

| What | How |
|---|---|
| Section divider (navy, automatic) | `\sectionsubtitle{...}` then `\section{...}` |
| Bullets / numbered lists | `itemize` / `enumerate`; `[<+->]` reveals one item per click |
| Two columns | `\begin{columns}[T] \column{0.48\textwidth} ... \end{columns}` |
| Figure | put the file in `figures/`, then `\includegraphics[width=\linewidth]{name}` |
| Figure not ready | `\figplaceholder[width]{height}{label}` |
| Text not ready | `\placeholder{what goes here}` |
| Source tag | `\src{L14}{17}` → `[L14, s.17]` |
| Callouts | `keybox` (key idea), `notebox` (⚠️ precision note), `extrabox` (🧩 extra) |
| Relational algebra | `\sel{c}`, `\proj{a}`, `\njoin[p]`, `\cross` |
| Code | `lstlisting` (SQL is the default, or `[language=pseudo]`); the frame needs `[fragile]` |
| Speaker notes | `\note[item]{...}` inside a frame; `.\build.ps1 week05 -Notes` (or `./build.sh --notes week05`, `make notes W=week05`) builds `build/main-notes.pdf` with only the slides that have notes, each followed by its notes page |
| Title / closing slide | `\vinuTitleFrame`, `\vinuClosingFrame{Thank you!}{Questions?}` |

You'll find a working example of each of these in `sections/99-style-examples.tex`.

## Adding a new week

Use the "New week from template" command in the table above. Then edit `main.tex` (title, footer) and add the section files.
