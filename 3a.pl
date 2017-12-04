#!/usr/bin/perl

use Data::Dumper;

$input = 347991;

# $input = 10;

$x = 0;
$y = 0;

@headings = ( "N", "W", "S", "E" );
$heading = 2;

%grid = ();

for $p (1 ... $input) {
  # print "Putting $p into $x,$y\n";
  $grid{"$x,$y"} = $p;

  if (isItPossibleToTurnLeft()) {
    turnLeft();
    # print "Currently facing: $headings[$heading]\n";
  }
  step();
  # print "Currently standing at: $x,$y\n";
}

print "Total distance from center: ", abs($x) + abs($y) - 1, "\n";

sub turnLeft(@) {
  $heading = getNextHeading($heading);
}

sub isItPossibleToTurnLeft(@) {
  $newHeading = getNextHeading();
  ($newX, $newY) = getNextStep($newHeading);
  $newPosition = "$newX,$newY";
  if (not defined($grid{$newPosition})) {
    # print "$newPosition is free\n";
    return 1;
  } else {
    # print "$newPosition is blocked by $grid{$newPosition}\n";
    return 0;
  }
}

sub getNextHeading(@) {
  return ($heading + 1) % 4;
}

sub step(@) {
  # print "Moving from $x,$y to ";
  ($x, $y) = getNextStep($heading);
  # print "$x,$y\n";
}

sub getNextStep(@) {
  $myHeading = shift;
  $newX = $x;
  $newY = $y;
  if ($headings[$myHeading] eq "E") {
    $newX++;
  } elsif ($headings[$myHeading] eq "S") {
    $newY--;
  } elsif ($headings[$myHeading] eq "W") {
    $newX--;
  } elsif ($headings[$myHeading] eq "N") {
    $newY++;
  }

  # print "Heading: $headings[$myHeading], New coordinate: $newX,$newY\n";

  return ($newX, $newY);
}

for $key (keys (%grid)) {
  # print "$key => $grid{$key}\n";
}


