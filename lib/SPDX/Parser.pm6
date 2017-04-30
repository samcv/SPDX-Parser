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
    token complex-expression:sym<WITH> {
        'WITH' <.ws>
        <license-exception-id>
    }
    token or-exp {
        [
            | <simple-expression>
            | <paren-expression>
        #    | <compound-expression>
        ]+ %
        [ <.ws> [ 'OR' ] <.ws> ]
    }
    token and-exp {
        [
            | <simple-expression>
            | <paren-expression>
            #| <compound-expression>
        ]+ %
        [ <.ws> [ 'AND' ] <.ws> ]
    }
    token with-exp {
        [
            | <simple-expression>
            | <paren-expression>
        #    | <compound-expression>
        ]+ %
        [ <.ws> [ 'WITH' ] <.ws> ]
    }
    token paren-expression {
        '(' ~ ')'
        [
        #    | <or-exp>
        #    | <simple-expression>
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
