# from http://mytexpert.sourceforge.jp/index.php?Makefile
# Title: Makefile
# Date:  2004/03/28
# Name:  Thor Watanabe
# Mail:  hakodate12@hotmail.com
# 主となる原稿
FILE=fulltext
# 分割され、インクルードされているファイル
SRC=abstract.euc.tex conclusion.euc.tex differentiable.euc.tex introduction.euc.tex ktimes.euc.tex preliminary.euc.tex acknowledgements.euc.tex 
#スタイルファイルやクラスファイルなど
OHTERS=
# 画像などのバイナリファイル
IMG=
# 文字数
WCLOG=wc
#文献データベース
REF=la.bib
#走らせるTeXプログラム
TEX=platex
BIBTEX=bibtex
# UTF8 -> EUC
NKF=nkf -e
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
.SUFFIXES: .euc.tex .tex

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
$(FILE).pdf: $(FILE).euc.pdf
	cp $(FILE).euc.pdf $(FILE).pdf
%.pdf: %.dvi
	$(DVIPDF) $*

# $(FILE).ps: $(FILE).dvi		#
# 	$(DVIPS) -o $(FILE).ps $(FILE)
%.dvi: %.aux %.bbl
	(while $(REFGREP) $*.log; do $(TEX) $*; done)
%.bbl: $(REF)
	$(BIBTEX) $*
%.aux: %.tex $(SRC)
	$(TEX) $*
%.euc.tex: %.tex
	sed -e s/"\\\\input{\([^}]*\)}"/"\\\\input{\1.euc}"/g -e s/"\\\\include{\([^}]*\)}"/"\\\\include{\1.euc}"/g $< > $*.tmp
	$(NKF) $*.tmp > $@
	rm $*.tmp
clean:
	rm -f *.aux *.log *.toc *.dvi $(FILE).txt *.blg
	rm -f *.pdf *.lof *.lot *.bbl $(WCLOG) *.euc.tex
view:
	evince fulltext.pdf &
diff:
	git diff --color | nkf | less -r
$(FILE).txt: $(FILE).pdf
	pdftotext $(FILE).pdf 
$(WCLOG): $(FILE).txt
	sed -e "s/ //g" -e "/^$$/d" $(FILE).txt | tr -d \\n | wc -m > $(WCLOG)
	cat $(WCLOG)
