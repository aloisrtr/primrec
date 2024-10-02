type expression =
  | Int of int
  | Value of string
  | Succ of expression
  | Proj of expression
  | Rec of expression
  | Block of expression list
  
let rec string_of_expression = function
  | Int i -> string_of_int i
  | Value id -> id
  | Succ e -> "succ " ^ string_of_expression e
  | Proj e -> "proj " ^ string_of_expression e
  | Rec e -> "rec " ^ string_of_expression e
  | Block l -> 
    let rec string_of_block acc = function
      | [] -> acc
      | e :: [] -> acc ^ string_of_expression e
      | e :: rest -> string_of_block (acc ^ (string_of_expression e) ^ " ") rest
    in
    "(" ^ (string_of_block "" l) ^ ")"

type statement =
  | Bind of string * expression
let string_of_statement = function
  | Bind (s, e) -> "bind " ^ s ^ " = " ^ string_of_expression e

exception SyntaxError of string

type stream =
  {
    mutable line: int;
    mutable chars: char list;
    channel: in_channel
  }

let init_parser channel = {
  line = 1;
  chars = [];
  channel
}

let read_char stream = match stream.chars with
  | [] ->
    let c = input_char stream.channel in
    if c = '\n' then stream.line <- stream.line + 1;
    c
  | c :: tl ->
    stream.chars <- tl;
    c

let unread_char stream c =
  stream.chars <- c :: stream.chars

let is_whitespace c = c = ' ' || c = '\t' || c = '\n'
let rec consume_whitespace stream =
  let c = read_char stream in
  if is_whitespace c then
    consume_whitespace stream
  else
    unread_char stream c

let is_digit c =
  let code = Char.code c in
  code >= Char.code('0') && code <= Char.code('9')
let parse_digit stream =
  let rec parse_digit_inner acc =
    let c = read_char stream in
    if is_digit c then
      parse_digit_inner (acc ^ (Char.escaped c))
    else (
      unread_char stream c;
      Int (int_of_string acc)
    )
  in
  parse_digit_inner ""

let parse_identifier stream =
  let rec parse_identifier_inner acc =
    let c = read_char stream in
    if is_whitespace c || c == '(' || c == ')'
    then ( unread_char stream c; acc )
    else parse_identifier_inner (acc ^ Char.escaped c)
  in
    parse_identifier_inner ""

let parse_expression stream =
  let rec parse_block exprs =
    consume_whitespace stream;
    let c = read_char stream in
    match c with
      | '(' -> parse_block ((parse_block []) :: exprs)
      | ')' -> Block (List.rev exprs)
      | c when is_digit c ->
        unread_char stream c;
        parse_block ((parse_digit stream) :: exprs)
      | c ->
        unread_char stream c;
        let expr = match parse_identifier stream with
          | "succ" -> Succ (parse_expression_inner ())
          | "proj" -> Proj (parse_expression_inner ())
          | "rec" -> Rec (parse_expression_inner ())
          | id -> Value id
        in parse_block (expr :: exprs)
  and parse_expression_inner () =
    consume_whitespace stream;
    let c = read_char stream in
    match c with
      | '(' -> parse_block []
      | ')' -> raise (SyntaxError "Unmatched closing bracket")
      | c when is_digit c ->
        unread_char stream c;
        parse_digit stream
      | c ->
        unread_char stream c;
        match parse_identifier stream with
          | "succ" -> Succ (parse_expression_inner ())
          | "proj" -> Proj (parse_expression_inner ())
          | "rec" -> Rec (parse_expression_inner ())
          | id -> Value id
  in
  parse_expression_inner ()

let parse_statement _ = Bind ("aled", Int 1)

(* 
proj (succ 2) (succ (succ 4)) 2 3 5

proj
- succ
  - 2
- succ
  - succ
    - 4
- 2
- 3
- 5
*)
