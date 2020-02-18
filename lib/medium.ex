defmodule Medium do
  def start_link do
    GenServer.start_link(__MODULE__, %{})
  end

  def top_list(server) do
    GenServer.cast(server, {:top_list})

    GenServer.call(server, {:top_list, ""})
  end

  def read(server, post_id) do
    GenServer.cast(server, {:get, post_id})

    case GenServer.call(server, {:get, post_id}) do
      {:ok, data} -> IO.puts data.content
      _ -> IO.puts "ID Not found"
    end
  end

  def init(state \\ %{}) do
    {:ok, state}
  end

  def check_data(server) do
    GenServer.call(server, :data)
  end

  def handle_call(:data, _from, state) do
    {:reply, state, state}
  end

  def handle_cast({:top_list}, state) do
    new_state =
      case  Enum.count(state) do
      0 -> Worker.top_list()
      _ -> state
      end
    {:noreply, new_state}
  end

  def handle_cast({:get, post_id}, state) do
   new_state = case Map.fetch(state, String.to_atom(post_id)) do
      {:ok, post} ->
        case Map.fetch(post, :content) do
          :error -> Map.put(state, String.to_atom(post_id), Map.put(post, :content, read_post(post.url)))
          _ -> state
        end
      _ ->
        state
    end
    {:noreply, new_state}
  end

  def handle_call({action, post_id}, _from, state) do
    case action do
      :get ->
        {:reply, Map.fetch(state, String.to_atom(post_id)), state}
      :top_list ->
        {:reply, state, state}
    end
  end

  def read_post(post_url), do: Worker.post(post_url)
end
