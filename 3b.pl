#!/usr/bin/perl

use Data::Dumper;

$input = 347991;

# $input = 10;

$x = 0;
$y = 0;

@headings = ( "N", "W", "S", "E" );
$heading = 3;

%grid = ( "0,0" => 1 );
$x = 1;
$y = 0;

for $p (1 ... $input) {
  $value = calculateSumOfNeighbours();
  print "Putting $value into $x,$y\n";
  $grid{"$x,$y"} = $value;

  if ($value > $input) {
    print "First value greater than input: $value\n";
    last;
  }

  if (isItPossibleToTurnLeft()) {
    turnLeft();
  }
  step();
}

sub calculateSumOfNeighbours(@) {
  $sum = 0;
  for $myX (-1 ... 1) {
    for $myY (-1 ... 1) {
      next if ($myX == 0 && $myY == 0);
      $myPos = ($x + $myX) . "," . ($y + $myY);
      $sum += $grid{$myPos} || 0;
    }
  }
  return $sum;
}

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


