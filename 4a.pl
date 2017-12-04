#!/usr/bin/perl

open($fh, "< 4.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

$count = 0;
for $line (@lines) {
  @words = split(/\s+/, $line);

  $valid = 1;
  for $i (0 ... scalar(@words)) {
    for $j (0 ... scalar(@words)) {
      next if ($i == $j);
      if ($words[$i] eq $words[$j]) {
        $valid = 0;
        last;
      }
    }
    if ($valid == 0) {
      last;
    }
  }
  if ($valid == 1) {
    $count++;
  }
}

print "Valid passphrases: $count\n";

