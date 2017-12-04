#!/usr/bin/perl

open($fh, "< 1.input") || die "Unable to open file: $!\n";

@input = <$fh>;
chomp($input[0]);

@digits = split(//, $input[0]);

# @digits = (1, 1, 2, 2);
# @digits = (1, 1, 1, 1);
# @digits = (9, 1, 2, 1, 2, 1, 2, 9);

$sum = 0;
for $i (0 ... scalar(@digits)-1) {
  if ($i == scalar(@digits)-1) {
    $sum += returnValueIfSame($digits[$i], $digits[0]);
  } else {
    $sum += returnValueIfSame($digits[$i], $digits[$i+1]);
  }
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
