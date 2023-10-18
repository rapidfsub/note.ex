alias Mastery.Examples.Math

email1 = "mathter_of_the_universe@example.com"
email2 = "mam_math@example.com"
title = Math.quiz().title

Math.quiz_fields() |> Mastery.build_quiz()
Mastery.add_template(title, Math.template_fields())

user1 = Mastery.take_quiz(title, email1)
user2 = Mastery.take_quiz(title, email2)
Mastery.select_question(user1)
