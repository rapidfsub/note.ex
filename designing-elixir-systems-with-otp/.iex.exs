alias Mastery.Core.{Quiz, Response, Template}

generators = %{left: [1, 2], right: [1, 2]}

checker = fn sub, answer ->
  sub[:left] + sub[:right] == String.to_integer(answer)
end

quiz =
  Quiz.new(title: "Addition", mastery: 2)
  |> Quiz.add_template(
    name: :single_digit_addtion,
    category: :addition,
    instructions: "Add the numbers",
    raw: "<%= @left %> + <%= @right %>",
    generators: generators,
    checker: checker
  )
  |> Quiz.select_question()

email = "jill@example.com"
response = Response.new(quiz, email, "0")
quiz = Quiz.answer_question(quiz, response)
IO.inspect(quiz.record)

quiz = Quiz.select_question(quiz)
IO.inspect(quiz.current_question.asked)
response = Response.new(quiz, email, "3")
quiz = Quiz.answer_question(quiz, response)
IO.inspect(quiz.record)
