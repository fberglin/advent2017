#!/usr/bin/perl

open($fh, "< 2.input") || die "Unable to open file: $!\n";

@lines = <$fh>;
# @lines = ( "5 9 2 8", "9 4 7 3", "3 8 6 5" );

$checksum = 0;

for $line (@lines) {
  @cols = split(/\s+/, $line);

  ($numerator, $denominator) = findEvenDivision(@cols);

  print "$numerator, $denominator\n";

  $quotient = $numerator / $denominator;

  $checksum += $quotient;
}

print "Checksum: $checksum\n";

sub findEvenDivision(@) {
  for $item1 (@_) {
    for $item2 (@_) {
      if ($item1 % $item2 == 0 && $item1 != $item2) {
        return ($item1, $item2);
      }
    }
  }
}

