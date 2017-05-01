use Test;
use lib 'lib';
use SPDX::Parser;
my $first-test-only = 3;
my @list =
    'MIT AND (LGPL-2.1+ OR BSD-3-Clause)' => 11,
    '(MIT AND LGPL-2.1+) OR BSD-3-Clause' => 12,
    'MIT AND LGPL-2.1+' => (7, ${:exceptions($[]), :!is-simple, :licenses($[["MIT", "LGPL-2.1+"],])}),
    '(MIT AND GPL-1.0)' => 8,
    '(MIT WITH GPL)' => (7, ${:exceptions($["GPL"]), :!is-simple, :licenses($[["MIT"],])}),
    'MIT' => (3, ${:exceptions($[]), :is-simple, :licenses($[["MIT"],])}),
    'GPL-3.0 WITH Madeup-exception' => 6,
    'GPL-3.0 OR Artistic-1.0' => 7
;
#for  {
    #$key = @list[0].key;
    my $key = @list[0].key;
    my $res = Grammar::SPDX::Expression.parse($key,
    actions => parsething.new
    );;
    say $res;
    say $res.made.perl;
    #`$res.made;
#}

exit;
my @ok = 7, 0;
for @ok -> $elem {
    my $text = @list[$elem].key;
    my $parse =
        Grammar::SPDX::Expression.parse(
            $text,
            actions => parsething.new
    );
    ok $parse, "defined $text";
    is $parse.gist.lines.elems, @list[$elem].value[0], "Gist lines: $text";
    #is-deeply $parse.made,  ${:array($[["GPL-3.0"], ["Artistic-1.0"]])};
}
done-testing;
