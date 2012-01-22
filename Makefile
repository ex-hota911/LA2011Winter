 # from http://mytexpert.sourceforge.jp/index.php?Makefile
# Title: Makefile
# Date:  2004/03/28
# Name:  Thor Watanabe
# Mail:  hakodate12@hotmail.com
# 主となる原稿
FILE=fulltext
EFILE=fulltext.euc
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
# \input \include コマンドを解決
INPUTSED=sed -e s/"\\\\input{\([^}]*\)}"/"\\\\input{\1.euc}"/g -e s/"\\\\include{\([^}]*\)}"/"\\\\include{\1.euc}"/g
# 空白を除去
REMOVESPACES=sed -e "s/ //g" -e "/^$$/d"
# EUCへ変換
NKF=nkf -e
# dvipdfmx
DVIPDF=dvipdfmx 
# 相互参照の解消のため
REFGREP=grep "^LaTeX Warning: Label(s) may have changed."
# プリンタの設定
#PRINTER=//server/printername
.SUFFIXES: .euc.tex .tex
.PRECIOUS: $(FILE).euc.bbl $(FILE).euc.aux

# 標準のターゲット
all: $(FILE).pdf 
# 依存関係にかかわらず作成
.PHONEY: force
force: $(EFILE).tex $(SRC)
	$(TEX) $(EFILE)
	$(BIBTEX) $(EFILE)
	$(TEX) $(EFILE)
	$(TEX) $(EFILE)
	$(DVIPDF) -o $(FILE).pdf $(EFILE).dvi

$(FILE).pdf: $(EFILE).dvi
	$(DVIPDF) -o $(FILE).pdf $(EFILE).dvi
$(EFILE).dvi: $(EFILE).aux $(EFILE).bbl
	(while $(REFGREP) $(EFILE).log; do $(TEX) $(EFILE); done)
$(EFILE).bbl: $(REF)
	$(BIBTEX) $(EFILE)
	$(TEX) $(EFILE)
	$(TEX) $(EFILE)
$(EFILE).aux: $(EFILE).tex $(SRC)
	$(TEX) $(EFILE)
%.euc.tex: %.tex
	$(INPUTSED) $< |$(NKF) > $@

$(FILE).txt: $(FILE).pdf
	pdftotext $(FILE).pdf 
$(WCLOG): $(FILE).txt
	$(REMOVESPACES) $(FILE).txt | tr -d \\n | wc -m > $(WCLOG)
	cat $(WCLOG)

view:
	evince fulltext.pdf &
clean:
	rm -f *.aux *.log *.toc *.dvi $(FILE).txt *.blg
	rm -f *.pdf *.lof *.lot *.bbl $(WCLOG) *.euc.tex
