#!/usr/bin/perl

open($fh, "< 6.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

@input = split(/\s+/, $lines[0]);
# @input = ( 0, 2, 7, 0 );

$key = join(",", @input);
print ">> $key\n";

$iterations = 0;
%allocation = ( $key => 0 );

while (1) {
  $iterations++;

  ($highestIndex, $highestValue) = findHighestValue(@input);

  $key = join(",", @input);
  print "$iterations: $key: $highestIndex: $highestValue\n";

  # print "High: $highestIndex, $highestValue\n";

  $input[$highestIndex] = 0;
  $nextIndex = $highestIndex;

  for (1 ... $highestValue) {
    $nextIndex = getNextIndex($nextIndex, scalar(@input));
    $input[$nextIndex]++;
  }

  $key = join(",", @input);
  print "$iterations: $key\n";

  if (defined($allocation{$key})) {
    print "Allocation '$key' was last seen at iteration: $allocation{$key}\n";
    print "Iterations since allocation was last seen: ", $iterations - $allocation{$key}, "\n";
    last;
  } else {
    $allocation{$key} = $iterations;
  }
}

print "Found duplicate allocation after $iterations iterations\n";

sub getNextIndex($) {
  $index = shift;
  $size = shift;

  $nextIndex = ($index + 1) % $size;

  # print "$index, $size -> $nextIndex\n";

  return $nextIndex;
}

sub findHighestValue(@) {
  $indexContainingHighestValue = 0;
  $highestValue = 0;
  $currentIndex = 0;

  while (defined(my $value = shift)) {
    if ($value > $highestValue) {
      $indexContainingHighestValue = $currentIndex;
      $highestValue = $value;
    }
    $currentIndex++;
  }

  return ($indexContainingHighestValue, $highestValue);
}

