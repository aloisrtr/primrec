open Primrec

let () =
  let parser = Parser.init_parser stdin in
  let prompt () =
    print_string "> ";
    flush stdout;
    Parser.parse_statement parser
    |> Parser.string_of_statement
    |> print_endline in
  print_endline "primrec v1";
  while true do
    prompt ()
  done
