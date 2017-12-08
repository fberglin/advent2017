#!/usr/bin/perl

use Data::Dumper;

open($fh, "< 7.input") || die "Unable to open file: $!\n";

@lines = <$fh>;

<<EOF
@lines = ( "pbga (66)",
"xhth (57)",
"ebii (61)",
"havc (66)",
"ktlj (57)",
"fwft (72) -> ktlj, cntj, xhth",
"qoyq (66)",
"padx (45) -> pbga, havc, qoyq",
"tknk (41) -> ugml, padx, fwft",
"jptl (61)",
"ugml (68) -> gyxo, ebii, jptl",
"gyxo (61)",
"cntj (57)" );
EOF
;

%tree = ();

foreach $line (@lines) {
  chomp($line);
  if (not $line =~ m/(\w+) \((\d+)\)( -> ([\w\s,]+))?/) {
    next;
  }
  # print "$1 - $2: $4\n";
  @children = split(/[, ]+/, $4);
  # print @children, "\n";
  $tree{$1} = { "weight" => $2, "parent" => undef, "children" => [ @children ] };
}

foreach $node (keys %tree) {
  # foreach $item (keys %{$tree{$node}}) {
    # print "$node: $item: ", $tree{$node}->{$item}, "\n";
  # }
  # print ">", scalar(@{$tree{$node}->{"children"}}), "<\n";
  $children = $tree{$node}->{"children"};
  foreach $child (@$children) {
    $tree{$child}->{"parent"} = $node;
    # print "$child -> ", $tree{$child}->{"parent"}, "\n";
  }
}

# print Dumper %tree;

foreach $node (keys %tree) {
  if (not defined($tree{$node}->{"parent"})) {
    print "Found root: '$node'\n";
    # last;
  }
}
