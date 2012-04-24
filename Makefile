# from http://mytexpert.sourceforge.jp/index.php?Makefile
# Title: Makefile
# Date:  2004/03/28
# Name:  Thor Watanabe
# Mail:  hakodate12@hotmail.com
# 主となる原稿
FILE=fulltext
# 分割され、インクルードされているファイル
SRC=abstract.tex proof.tex introduction.tex preliminary.tex acknowledgments.tex constructive.tex appendix.tex
IMG=image/divp.eps  image/model-of-function.eps  image/reduction.eps
#文献データベース
REF=la.bib
#走らせるTeXプログラム
TEX=platex --halt-on-error
BIBTEX=bibtex
# EUCへ変換
NKF=nkf -e
# dvipdfmx
DVIPDF=dvipdfmx
# 相互参照の解消のため
REFGREP=grep "^LaTeX Warning: Label(s) may have changed."
.INTERMEDIATE: $(SRC) $(REF)

# 標準のターゲット
all: $(FILE).pdf 

$(FILE).pdf: $(FILE).dvi
	$(DVIPDF) $(FILE)
$(FILE).dvi: $(FILE).aux $(FILE).bbl
	(while $(REFGREP) $(FILE).log; do $(TEX) $(FILE); done)
$(FILE).aux: $(FILE).tex $(SRC) $(IMG)
	$(TEX) $(FILE)
$(FILE).bbl: $(REF)
	$(BIBTEX) $(FILE)
	$(TEX) $(FILE)
	$(TEX) $(FILE)

%.eps: %.svg
	inkscape -z -f $< -E $@

# 依存関係にかかわらず作成
.PHONY: force
force: $(FILE).tex $(SRC) $(REF)
	$(TEX) $(FILE)
	$(BIBTEX) $(FILE)
	$(TEX) $(FILE)
	$(TEX) $(FILE)
	$(DVIPDF) -o $(FILE).pdf $(FILE).dvi

.PHONY: view
view:
	evince fulltext.pdf &

.PHONY: clean
clean:
	rm -f *.aux *.log *.toc *.dvi *.lof *.lot *.bbl *.blg
	rm -f $(FILE).pdf *.euc.tex $(FILE).txt 

