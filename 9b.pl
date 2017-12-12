#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 9.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

<<EOF
@lines = (
  "{}",
  "{{{}}}",
  "{{},{}}",
  "{{{},{},{{}}}}",
  "{<a>,<a>,<a>,<a>}",
  "{{<ab>},{<ab>},{<ab>},{<ab>}}",
  "{{<!!>},{<!!>},{<!!>},{<!!>}}",
  "{{<a!>},{<a!>},{<a!>},{<ab>}}",
  "<>",
  "<random characters>",
  "<<<<>",
  "<{!>}>",
  "<!!>",
  "<!!!>>",
  '<{o"i!a,<{i<a>'
);
EOF
;

foreach $line (@lines) {
  chomp($line);
  @chars = split(//, $line);

  $depth = 0;
  $ignore = 0;
  $garbage = 0;
  $sum = 0;
  $removed = 0;

  foreach $char (@chars) {
    if ($ignore == 1) {
      $ignore = 0;
      next;
    } elsif ($char eq "!") {
      $ignore = 1;
    } elsif ($char eq ">") {
      $garbage = 0;
    } elsif ($garbage == 1) {
      $removed++;
      next;
    } elsif ($char eq "{") {
      $depth++;
    } elsif ($char eq "}") {
      $sum += $depth;
      $depth--;
    } elsif ($char eq "<") {
      $garbage = 1;
    }
  }

  print "Total sum of all groups: $sum. Removed characters: $removed\n";
}

