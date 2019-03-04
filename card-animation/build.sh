cd source/elm
alias make='../../../dev/node_modules/.bin/elm-make'
$make Explanation/Main.elm Explanation/Naive.elm --output ../../public/js/Elm.Explanation.js
$make Iterations/Main.elm --debug --output ../../public/js/Elm.Iterations.js
