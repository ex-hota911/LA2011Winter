# from http://mytexpert.sourceforge.jp/index.php?Makefile
# Title: Makefile
# Date:  2004/03/28
# Name:  Thor Watanabe
# Mail:  hakodate12@hotmail.com
# 主となる原稿
FILE=fulltext
EFILE=$(FILE).euc
# 分割され、インクルードされているファイル
SRC=abstract.tex proof.tex introduction.tex preliminary.tex acknowledgements.tex constructive.tex
ESRC=$(SRC:%.tex=%.euc.tex)
#文献データベース
REF=la.bib
EREF=$(REF:%.bib=%.euc.bib)
#走らせるTeXプログラム
TEX=platex --halt-on-error
BIBTEX=jbibtex
# \input \include コマンドを解決
RESOLVEINPUT=sed -e s/"\\\\input{\([^}]*\)}"/"\\\\input{\1.euc}"/g -e s/"\\\\include{\([^}]*\)}"/"\\\\include{\1.euc}"/g -e s/"\\\\bibliography{\([^}]*\)}"/"\\\\bibliography{\1.euc}"/g 
# EUCへ変換
NKF=nkf -e
# dvipdfmx
DVIPDF=dvipdfmx
# 相互参照の解消のため
REFGREP=grep "^LaTeX Warning: Label(s) may have changed."
.SUFFIXES: .euc.tex .tex
.INTERMEDIATE: $(ESRC) $(EFILE).tex $(EREF)

# 標準のターゲット
all: $(FILE).pdf 

$(FILE).pdf: $(EFILE).dvi
	$(DVIPDF) -o $(FILE).pdf $(EFILE).dvi
$(EFILE).dvi: $(EFILE).aux $(EFILE).bbl
	(while $(REFGREP) $(EFILE).log; do $(TEX) $(EFILE); done)
$(EFILE).aux: $(EFILE).tex $(ESRC)
	$(TEX) $(EFILE)
$(EFILE).bbl: $(EREF)
	$(BIBTEX) $(EFILE)
	$(TEX) $(EFILE)
	$(TEX) $(EFILE)

%.euc.bib: %.bib
	$(NKF) $< > $@

%.euc.tex: %.tex
	$(RESOLVEINPUT) $< | $(NKF) > $@

# 依存関係にかかわらず作成
.PHONY: force
force: $(EFILE).tex $(ESRC) $(EREF)
	$(TEX) $(EFILE)
	$(BIBTEX) $(EFILE)
	$(TEX) $(EFILE)
	$(TEX) $(EFILE)
	$(DVIPDF) -o $(FILE).pdf $(EFILE).dvi

.PHONY: view
view:
	evince fulltext.pdf &

.PHONY: clean
clean:
	rm -f *.aux *.log *.toc *.dvi *.lof *.lot *.bbl *.blg
	rm -f $(FILE).pdf *.euc.tex $(FILE).txt 

