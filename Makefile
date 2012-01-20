# from http://mytexpert.sourceforge.jp/index.php?Makefile
# Title: Makefile
# Date:  2004/03/28
# Name:  Thor Watanabe
# Mail:  hakodate12@hotmail.com
# 主となる原稿
FILE=fulltext
# 分割され、インクルードされているファイル
SRC=abstract.tex conclusion.tex differentiable.tex introduction.tex ktimes.tex preliminary.tex acknowledgements.tex 
#スタイルファイルやクラスファイルなど
OHTERS=
# 画像などのバイナリファイル
IMG=
#文献データベース
REF=la.bib
#走らせるTeXプログラム
TEX=platex
BIBTEX=bibtex
# Red Hat の場合
#DVIPS=pdvips
#XDVI=pxdvi
# GNU Linux の場合
#DVIPS=dvips
#XDVI=xdvik
# Windowsの場合
#DVIPS=dvipsk -Pdl -t a4
#XDVI=dviout 
# dvipdfmx
#DVIPDF  =dvipdfmx -p a4 -f dlbase14.map -o $(FILE).pdf 
DVIPDF=dvipdfmx 
# 相互参照の解消のため
REFGREP=grep "^LaTeX Warning: Label(s) may have changed."
# プリンタの設定
#PRINTER=//server/printername
# 標準のターゲット
all: $(FILE).pdf 
# 依存関係にかかわらず作成
force:
	$(TEX) $(FILE)
	$(BIBTEX) $(FILE)
	$(TEX) $(FILE)
	$(TEX) $(FILE)
	$(DVIPDF) $(FILE)
# printps:  $(FILE).ps
#	lpr -P$(PRINTER) $(FILE).ps
# printpdf:  $(PSFILE)
# 	lpr -P$(PRINTER) $(FILE).ps
$(FILE).pdf: $(FILE).dvi
	$(DVIPDF) $(FILE)
# $(FILE).ps: $(FILE).dvi		#
# 	$(DVIPS) -o $(FILE).ps $(FILE)
$(FILE).dvi: $(FILE).aux $(FILE).bbl
	(while $(REFGREP) $(FILE).log; do $(TEX) $(FILE); done)
$(FILE).bbl: $(REF)
	$(BIBTEX) $(FILE)
$(FILE).aux: $(FILE).tex $(SRC)
	$(TEX) $(FILE)
clean:
	rm -f $(FILE).aux $(FILE).log $(FILE).toc $(FILE).dvi 
	rm -f $(FILE).pdf $(FILE).lof $(FILE).lot $(FILE).bbl
open:
	evince fulltext.pdf &
diff:
	git diff --color | nkf | less -r
wc:
	./word-count.pl $(FILE).tex $(SRC)