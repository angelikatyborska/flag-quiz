defmodule FlagQuiz.Repo do
  use Ecto.Repo,
    otp_app: :flag_quiz,
    adapter: Ecto.Adapters.Postgres
end
