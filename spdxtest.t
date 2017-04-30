use Test;
use lib 'lib';
use SPDX::Parser;
my $first-test-only = True;
my @list =
    'MIT AND (LGPL-2.1+ OR BSD-3-Clause)' => 12,
    '(MIT AND LGPL-2.1+) OR BSD-3-Clause' => 12,
    'MIT AND LGPL-2.1+' => (7, ${:exceptions($[]), :!is-simple, :licenses($[["MIT", "LGPL-2.1+"],])}),
    '(MIT AND GPL-1.0)' => 8,
    '(MIT WITH GPL)' => (7, ${:exceptions($["GPL"]), :!is-simple, :licenses($[["MIT"],])}),
    'MIT' => (3, ${:exceptions($[]), :is-simple, :licenses($[["MIT"],])}),
    'GPL-3.0 WITH Madeup-exception' => 6
;
my $res = Grammar::SPDX::Expression.parse(@list[4].key, actions => parsething.new);
say '===========';
say $res;
$res .= made;
say $res.perl;
my @ready = 2,4,5;
is-deeply
    Grammar::SPDX::Expression.parse(
        @list[$_].key,
        actions => parsething.new
        ).made,
    @list[$_].value[1],
    @list[$_].key
for @ready;
do { done-testing; exit} if $first-test-only;
for @list {
    my $parse = Grammar::SPDX::Expression.parse(.key, :actions(parsething.new));
    ok $parse, .key;
    is $parse.gist.lines.elems, .value[0], "{.key} .gist.lines >= {.value[0]}";
}
my $thing;
done-testing;
