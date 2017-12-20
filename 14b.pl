#!/usr/bin/perl

use Data::Dumper;

$input = "amgozmfv";
# $input = "flqrgnkx";

%rows = ();

$gridSize = 128;
# $gridSize = 9;

foreach $row (0 ... $gridSize-1) {
  $string = $input . "-" . $row;
  $hash = calculateHash($string);
  $binString = hex2bin($hash);

  $rows{$row} = [ split(//, $binString) ];
}

$used = 0;

%grid = ();
$x = 0;
$y = 0;

foreach $row (sort { $a <=> $b } keys %rows) {
  $cols = $rows{$row};
  $x = 0;
  foreach $col (@$cols) {
    if ($col == 1) {
      $grid{"$x,$y"} = 0;
    }
    $x++;
  }
  $y++;
}

$currentArea = 1;

foreach $y (0 ... $gridSize-1) {
  foreach $x (0 ... $gridSize-1) {
    my $block = "$x,$y";

    if (defined($grid{$block}) && $grid{$block} == 0) {
      $grid{$block} = $currentArea;
      markAdjacentBlocks($x, $y, $currentArea);
      $currentArea++;
    }
  }
}

printGrid();

print "Number of regions in grid: ", ( sort { $b <=> $a } (values %grid) )[0], "\n";

sub printGrid() {
  foreach $y (0 ... $gridSize-1) {
    foreach $x (0 ... $gridSize-1) {
      if (defined($grid{"$x,$y"})) {
        print $grid{"$x,$y"} % 10;
      } else {
        print ".";
      }
    }
    print "\n";
  }
}

sub getAdjacentBlocks(@) {
  my $x = shift;
  my $y = shift;

  my $north = { "x" => $x, "y" => $y-1 };
  my $east = { "x" => $x+1, "y" => $y };
  my $south = { "x" => $x, "y" => $y+1 };
  my $west = { "x" => $x-1, "y" => $y };

  return ( $north, $east, $south, $west );
}

sub markAdjacentBlocks(@) {
  my $x = shift;
  my $y = shift;
  my $area = shift;

  foreach $block (getAdjacentBlocks($x, $y)) {
    my %map = %$block;
    my $p = sprintf("%d,%d", $map{"x"}, $map{"y"});
    if (markBlock($p, $area)) {
      markAdjacentBlocks($map{"x"}, $map{"y"}, $area);
    }
  }
}

sub markBlock(@) {
  my $block = shift;
  my $area = shift;

  if (defined($grid{$block}) and $grid{$block} == 0) {
    $grid{$block} = $area;
    return 1;
  }

  return 0;
}

sub hex2bin {
  my $h = shift;
  my $hlen = length($h);
  my $blen = $hlen * 4;
  return unpack("B$blen", pack("H$hlen", $h));
}

sub calculateHash(@) {
  my $input = shift;

  @chars = split(//, $input);

  @data = (0 ... 255);

  $currentPosition = 0;
  $skipSize = 0;

  @values = ();

  foreach $char (@chars) {
    $ascii = ord($char);
    push(@values, $ascii);
  }

  push(@values, 17, 31, 73, 47, 23);

  for (0 ... 63) {
    foreach $length (@values) {
      @dataCopy = @data;
      @slice = circularSlice(\@dataCopy, $currentPosition, $length);
      @reverse = reverse(@slice);
      circularReplace(\@reverse, \@data, $currentPosition);
      $currentPosition = ($currentPosition + $length + $skipSize) % scalar(@data);
      $skipSize++;
    }
  }

  $hash = "";
  for (1 ... scalar(@data) / 16) {
    @splice = splice(@data, 0, 16);
    $sum = 0;

    foreach $value (@splice) {
      $sum = $sum ^ $value;
    }

    push(@hash, $sum);

    $hash .= sprintf("%02x", $sum);
  }

  return $hash;
}

sub circularReplace(@) {
  my $sourceArray = shift;
  my $destinationArray = shift;
  my $offset = shift;

  my $sourceLength = scalar(@$sourceArray);
  my $destinationLength = scalar(@$destinationArray);

  for (0 ... $sourceLength-1) {
    my $index = ($offset+$_) % $destinationLength;
    @$destinationArray[$index] = @$sourceArray[$_];
  }
}

sub circularSlice(@) {
  my $array = shift;
  my $offset = shift;
  my $length = shift;

  my $size = scalar(@$array);
  my @slice = ();

  if ($offset + $length > $size) {
    @endSlice = splice(@$array, $offset, $size-$offset);
    @startSlice = splice(@$array, 0, $length-scalar(@endSlice));
    @slice = (@endSlice, @startSlice);
  } else {
    @slice = splice(@$array, $offset, $length);
  }
  return @slice;
}

