-module(robots_erl).
-import(robotsx, [string/1]).
-import(robotsy, [parse/1]).
-import(string, [substr/3]).
-export([parse_robots/1, can_access/3]).

parse_robots(Str) when is_list(Str) -> 
	{ok, Tokens, _} = robotsx:string(Str),
	{ok, Parsed} = robotsy:parse(Tokens),
	Parsed.

can_access(Parsed, BotName, Url) when is_list(Url) and is_list(BotName) and is_tuple(Parsed) ->
	{bot_rules, X} = Parsed,
	can_access_intern(X, BotName, Url).

can_access_intern([], _, _) -> true ;
can_access_intern([Head|Tail], BotName, Url) when is_list(Url) and is_list(BotName) and is_tuple(Head) ->
	{bot_rule, {bot_name, {'identifier', _, BotName2}}, {allowed_disalloweds, AllowedDisalloweds}} = Head,
	if
		BotName2 =:= BotName ->
			ck_allowed_disalloweds(Url, AllowedDisalloweds);

		BotName2 =:= "*" ->
			ck_allowed_disalloweds(Url, AllowedDisalloweds) ;

		true -> 
			can_access_intern(Tail, BotName, Url)

	end.

ck_allowed_disalloweds(_, []) -> true ;
ck_allowed_disalloweds(Url, [{allowed_disallowed, {'disallow', Url2}} | Tail]) when is_list(Url) and is_list(Url2) ->
	UrlStart = string:substr(Url, 1, length(Url2)),
	if
		UrlStart =:= Url2 ->
			false ;

		true ->
			ck_allowed_disalloweds(Url, Tail)
	end;

ck_allowed_disalloweds(Url, [{allowed_disallowed, {'allow', Url2}} | Tail]) when is_list(Url) and is_list(Url2) ->
	UrlStart = string:substr(Url, 1, length(Url2)),
	if
		UrlStart =:= Url2 ->
			true;

		true ->
			ck_allowed_disalloweds(Url, Tail)
	end.
