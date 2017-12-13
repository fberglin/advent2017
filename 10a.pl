#!/usr/bin/perl

$input = "31,2,85,1,80,109,35,63,98,255,0,13,105,254,128,33";
@data = (0 ... 255);

# $input = "3, 4, 1, 5";
# @data = (0 ... 4);

@values = split(/,\s*/, $input);

$currentPosition = 0;
$skipSize = 0;

foreach $length (@values) {
  @dataCopy = @data;
  @slice = circularSlice(\@dataCopy, $currentPosition, $length);
  @reverse = reverse(@slice);
  circularReplace(\@reverse, \@data, $currentPosition);
  # print "$length:$currentPosition:$skipSize:", @slice, ":", @reverse, ":", @data, "\n";
  $currentPosition = ($currentPosition + $length + $skipSize) % scalar(@data);
  $skipSize++;
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

print "$data[0] * $data[1] = ", $data[0] * $data[1], "\n";

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

