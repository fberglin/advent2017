#!/usr/bin/perl

open($fh, "< 1.input") || die "Unable to open file: $!\n";

@input = <$fh>;
chomp($input[0]);

@digits = split(//, $input[0]);

# @digits = (1, 2, 1, 2);
# @digits = (1, 2, 2, 1);
# @digits = (1, 2, 3, 4, 2, 5);
# @digits = (1, 2, 3, 1, 2, 3);
# @digits = (1, 2, 1, 3, 1, 4, 1, 5);

$sum = 0;
$length = scalar(@digits);

for $i (0 ... $length-1) {
  $leftIndex = $i;
  $rightIndex = ($i + ($length / 2)) % $length;

  $sum += returnValueIfSame($digits[$leftIndex], $digits[$rightIndex]);
}

print "Sum: $sum\n";

sub returnValueIfSame(@) {
  $left = shift;
  $right = shift;

  if ($left == $right) {
    return $left;
  }

  return 0;
}

