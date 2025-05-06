defmodule PersonApiWeb.ErrorHelpers do
  @moduledoc """
  Conveniências para traduzir e construir mensagens de erro.
  """

  @doc """
  Transforma uma mensagem de erro em uma mensagem legível.

  Exemplo:
    {:greater_than, 18} => "must be greater than 18"
  """

  def translate_error({msg, opts}) do
    Enum.reduce(opts, msg, fn {key, value}, acc ->
      String.replace(acc, "%{#{key}}", to_string(value))
    end)
  end
end
