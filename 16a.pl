#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 16.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

@programs = ("a" ... "p");
@moves = split(/,/, $lines[0]);

# @programs = ("a" ... "e");
# @moves = ("s1", "x3/4", "pe/b");

foreach $move (@moves) {
  if ($move =~ /s(\d+)/) {
    # Spin

    @temp = splice(@programs, scalar(@programs)-$1, $1);
    @programs = (@temp, @programs);
  } elsif ($move =~ m!x(\d+)/(\d+)!) {
    # Exchange

    $temp = $programs[$1];
    $programs[$1] = $programs[$2];
    $programs[$2] = $temp;
  } elsif ($move =~ m!p(\w+)/(\w+)!) {
    # Partner

    ( $indexProgram1 ) = grep { $programs[$_] eq $1 } 0 ... $#programs;
    ( $indexProgram2 ) = grep { $programs[$_] eq $2 } 0 ... $#programs;

    $temp = $programs[$indexProgram1];
    $programs[$indexProgram1] = $programs[$indexProgram2];
    $programs[$indexProgram2] = $temp;
  }
}

print "Order after dance: ", @programs, "\n";

