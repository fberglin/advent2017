#!/usr/bin/perl

open($fh, "< 2.input") || die "Unable to open file: $!\n";

@lines = <$fh>;
# @lines = ( ( 5, 1, 9, 5 ), ( 7, 5, 3 ), ( 2, 4, 6, 8 ) );
# @lines = ( "5 1 9 5", "7 5 3", "2 4 6 8" );

$checksum = 0;

for $line (@lines) {
  @cols = split(/\s+/, $line);

  $lowest = findLowest(@cols);
  $highest = findHighest(@cols);

  $diff = $highest - $lowest;

  $checksum += $diff;
}

print "Checksum: $checksum\n";

sub findHighest(@) {
  return (sort { $b <=> $a } @_)[0];
}

sub findLowest(@) {
  return (sort { $a <=> $b } @_)[0];
}

