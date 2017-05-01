grammar Grammar::SPDX::Expression {
    regex TOP {
        \s*
        [
            | <simple-expression>
            | <compound-expression>
        ]
        \s*
    }
    regex idstring { [<.alpha> | <.digit> | '-' | '.']+     }

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
    token or-and {
        [
            | <simple-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> $<keyword>=('OR'|'AND'|'WITH' ) <.ws> ]
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
        [\s* '('] ~ [')' \s* ]?

       [
           | <or-and>
         #  | <and-exp>
         #  | <with-exp>
       #    | <simple-expression>
       ]
    }
    regex compound-expression:sym<noparen> {
        [
            | <or-and>
        #    | <and-exp>
        #    | <with-exp>
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
        say $/.elems;
        say "$!rand HIT TOP";
        say $/;
        if ! $<compound-expression> and !@!array.elems {
            say "NO COMPAND";
            say 'TOP \@!all-licenses: ', @!all-licenses.perl;
            #@!all-licenses»
            @!array.append: @!all-licenses;
            for @!all-licenses {
                #@!array[$!elem].push:$_;
            }
            say @!array;
        }
        make { array => @!array }
    }
    method simple-expression ($/) {
        die if $/.elems > 1;
        @!all-licenses.push: ~$/;
    }
    method fix-array {
        if @!array[$!elem] !~~ Array {
            # TODO eventually shouldn't need this code
            say "Trying to fix \@!array[$!elem] deleting Str";
            @!array[$!elem] = [];
        }
    }
    method or-and ($/) {
        # $<keyword> should be in order of appearance
        say '##########', $<keyword>.elems;
        .say for $<keyword>;
        my $and = True;
        my $or = True;
        for $<keyword> {
            $and = False if $_.Str ne 'AND';
            $or = False if $_.Str ne 'OR';
        }
        say "$and $or ##########", $<expr>.elems;
        if $and {
            $!simple = False;
            say "All of them are AND keyword";
            if $<simple-expression> {
                note 'simple';
                self.fix-array;
                for ^$<simple-expression>.elems {
                    push @!array[$!elem], $<simple-expression>[$_].Str;
                }
            }
        }
        elsif $or {
            $!simple = False;
            if $<simple-expression> {
                note 'or-and simple';
                $!elem--;
                for ^$<simple-expression>.elems {
                    say $<simple-expression>;
                    note "going to next elem in array";
                    $!elem++;
                    say 'OR @!array: ', @!array.perl;
                    say 'OR @!all-licenses: ', @!all-licenses.perl;
                    if @!array[$!elem] !~~ Array {
                        # TODO eventually shouldn't need this code
                        say "Trying to fix \@!array[$!elem] deleting Str";
                        @!array[$!elem] = [];
                    }
                    push @!array[$!elem], $<simple-expression>[$_].Str;
                }
            }
        }
    }


}
