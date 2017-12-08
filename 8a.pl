#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 8.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

<<EOF
@lines = (
"b inc 5 if a > 1",
"a inc 1 if b < 5",
"c dec -10 if a >= 1",
"c inc -20 if c == 10"
);
EOF
;

%registers = ();

foreach $line (@lines) {
  chomp($line);
  if (not $line =~ m/(\w+) (\w+) ([\d-]+) if (\w+) ([<=!>]+) ([\d-]+)/) {
    print "Unmatched line: '$line'\n";
    next;
  }

  $register = $1;
  $operation = $2;
  $increment = $3;
  $variable = $4;
  $conditional = $5;
  $constant = $6;

  if (not defined($registers{$register})) {
    $registers{$register} = 0;
  }

  if (conditionIsMet($variable, $conditional, $constant)) {
    executeOperationOnRegister($operation, $register, $increment);
  }
}

$registerWithHighestValue = findRegisterWithHighestValue();

print "Register with highest value: $registerWithHighestValue: $registers{$registerWithHighestValue}\n";

sub findRegisterWithHighestValue(@) {
  $highestValue = 0;
  $highestRegister = "";
  foreach $register (keys %registers) {
    if ($registers{$register} > $highestValue) {
      $highestValue = $registers{$register};
      $highestRegister = $register;
    }
  }
  return $highestRegister;
}

sub conditionIsMet(@) {
  my $variable = shift;
  my $conditional = shift;
  my $constant = shift;

  my $value = $registers{$variable} || 0;
  # print "$value, $variable, $conditional, $constant\n";

  if ($conditional eq "<") {
    return $value < $constant;
  } elsif ($conditional eq ">") {
    return $value > $constant;
  } elsif ($conditional eq ">=") {
    return $value >= $constant;
  } elsif ($conditional eq "<=") {
    return $value <= $constant;
  } elsif ($conditional eq "==") {
    return $value == $constant;
  } elsif ($conditional eq "!=") {
    return $value != $constant;
  } else {
    print "Unknown conditional: '$conditional'\n";
  }
  return 0;
}

sub executeOperationOnRegister(@) {
  my $operation = shift;
  my $register = shift;
  my $increment = shift;

  # print "$operation, $register, $increment\n";

  if ($operation eq "inc") {
    $registers{$register} += $increment;
  } elsif ($operation eq "dec") {
    $registers{$register} -= $increment;
  }
}

