grammar Grammar::SPDX::Expression {
    regex TOP {
        \s*
        | <paren-expression>
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
    regex complex-expression:sym<WITH> {
        'WITH' <.ws>
        <license-exception-id>
    }
    regex or-exp {
        [
            | <simple-expression>
            | <paren-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> [ 'OR' ] <.ws> ]
    }
    regex and-exp {
        [
            | <simple-expression>
            | <paren-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> [ 'AND' ] <.ws> ]
    }
    regex with-exp {
        [
            | <simple-expression>
            | <paren-expression>
            | <compound-expression>
        ]+ %
        [ <.ws> [ 'WITH' ] <.ws> ]
    }
    regex paren-expression {
        '(' ~ ')'
        [
        #    | <or-exp>
            | <simple-expression>
            | <compound-expression>
        ]
    }
    regex compound-expression {
        [
            | <or-exp>
            | <and-exp>
            | <with-exp>
        #    | <paren-expression>
        #    | <simple-expression>
        ]
        #[ <complex-expression>+ ]?
    }
}
