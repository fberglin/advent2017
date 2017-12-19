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

$iteration = 0;

$|++;

# for (1 ... 5) {
for (1 ... 40000000) {
  $iteration++;

  $genValueA = ($genInputA * $genFactorA) % $divisor;
  $genValueB = ($genInputB * $genFactorB) % $divisor;

  $genInputA = $genValueA;
  $genInputB = $genValueB;

  # print "$genInputA = $genValueB\n";

  $binA = sprintf("%032b", $genInputA);
  $binB = sprintf("%032b", $genInputB);

  if (substr($binA, 16, 16) eq substr($binB, 16, 16)) {
    print "*";
    $count++;
  }

  if ($iteration % 1000000 == 0) {
    print "|";
  }
}

print "\n";
print "Final count: $count\n";

