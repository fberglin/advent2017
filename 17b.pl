#!/usr/bin/perl

$input = 328;
# $input = 3;

$max = 50000000;
# $max = 2017;

$|++;

$iteration = 0;
$valueAtIndexOne = 0;

foreach $value (1 ... $max) {
  $position = (($position + $input) % $value) + 1;

  if ($position == 1) {
    $valueAtIndexOne = $value;
  }

  $iteration++;
  if ($iteration % 1e6 == 0) {
    print "=: ", $iteration/1e6, "\n";
  } elsif ($iteration % 1e5 == 0) {
    print "+";
  } elsif ($iteration % 1e4 == 0) {
    print "-";
  }
}

print "Value directly after 0: $valueAtIndexOne\n";

