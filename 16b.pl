#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 16.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

@programs = ("a" ... "p");
@moves = split(/,/, $lines[0]);

# @programs = ("a" ... "e");
# @moves = ("s1", "x3/4", "pe/b");

$maxIterations = 1000;
$totalNumberOfDances = 1000000000;
# $totalNumberOfDances = 50;

$iteration = 0;
$|++;

$order = join("", @programs);
print "$iteration: $order\n";

%previousPositions = ( $order => $iteration );

# Assume that the pattern will repeat
for (1 ... $totalNumberOfDances) {
  $iteration++;

  dance();

  $order = join("", @programs);
  print "$iteration: $order\n";

  if (defined($previousPositions{$order})) {
    print "Found repeated pattern '$order' at position $previousPositions{$order} after: $iteration dances\n";
    last;
  } elsif ($iteration > $maxIterations) {
    print "No repetetion found after $maxIterations dances\n";
    exit;
  } else {
    $previousPositions{$order} = $iteration;
  }
}

$iterationsLeftToDo = ($totalNumberOfDances % $iteration) - $previousPositions{$order};
$dancesToSkip = int($totalNumberOfDances / $iteration);

print "Skipping $dancesToSkip dances\n";
print "Dances left to do: ", $iterationsLeftToDo, "\n";
print "Total dances to perform: ", $iteration * $dancesToSkip + $iterationsLeftToDo, "\n";

$iteration = $iteration * $dancesToSkip;

foreach (1 ... $iterationsLeftToDo) {
  $iteration++;
  dance();
}

print "Total dances performed: ", $iteration, "\n";

print "Order after dance: ", @programs, "\n";

sub dance() {
  foreach $move (@moves) {
    if ($move =~ /s(\d+)/) {
      # Spin

      @temp = splice(@programs, scalar(@programs)-$1, $1);
      @programs = (@temp, @programs);
    } elsif ($move =~ m!x(\d+)/(\d+)!) {
      # Exchange

      $temp = $programs[$1];
      $programs[$1] = $programs[$2];
      $programs[$2] = $temp;
    } elsif ($move =~ m!p(\w+)/(\w+)!) {
      # Partner

      ( $indexProgram1 ) = grep { $programs[$_] eq $1 } 0 ... $#programs;
      ( $indexProgram2 ) = grep { $programs[$_] eq $2 } 0 ... $#programs;

      $temp = $programs[$indexProgram1];
      $programs[$indexProgram1] = $programs[$indexProgram2];
      $programs[$indexProgram2] = $temp;
    }
  }
}

