use Test;
use lib 'lib';
use SPDX::Parser;
my $first-test-only = 3;
my @list =
    'MIT AND (LGPL-2.1+ OR BSD-3-Clause)' => 12,
    '(MIT AND LGPL-2.1+) OR BSD-3-Clause' => 12,
    'MIT AND LGPL-2.1+' => (7, ${:exceptions($[]), :!is-simple, :licenses($[["MIT", "LGPL-2.1+"],])}),
    '(MIT AND GPL-1.0)' => 8,
    '(MIT WITH GPL)' => (7, ${:exceptions($["GPL"]), :!is-simple, :licenses($[["MIT"],])}),
    'MIT' => (3, ${:exceptions($[]), :is-simple, :licenses($[["MIT"],])}),
    'GPL-3.0 WITH Madeup-exception' => 6
;
my $res = Grammar::SPDX::Expression.parse('THIS AND MIT');
say $res;
