#!/usr/bin/perl

use Data::Dumper;

$input = "amgozmfv";
# $input = "flqrgnkx";

%rows = ();

foreach $row (0 ... 127) {
  $string = $input . "-" . $row;
  $hash = calculateHash($string);
  $binString = hex2bin($hash);

  # printf("%03d: %s\n", $row, $binString);
  $rows{$row} = [ split(//, $binString) ];
}

$used = 0;

foreach $row (sort { $a <=> $b } keys %rows) {
  printf("%03d: ", $row);
  $cols = $rows{$row};
  foreach $col (@$cols) {
    if ($col == 0) {
      print ".";
    } elsif ($col == 1) {
      $used++;
      print "#";
    } else {
      print "?";
    }
  }
  print "\n";
}

print "Used squares: $used\n";

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
      # print "$length:$currentPosition:$skipSize:", @slice, ":", @reverse, ":", @data, "\n";
      $currentPosition = ($currentPosition + $length + $skipSize) % scalar(@data);
      $skipSize++;
    }
    # print @data, "\n";
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
    # print "At: $index in ", @$destinationArray, " replace", @$destinationArray[$index], "with", @$sourceArray[$_], "\n";
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

