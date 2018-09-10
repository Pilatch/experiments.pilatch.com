cd source/elm
uglify=../../../node_modules/.bin/uglifyjs
elm make --optimize Explanation/Main.elm Explanation/Naive.elm --output ../../public/js/Elm.Explanation.js && \
  $uglify ../../public/js/Elm.Explanation.js -o ../../public/js/Elm.Explanation.js
# Can't --optimize and --debug at the same time.
elm make Iterations/Main.elm --debug --output ../../public/js/Elm.Iterations.js && \
  $uglify ../../public/js/Elm.Iterations.js -o ../../public/js/Elm.Iterations.js
