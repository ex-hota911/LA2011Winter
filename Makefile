# from http://mytexpert.sourceforge.jp/index.php?Makefile
# Title: Makefile
# Date:  2004/03/28
# Name:  Thor Watanabe
# Mail:  hakodate12@hotmail.com
# 主となる原稿
FILE=fulltext
EFILE=fulltext.euc
# 分割され、インクルードされているファイル
SRC=abstract.euc.tex conclusion.euc.tex differentiable.euc.tex introduction.euc.tex preliminary.euc.tex acknowledgements.euc.tex 
#スタイルファイルやクラスファイルなど
OHTERS=
# 画像などのバイナリファイル
IMG=
# 文字数
WCLOG=wc
#文献データベース
REF=la.euc.bib
#走らせるTeXプログラム
TEX=platex --halt-on-error
BIBTEX=jbibtex
# \input \include コマンドを解決
RESOLVEINPUT=sed -e s/"\\\\input{\([^}]*\)}"/"\\\\input{\1.euc}"/g -e s/"\\\\include{\([^}]*\)}"/"\\\\include{\1.euc}"/g -e s/"\\\\bibliography{\([^}]*\)}"/"\\\\bibliography{\1.euc}"/g 
# 空白を除去
REMOVESPACES=sed -e "s/ //g" -e "/^$$/d"
# EUCへ変換
NKF=nkf -e
# dvipdfmx
DVIPDF=dvipdfmx
# 相互参照の解消のため
REFGREP=grep "^LaTeX Warning: Label(s) may have changed."
# 禁止ワード
CENSORED=対して\|示す
# プリンタの設定
#PRINTER=//server/printername
.SUFFIXES: .euc.tex .tex
#.PRECIOUS: $(FILE).euc.bbl $(FILE).euc.aux
.INTERMEDIATE: $(SRC) $(EFILE).tex $(REF)

# 標準のターゲット
all: $(FILE).pdf $(WCLOG)
# 依存関係にかかわらず作成
.PHONY: force
force: $(EFILE).tex $(SRC) $(REF)
	$(TEX) $(EFILE)
	$(BIBTEX) $(EFILE)
	$(TEX) $(EFILE)
	$(TEX) $(EFILE)
	$(DVIPDF) -o $(FILE).pdf $(EFILE).dvi
	pdftotext $(FILE).pdf 
	$(REMOVESPACES) $(FILE).txt | tr -d \\n | wc -m > $(WCLOG)
	cat $(WCLOG)

$(FILE).pdf: $(EFILE).dvi
	$(DVIPDF) -o $(FILE).pdf $(EFILE).dvi
$(EFILE).dvi: $(EFILE).aux $(EFILE).bbl
	(while $(REFGREP) $(EFILE).log; do $(TEX) $(EFILE); done)
$(EFILE).aux: $(EFILE).tex $(SRC)
	$(TEX) $(EFILE)

$(EFILE).bbl: $(REF)
	$(BIBTEX) $(EFILE)
	$(TEX) $(EFILE)
	$(TEX) $(EFILE)

%.euc.bib: %.bib
	$(NKF) $< > $@

%.euc.tex: %.tex
	$(RESOLVEINPUT) $< | $(NKF) > $@

$(FILE).txt: $(FILE).pdf
	pdftotext $(FILE).pdf 
$(WCLOG): $(FILE).txt
	$(REMOVESPACES) $(FILE).txt | tr -d \\n | wc -m > $(WCLOG)
	cat $(WCLOG)

.PHONY: view
view:
	evince fulltext.pdf &

.PHONY: clean
clean:
	rm -f *.aux *.log *.toc *.dvi *.lof *.lot *.bbl *.blg
	rm -f $(FILE).pdf $(WCLOG) *.euc.tex $(FILE).txt 

.PHONY: check
check:
	grep -n --color=always '$(CENSORED)' *.tex
	grep -n --color=always '$(CENSORED)' *.tex


