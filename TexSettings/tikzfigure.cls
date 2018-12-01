\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{tikzfigure}[Figure for drawing standalone figures with tikz]

\LoadClass{standalone}

%% Setting up options
\DeclareOption{sans}{\newcommand{\usesans}{true}}
\ProcessOptions\relax

%% Loading additional libraires
\usepackage{tikz}
\usepackage{circuitikz}
\usepackage{fontspec}
\usepackage{unicode-math}
\usepackage{amsmath}
\usepackage{ifthen}

% Setting up font 
\ifcsname usesans \endcsname%
\setmainfont{Nimbus Sans}
\setsansfont{Nimbus Sans}

% Use latin modern for math symbols
\setmathfont{XITS Math} % Using latin modern symbols by default

% Fall back to main font for latin and numerical characters
\setmathfont[range=\mathit/{latin,Latin,greek,Greek,num}]{Nimbus Sans Italic}
\setmathfont[range=\mathup/{latin,Latin,greek,Greek,num}]{Nimbus Sans}
\setmathfont[range=\mathbfup/{latin,Latin,greek,Greek,num}]{Nimbus Sans Bold}
\setmathfont[range=\mathbfit/{latin,Latin,greek,Greek,num}]{Nimbus Sans Bold Italic}
\else%
\usepackage{mathwithlibertine}
\fi%
