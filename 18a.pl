#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 18.input") || die "Unable to open file: $!\n";

@input = <$fh>;

<<EOF
@input = ( "set a 1",
           "add a 2",
           "mul a a",
           "mod a 5",
           "snd a",
           "set a 0",
           "rcv a",
           "jgz a -1",
           "set a 1",
           "jgz a -2" );
EOF
;

$lastPlayedFrequency = 0;
$recoveredFrequency = 0;

%registers = ();

$index = 0;
while ($index < scalar(@input)) {
  $instruction = $input[$index];

  if (not $instruction =~ m/(\w+) (\w+)( ([-\d\w]+))?/) {
    print "Unknown instruction: '$instruction'\n";
    next;
  }

  $operation = $1;
  $register = $2;
  $value = $4;

  if ($operation eq "snd") {
    $lastPlayedFrequency = $registers{$register};
  } elsif ($operation eq "set") {
    $registers{$register} = getValue($value);
  } elsif ($operation eq "add") {
    $registers{$register} += getValue($value);
  } elsif ($operation eq "mul") {
    $registers{$register} *= getValue($value);
  } elsif ($operation eq "mod") {
    $registers{$register} %= getValue($value);
  } elsif ($operation eq "rcv") {
    if ($registers{$register} != 0) {
      $recoveredFrequency = $lastPlayedFrequency;
      last;
    }
  } elsif ($operation eq "jgz") {
    if ($registers{$register} > 0) {
      $index += getValue($value);
      next;
    }
  } else {
    print "Unknown operation: '$operation'\n";
  }

  print "Index: $index, register: $register, operation: $operation, value: '$value' (", getValue($value), "), current value: $registers{$register}\n";
  $index++;
}

# print Dumper %registers;

print "Last played frequency: $recoveredFrequency\n";

sub getValue(@) {
  my $value = shift;

  if ($value =~ /[-\d]+/) {
    return $value;
  } elsif ($value ne "") {
    if (defined($registers{$value})) {
      return $registers{$value};
    } else {
      print "Accessing undefined register: '$value'\n";
    }
  }
  return 0;
}


