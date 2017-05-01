grammar Grammar::SPDX::Expression {
    regex TOP {
        \s*
        | <simple-expression>
        | <compound-expression>

        \s*
    }

    regex idstring { [<.alpha> | <.digit> | '-' | '.']+ }

    regex license-id { <.idstring> }

    regex license-exception-id { <.idstring> }

    regex license-ref { ['DocumentRef-' <.idstring> ':']? 'LicenseRef-' <.idstring> }

    regex simple-expression {
        | <license-id> '+'?
        | <license-ref>
    }
    proto token complex-expression { * }
    token complex-expression:sym<WITH> {
        'WITH' <.ws>
        <license-exception-id>
    }
    token or-exp {
        [
            | <simple-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> [ 'OR' ] <.ws> ]
    }
    token and-exp {
        [
            | <simple-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> [ 'AND' ] <.ws> ]
    }
    token with-exp {
        [
            | <simple-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> [ 'WITH' ] <.ws> ]
    }
    proto regex compound-expression { * }
    regex compound-expression:sym<paren>  {
        [\s* '('] ~ [')' \s* ]

       [
           | <or-exp>
           | <and-exp>
           | <with-exp>
       #    | <simple-expression>
       ]
    }
    regex compound-expression:sym<noparen> {
        [
            | <or-exp>
            | <and-exp>
            | <with-exp>
        #    | <simple-expression>
        ]
        #[ <complex-expression>+ ]?
    }
}
class parsething {
    has @!array;
    has $!elem = 0;
    has @!all-licenses;
    has Bool:D $!simple = True;
    has $!rand = 900.rand.Int;
    method TOP ($/) {
        say "$!rand HIT TOP";
        say $/;
        if ! $<compound-expression> {
            say "NO COMPAND";
            say @!all-licenses;
            for ^@!all-licenses.elems {
                @!array.push: @!all-licenses.pop;
            }
            say @!array;
        }
        make { array => @!array }
    }
    method simple-expression ($/) {
        die if $/.elems > 1;
        @!all-licenses.push: ~$/;
    }
    method and-exp ($/) {
        $!simple = False;
        say "setting $!simple to filse";
        if $<simple-expression> {
            note 'simple';
            for ^$<simple-expression>.elems {
                @!array[$!elem].push: $<simple-expression>[$_].Str;
            }
        }
    }
    method or-exp ($/) {
        $!simple = False;
        if $<simple-expression> {
            note 'or-exp simple';
            $!elem--;
            for ^$<simple-expression>.elems {
                say $<simple-expression>;
                note "going to next elem in array";
                $!elem++;
                @!array[$!elem].push: $<simple-expression>[$_].Str;
            }
        }
    }


}
