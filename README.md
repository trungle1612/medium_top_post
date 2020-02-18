# Medium rss
# This repo will display the newest pots on medium about software engineering.

## Note
- In this repo I used GenServer to save the data crawled to improve performance.
## Run

```elixir
# make new process
{:ok, pid} = Medium.start_link

# Get Top list
# If data not exists in state, this app will crawl and save to state
# If data existsed in state, this app just call from state
Medium.top_list(pid)

# Read a post
# If post not exists in state, this app will crawl and save to state
# If post existsed in state, this app just call from state
Medium.read(pid, post_id)

## Check data
Medium.check_data(pid)
```
