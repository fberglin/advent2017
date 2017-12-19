#!/usr/bin/perl

$input = "31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33";
# $input = "";
# $input = "AoC 2017";
# $input = "1,2,3";
# $input = "1,2,4";

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

print "$hash\n";

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

