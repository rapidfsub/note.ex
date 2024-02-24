# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Itch.Repo.insert!(%Itch.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Itch.Resource.Anniversary.upsert!(%{
  name: "가민씨 생일",
  month: 2,
  day: 24,
  calendar_kind: :gregorian
})

Itch.Resource.Anniversary.upsert!(%{
  name: "민섭 생일",
  month: 9,
  day: 7,
  calendar_kind: :gregorian
})

Itch.Resource.Anniversary.upsert!(%{
  name: "영민 생일",
  month: 10,
  day: 4,
  calendar_kind: :gregorian
})

Itch.Resource.Anniversary.upsert!(%{
  name: "민준 생일",
  month: 7,
  day: 20,
  calendar_kind: :gregorian
})

Itch.Resource.Anniversary.upsert!(%{
  name: "할머니 생신",
  month: 11,
  day: 18,
  calendar_kind: :lunisolar
})

Itch.Resource.Anniversary.upsert!(%{
  name: "아버지 생신",
  month: 6,
  day: 18,
  calendar_kind: :lunisolar
})

Itch.Resource.Anniversary.upsert!(%{
  name: "어머니 생신",
  month: 6,
  day: 13,
  calendar_kind: :lunisolar
})
