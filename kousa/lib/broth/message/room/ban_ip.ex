defmodule Broth.Message.Room.BanIp do
  use Broth.Message.Call

  @primary_key false
  embedded_schema do
    field(:userId, :binary_id)
  end

  alias Kousa.Utils.UUID

  def changeset(initializer \\ %__MODULE__{}, data) do
    initializer
    |> cast(data, [:userId])
    |> validate_required([:userId])
    |> UUID.normalize(:userId)
  end

  defmodule Reply do
    use Broth.Message.Push
  end

  def execute(changeset, state) do
    with {:ok, %{userId: user_id}} <- apply_action(changeset, :validate) do
      # TODO: change to auth: format.
      Kousa.Room.block_from_room(state.user_id, user_id)
      {:reply, %{}, state}
    end
  end
end
