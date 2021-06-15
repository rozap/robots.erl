Nonterminals bot_rule begin bot_name allowed_disallowed allowed_disalloweds bot_rules.
Terminals useragent ':' identifier allow disallow url crawldelay integer.

Rootsymbol begin.

begin -> bot_rules : '$1'.

bot_rules -> bot_rule : {bot_rules, ['$1']}.
bot_rules -> bot_rules bot_rule : {bot_rules, X} = '$1', {bot_rules, X ++ ['$2']}. 

bot_rule -> bot_name allowed_disalloweds : {bot_rule, '$1', '$2'}.

bot_name -> useragent ':' identifier : {bot_name, '$3'}.

allowed_disalloweds -> allowed_disallowed : {allowed_disalloweds, ['$1']}.
allowed_disalloweds -> allowed_disalloweds allowed_disallowed : {allowed_disalloweds, X} = '$1', {allowed_disalloweds, X ++ ['$2']}.

allowed_disallowed -> allow ':' url : {'url', _, Chars} = '$3', {allowed_disallowed, {'allow', Chars}}.
allowed_disallowed -> crawldelay ':' integer : {'integer', _, Num} = '$3', {allowed_disallowed, {'crawldelay', Num}}.
allowed_disallowed -> disallow ':' url : {'url', _, Chars} = '$3', {allowed_disallowed, {'disallow', Chars}}.
allowed_disallowed -> disallow ':' : {allowed_disallowed, {'allow', "/"}}.

Erlang code.
