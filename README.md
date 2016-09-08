# Entrepreneurship and Wealth Generation in Socially Structured Economies

## 1 About

This directory contains a set of TeX files which, when compiled into a PDF, forms my PhD thesis for [Queen's Management School](http://www.qub.ac.uk/mgt/). The thesis, better stated as a monograph, is entitled **Entrepreneurship and Wealth Generation in Socially Structured Economies**. It provides an analysis of entrepreneurship within a network-institutional framework of the economy, which we view under a _relational perspective_. 

In order to investigate entrepreneurship and the entrepreneurial function within the relational perspective we create a theory of entrepreneurial activity, as well as a set of game-theoretic and statistical tools to analyse empirical data. Most of the statistical measures developed are contained within this repository. So too are the empirical and synthetic data used throughout the monograph. Below we provide the monograph abstract and instructions for compiling the TeX files.

The primary supervisor for this monograph is [Professor Robert P. Gilles](http://pure.qub.ac.uk/portal/en/persons/rob-gilles(7284b4f5-80a4-4305-ab45-1510f0c2e9f9).html) and the secondary supervisor is [Dr. Graham Brownlow](http://pure.qub.ac.uk/portal/en/persons/graham-brownlow(50d55769-7b1e-480c-b551-fb5cf4725e15).html). Both supervisors are academic faculty members of Queen's Management School. I am immensely thankful to both for their guidance and encouragement throughout this process.

### 1.1 Abstract

This monograph develops and assesses the notion of entrepreneurship and the entrepreneurial function within a relational perspective of economic interaction. We quote the abstract of the monograph below.

> Academic economists and economic practitioners have recognised the need for a pragmatic reform of the economics discipline, particularly since the impact of the 2008 global financial crisis. Many also recognise the requirement for a cohesive perspective on issues regarding the entrepreneur and entrepreneurship within a micro- and macroeconomic framework. This monograph addresses--and contributes a potential resolve to--both issues. In doing so we provide an insight into the methodological basis of a relational perspective of social and economic activity through the structure and evolution of the social division of labour propagated by the actions of entrepreneurs. Of specific interest is the emergence of new specialisations, the modification of institutions, the generation of wealth and exploitation of positional power by entrepreneurial leaders.
>
> Theoretical development of the relational perspective is founded on a number of axioms and hypotheses derived from observations in economics, sociology, psychology, and evolutionary anthropology. From this, we elaborate, in a formal manner, on the inherent sociality of the individual economic agent and the production possibilities that are subjected to increasing returns to specialisation. The structure of each individuals' production set facilitates the specialisation into a set of professions, or socio-economic roles, that become embedded within the institutional fabric of society. Interaction infrastructures form as a consequence of the social and economic interaction between economic agents.
>
> The formation interaction infrastructures lead to an uneven distribution of positional power within the matrix of relationships. Unique positional attributes of economic agents are reflected in entrepreneurial action and the exploitation of power in connecting, and potentially disconnecting, otherwise unconnected agents and communities. We investigate entrepreneurship in this way: through an institutional and topological perspective. Specifically, entrepreneurship motivates the evolution of the division of labour through the formation of new socio-economic roles; this, in turn, suggests an alteration of networked institutional infrastructure and the formation of unique positions in the matrix occupied by entrepreneurs.
>
> Throughout the monograph we justify the claim that entrepreneurs can be represented as middlemen within a network-institutional perspective of economic activity. This is investigated further in both a philosophical and formal manner. We develop a set of statistical tools to investigate the positional power of middlemen and apply the resulting measures to situations of disruptive entrepreneurial activity. Empirical applications include the elite Florentine marriage network of Renaissance Florence, the network of 9/11 terrorists and the interlocking directorate network of New York City during the early twentieth century. By providing a new perspective and analytics this empirical analysis provides a new insight into cases within economic history literature.

### 1.2 Contributions

The monograph provides a number of theoretical and empirical contributions to the economics discipline.

* We develop a relational perspective of economic activity. This is a perspective that stresses the social opportunities and constraints that derive from the embeddedness of economic agents within an accepted system of governance.

* The development of the relational perspective embraces the notion of increasing returns to specialisation. We elaborate on the fundamental modelling tools used to define the economic agent based on increasing returns to specialisation and the development of socio-economic roles.

* We show that, given a population of economic agents and a set of socially recognised socio-economic roles, exchange networks form. The structure of the exchange networks depend on the institutions and governance systems present in the economy.

* When developing the relational perspective we elaborate on a connection between the notion of a middleman and the notion of an entrepreneur. From this we develop methods to identify middlemen within topological structures and measures of their power.

* We provide analysis of unique empirical datasets where the exercise of power and entrepreneurial activity is present. These empirical datasets include the analysis of elite Florentine marriages and New York City company directors.

## 2 Compiling the monograph

The latest PDF should have already been compiled and uploaded to the repository. If the latest PDF has not been compiled, or to make changes and compile yourself, you must have a LaTeX executable installed on your system. 

* For Windows I suggest using [MiKTex](http://miktex.org/download),
* For Mac OSX I suggest using [MacTeX](https://tug.org/mactex/), and
* For Ubuntu Linux I suggest using [TeX Live](https://help.ubuntu.com/community/LaTeX).

The entire monograph can be generated into a PDF format by compiling the TeX body file `00EntrepreneurshipSSE.tex` as normal. This file pulls in all Parts and Chapters of the monograph, which are written as separate TeX files.

## 3 Statistical code and visualisation tools

We provide a number of functions written in `R` and `Matlab` programming languages that were used in conjunction with the mathematical tools developed in the monograph. The functions written in `R` were used for network, hypergraph and statistical analysis and the scripts written in `Matlab` were used for simulations of economic interactions and the growth of the socio-economic space. Some data, which was also used throughout the monograph, has been provided to test the tools on. These functions can be found in the `Code` directory.

### 3.1 Network visualisation

The `igraph` package for both `R` and `Python` is a great tool for visualising network data. Information on the `igraph` package can be found [here](http://igraph.org/redirect.html). However, all networks, and some of the analysis, were rendered with the `Gephi` software package which can be found [here](https://gephi.org/). I created a wrapper for `Gephi` such that data generated in `R` could be passed between it and `Gephi`.

## 4 Contact

Please contact [me](mailto:sims.owen@gmail.com) with regards any issues or queries that you have.