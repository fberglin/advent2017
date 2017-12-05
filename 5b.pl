#!/usr/bin/perl

open($fh, "< 5.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

# @lines = ( 0, 3, 0, 1, -3 );

$tries = 0;
$index = 0;

while (defined($lines[$index])) {
  # print "$index: $lines[$index]\n";
  $jump = $lines[$index];
  if ($jump >= 3) {
    $lines[$index]--;
  } else {
    $lines[$index]++;
  }
  $index += $jump;
  $tries++;
}

print "It took " , $tries , " steps to escape the list\n";

