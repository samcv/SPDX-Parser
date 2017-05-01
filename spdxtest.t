use Test;
use lib 'lib';
use SPDX::Parser;
my $first-test-only = 3;
my @list =
    'MIT AND (LGPL-2.1+ OR BSD-3-Clause)' => (11, ${:array($[["MIT", "LGPL-2.1+"], ["BSD-3-Clause", "MIT"]])}),
    '(MIT AND LGPL-2.1+) OR BSD-3-Clause' => 12,
    'MIT AND LGPL-2.1+' => (7, ${:exceptions($[]), :!is-simple, :licenses($[["MIT", "LGPL-2.1+"],])}),
    '(MIT AND GPL-1.0)' => 8,
    '(MIT WITH GPL)' => (7, ${:exceptions($["GPL"]), :!is-simple, :licenses($[["MIT"],])}),
    'MIT' => (3, ${:array($['MIT'])}),
    'GPL-3.0 WITH Madeup-exception' => 6,
    'GPL-3.0 OR Artistic-1.0' => (7, ${:array($[["GPL-3.0"], ["Artistic-1.0"]])})
;
sub playground ($str) {
    my $res = Grammar::SPDX::Expression.parse($str,
    actions => parsething.new
    );;
    say $res;
    say $res.made.perl;
}
note 'START';
#playground 'MIT AND GPL-2.0'; exit;
sub run-test ($elem, Bool:D :$todo = False) {
    my $text = @list[$elem].key;
    my $parse =
        Grammar::SPDX::Expression.parse(
            $text,
            actions => parsething.new
    );
    ok $parse, "$elem defined $text";
    is $parse.gist.lines.elems, @list[$elem].value[0], "$elem Gist lines: $text";
    is-deeply $parse.made,  @list[$elem].value[1], "$elem made: $text";
}
run-test(7);
run-test(0);
run-test(5);
done-testing;
