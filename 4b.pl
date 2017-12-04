#!/usr/bin/perl

open($fh, "< 4.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

$count = 0;

for $line (@lines) {
  chomp($line);
  @words = split(/\s+/, $line);
  $valid = 1;

  for ($i=0; $i<scalar(@words); $i++) {
    for ($j=$i+1; $j<scalar(@words); $j++) {
      # print "<$words[$i]>: <$words[$j]>\n";
      # if (1 == isAnagram($words[$i], $words[$j])) {
      if (1 == isAnagramFast($words[$i], $words[$j])) {
        $valid = 0;
        last;
      }
    }
    if (0 == $valid) {
      last;
    }
  }
  if (1 == $valid) {
    $count++;
  }
}

print "Valid passphrases: $count\n";

sub isAnagram(@) {
  $left = shift;
  $right = shift;

  # print "$left, $right\n";

  %frequencyMap = ();

  @letters = split(//, $left);
  foreach $letter (@letters) {
    if (defined($frequencyMap{$letter})) {
      $frequencyMap{$letter}++;
    } else {
      $frequencyMap{$letter} = 1;
    }
  }

  @letters = split(//, $right);
  foreach $letter (@letters) {
    if (defined($frequencyMap{$letter})) {
      $frequencyMap{$letter}--;
    } else {
      $frequencyMap{$letter} = -1;
    }
  }

  foreach $letter (sort keys %frequencyMap) {
    # print "$letter: $frequencyMap{$letter}\n";
    if ($frequencyMap{$letter} != 0) {
      return 0;
    }
  }

  # print "Anagrams: $left, $right\n";
  return 1;
}

sub isAnagramFast(@) {
  $left = shift;
  $right = shift;

  %primes = ( "a" => 3, 'b' => 5, 'c' => 7, 'd' => 11,
              'e' => 13, 'f' => 17, 'g' => 19, 'h' => 23,
              'i' => 29, 'j' => 31, 'k' => 37, 'l' => 41,
              'm' => 43, 'n' => 47, 'o' => 53, 'p' => 59,
              'q' => 61, 'r' => 67, 's' => 71, 't' => 73,
              'u' => 79, 'v' => 83, 'w' => 89, 'x' => 97,
              'y' => 101, 'z' => 103 );

  $leftFactor = 1;
  $rightFactor = 1;

  @letters = split(//, $left);
  foreach $letter (@letters) {
    $leftFactor *= $primes{$letter};
  }

  @letters = split(//, $right);
  foreach $letter (@letters) {
    $rightFactor *= $primes{$letter};
  }

  if ($leftFactor != $rightFactor) {
    return 0;
  }

  # print "Anagrams: $left, $right\n";
  return 1;
}

