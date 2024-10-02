type expression
val string_of_expression : expression -> string
type statement
val string_of_statement : statement -> string

exception SyntaxError of string

type stream =
  {
    mutable line: int;
    mutable chars: char list;
    channel: in_channel
  }

val init_parser : in_channel -> stream

val read_char : stream -> char
val unread_char : stream -> char -> unit

val parse_expression : stream -> expression
val parse_statement : stream -> statement
