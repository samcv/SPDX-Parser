use Test;
use lib 'lib';
use SPDX::Parser;
my $first-test-only = 3;
my @list =
    'MIT AND (LGPL-2.1+ OR BSD-3-Clause)' => (11, ${:array($[["MIT", "LGPL-2.1+"], ["BSD-3-Clause", "MIT"]])}),
    'MIT AND LGPL-2.1+ AND BSD-3-Clause' => 12,
    'MIT AND LGPL-2.1+' => (7, ${:exceptions($[]), :!is-simple, :licenses($[["MIT", "LGPL-2.1+"],])}),
    '(MIT AND GPL-1.0)' => 8,
    '(MIT WITH GPL)' => (7, ${:exceptions($["GPL"]), :!is-simple, :licenses($[["MIT"],])}),
    'MIT' => (3, ${:array($['MIT'])}),
    'GPL-3.0 WITH Madeup-exception' => 6,
    'GPL-3.0 OR Artistic-1.0' => (8, ${:array($[["GPL-3.0"], ["Artistic-1.0"]])}),
    'MIT AND LGPL-2.1+ AND BSD-3-Clause' => (11, ${:array($[["MIT", "LGPL-2.1+", "BSD-3-Clause"],])}),
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
sub run-test (Int:D $elem, Bool:D :$todo = False, Bool:D :$notest = False) {
    my $text = @list[$elem].key;
    my $parse =
        Grammar::SPDX::Expression.parse(
            $text,
            actions => parsething.new
    );
    if !$notest {
        ok $parse, "$elem defined $text";
        is $parse.gist.lines.elems, @list[$elem].value[0], "$elem Gist lines: $text";
        is-deeply ($parse.defined ?? $parse.made !! Any),  @list[$elem].value[1], "$elem made: $text";
    }
    else {
        say "PARSE_RESULT:", $parse;
        say "PARSE_MADE: ", ($parse.defined ?? $parse.made !! Any);
    }
}
run-test(7);
run-test(8);
run-test(5);
#run-test(0);
done-testing;
