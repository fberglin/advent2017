#!/usr/bin/perl

$input = 328;

# $input = 3;

@list = ( 0 );
$position = 0;

$max = 2017;

foreach $value (1 ... $max) {
  $position = (($position + $input) % @list) + 1;
  splice(@list, $position, 0, $value);
}

( $index ) = grep { $list[$_] == $max } 0 ... $#list;

print "Value directly after $max ($index): $list[$index+1]\n";

