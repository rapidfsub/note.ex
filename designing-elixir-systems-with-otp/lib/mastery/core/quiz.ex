defmodule Mastery.Core.Quiz do
  alias Mastery.Core.{Question, Response, Template}

  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_template(%__MODULE__{} = quiz, fields) do
    template = Template.new(fields)
    templates = update_in(quiz.templates, [template.category], &add_to_list_or_nil(&1, template))
    %{quiz | templates: templates}
  end

  defp add_to_list_or_nil(nil, template), do: [template]
  defp add_to_list_or_nil(templates, template), do: [template | templates]

  def selelct_question(%__MODULE__{templates: t}) when map_size(t) == 0 do
    nil
  end

  def select_question(quiz) do
    quiz
    |> pick_current_question()
    |> move_template(:used)
    |> reset_template_cycle()
  end

  defp pick_current_question(quiz) do
    Map.put(quiz, :current_question, select_a_random_question(quiz))
  end

  defp select_a_random_question(%__MODULE__{} = quiz) do
    quiz.templates
    |> Enum.random()
    |> elem(1)
    |> Enum.random()
    |> Question.new()
  end

  defp move_template(%__MODULE__{} = quiz, field) do
    quiz
    |> remove_template_from_category()
    |> add_template_to_field(field)
  end

  defp template(quiz) do
    quiz.current_question.template
  end

  defp remove_template_from_category(%__MODULE__{} = quiz) do
    template = template(quiz)

    new_category_templates =
      quiz.templates
      |> Map.fetch!(template.category)
      |> List.delete(template)

    new_templates =
      case new_category_templates do
        [] -> Map.delete(quiz.templates, template.category)
        _ -> Map.put(quiz.templates, template.category, new_category_templates)
      end

    %{quiz | templates: new_templates}
  end

  defp add_template_to_field(%__MODULE__{} = quiz, field) do
    template = template(quiz)
    list = Map.fetch!(quiz, field)
    Map.put(quiz, field, [template | list])
  end

  defp reset_template_cycle(%__MODULE__{templates: templates, used: used} = quiz)
       when map_size(templates) == 0 do
    %{quiz | templates: Enum.group_by(used, fn template -> template.category end), used: []}
  end

  defp reset_template_cycle(%__MODULE__{} = quiz) do
    quiz
  end

  def answer_question(quiz, %Response{correct: true} = response) do
    new_quiz =
      quiz
      |> inc_record()
      |> save_response(response)

    maybe_advance(new_quiz, mastered?(new_quiz))
  end

  def answer_question(quiz, %Response{correct: false} = response) do
    quiz
    |> reset_record()
    |> save_response(response)
  end

  def save_response(%__MODULE__{} = quiz, %Response{} = response) do
    %{quiz | last_response: response}
  end

  def mastered?(%__MODULE__{} = quiz) do
    score = Map.get(quiz.record, template(quiz).name, 0)
    score == quiz.mastery
  end

  defp inc_record(%__MODULE__{current_question: question} = quiz) do
    new_record = Map.update(quiz.record, question.template.name, 1, &(&1 + 1))
    %{quiz | record: new_record}
  end

  defp maybe_advance(%__MODULE__{} = quiz, false = _mastered), do: quiz
  defp maybe_advance(%__MODULE__{} = quiz, true = _mastered), do: advance(quiz)

  def advance(quiz) do
    quiz
    |> move_template(:mastered)
    |> reset_record()
    |> reset_used()
  end

  defp reset_record(%__MODULE__{current_question: question} = quiz) do
    %{quiz | record: Map.delete(quiz.record, question.template.name)}
  end

  defp reset_used(%__MODULE__{current_question: question} = quiz) do
    %{quiz | used: List.delete(quiz.used, question.template)}
  end
end
