#!/usr/bin/perl

# Initialization

$input = 347991;

# $input = 10;

$x = 0;
$y = 0;

@headings = ( "N", "W", "S", "E" );
$heading = 2;

%grid = ();

# Main program begins here
#-------------------------------------------------------------------------------

for $p (1 ... $input) {
  $grid{"$x,$y"} = $p;

  if (isItPossibleToTurnLeft()) {
    turnLeft();
  }
  moveOneStep();
}

print "Total distance from center: ", abs($x) + abs($y) - 1, "\n";

# Main program ends here
#-------------------------------------------------------------------------------

sub turnLeft(@) {
  $heading = getNewHeadingAfterRotateLeft();
}

sub moveOneStep(@) {
  ($x, $y) = getNextStep($heading);
}

sub isItPossibleToTurnLeft(@) {
  $newHeading = getNewHeadingAfterRotateLeft();
  ($newX, $newY) = getNextStep($newHeading);
  $newPosition = "$newX,$newY";
  if (not defined($grid{$newPosition})) {
    return 1;
  } else {
    return 0;
  }
}

sub getNewHeadingAfterRotateLeft(@) {
  return ($heading + 1) % 4;
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

  return ($newX, $newY);
}

