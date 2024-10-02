open Primrec

let () =
  let parser = Parser.init_parser stdin in
  let prompt () =
    print_string "> ";
    flush stdout;
    Parser.parse_expression parser
    |> Parser.string_of_expression
    |> print_endline in
  print_endline "primrec v1";
  while true do
    prompt ()
  done
