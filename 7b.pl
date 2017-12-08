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

# @lines = ( "a (10) -> b1, b2", "b1 (3) -> c1, c2", "b2 (5)", "c1 (4)", "c2 (2)" );

%tree = ();

foreach $line (@lines) {
  chomp($line);
  if (not $line =~ m/(\w+) \((\d+)\)( -> ([\w\s,]+))?/) {
    next;
  }
  # print "$1 - $2: $4\n";
  @children = split(/[, ]+/, $4);
  $tree{$1} = { "weight" => $2, "parent" => undef, "children" => [ @children ] };
}

foreach $node (keys %tree) {
  $children = $tree{$node}->{"children"};
  foreach $child (@$children) {
    $tree{$child}->{"parent"} = $node;
  }
}

# print Dumper %tree;

$root = "";
foreach $node (keys %tree) {
  if (not defined($tree{$node}->{"parent"})) {
    print "Found root: '$node'\n";
    $root = $node;
    last;
  }
}

calculateAndSetTotalWeight($root);
printTree($root, 0);
$lastUnbalanced = findUnbalancedNode($root);
print "Last unbalanced: ", $lastUnbalanced,  "\n";

# print "Weight is: ", $tree{$lastUnbalanced}->{"weight"}, ", should be: ";

sub findUnbalancedNode(@) {
  my $node = shift;

  my $myWeight = $tree{$node}->{"weight"};
  my $myTotalWeight = $tree{$node}->{"totalWeight"};
  my $numberOfChildren = scalar(@{$tree{$node}->{"children"}});

  my $correctChildTotalWeight = ($myTotalWeight - $myWeight) / $numberOfChildren;

  my $returnValue = $node;
  print "$node: $myWeight: $myTotalWeight: $correctChildTotalWeight\n";
  foreach $child (@{$tree{$node}->{"children"}}) {
    if ($tree{$child}->{"totalWeight"} > $correctChildTotalWeight) {
      print "  $child: ", $tree{$child}->{"weight"}, ": ", $tree{$child}->{"totalWeight"}, "\n";
      $returnValue = findUnbalancedNode($child);
      last;
    }
  }
  return $returnValue;
}

sub printTree(@) {
  my $node = shift;
  my $indent = shift;
  print "  "x$indent, "$node: ", $tree{$node}->{"totalWeight"}, " (", $tree{$node}->{"weight"}, ")\n";
  foreach $child (@{$tree{$node}->{"children"}}) {
    printTree($child, $indent+1);
  }
}

sub calculateAndSetTotalWeight(@) {
  my $node = shift;
  my $totalWeight = $tree{$node}->{"weight"};
  foreach $child (@{$tree{$node}->{"children"}}) {
    $totalWeight += calculateAndSetTotalWeight($child);
  }
  $tree{$node}->{"totalWeight"} = $totalWeight;
  # print "result node $node: $totalWeight\n";
  return $totalWeight;
}
