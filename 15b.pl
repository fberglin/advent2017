#!/usr/bin/perl

<<INPUT
Generator A starts with 618
Generator B starts with 814
INPUT
;

$genInputA = 618;
$genInputB = 814;

# $genInputA = 65;
# $genInputB = 8921;

$genFactorA = 16807;
$genFactorB = 48271;

$divisor = 2147483647;

@genListA = ();
@genListB = ();

$wantedMatches = 5000000;

$iteration = 0;
$|++;

# for (1 ... 5) {
while (1) {
  $iteration++;

  $genValueA = ($genInputA * $genFactorA) % $divisor;
  $genValueB = ($genInputB * $genFactorB) % $divisor;

  $genInputA = $genValueA;
  $genInputB = $genValueB;

  if ($genInputA % 4 == 0) {
    push(@genListA, $genInputA);
  }

  if ($genInputB % 8 == 0) {
    push(@genListB, $genInputB);
  }

  if ($iteration % 1000000 == 0) {
    print "+";
  }

  if (@genListA >= $wantedMatches and @genListB >= $wantedMatches) {
    print "| $iteration";
    last;
  }
}

print "\n";

foreach $index (0 ... $wantedMatches) {
  $binA = sprintf("%032b", $genListA[$index]);
  $binB = sprintf("%032b", $genListB[$index]);

  if (substr($binA, 16, 16) eq substr($binB, 16, 16)) {
    # print "Found match [", $index+1, "]:\n$binA\n$binB\n\n";
    $count++;
  }
}

print "Final count: $count\n";

