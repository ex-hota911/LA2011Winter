#!/usr/bin/perl -w

open( OUT, "| wc -c > wc; cat wc" );
while ( $#ARGV >= 0 ) {
    my $file = shift @ARGV;
    open( IN, "<$file" );
    while (<IN>) {
	if ( /begin/ && /jabstract/ ) {
	    do { $_ = <IN>; } while (!( /end/ && /jabstract/ ));
	}
	s/\%.*//g;  # comment out
	s/\\[^\s\{]*\{[^\}]*\}//g;  # \begin{center}
	s/\\[^\s]*//g;  # \alpha
	s/\[[^\]]*\]//g;  # \begin{figure}[htb]
	s/\_[^\s]+//g;
	s/\^[^\s]+//g;
	s/[:\!\~]+//g;
	s/[\{\}\&\$\-\+\(\)=<>\.\,\[\]]+/ /g;
	print OUT;
    }
    close( IN );
}
close( OUT );
