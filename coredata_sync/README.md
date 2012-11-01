[github > na_ios > coredata_sync](https://github.com/nashibao/na_ios)

# settings

### server side settings
- `updated_at` : update time
- `pk` (guid) : identifier which is unique belong all devices.
- `is_active` (is_deleted)
- `is_conflicted`(transient, default=false)

### client side settings
- `updated_at`: the same as server side
- `pk`: the same as server side
- `sync_state` (default=`SYNCD`, `EDITED`, `DELETED`, `CREATED`) : `SYNCD` just after syncing to server data. when modified data in client side, this param won't be `SYNCD` state.
- `data` (json)：raw data from server.
- `edited_data` (json, transient?)：store the edited field and values which is caused in client side.
- `is_uploading` (transient, default=false): for row level lock while syncing. ( **!!!deprecated!!!** no more use of the param in this package.)

# diagram

![diagram](https://dl.dropbox.com/u/151205/sync_diagram.jpg)

### 1. client side

1. start!
- `max_updated_at` = MAX(`updated_at` in items)
- (if `sync_state` == `SYNCED`)
    - get with `max_updated_at`
- (if `sync_state` != `SYNCED`)
    - post(put, delete) with `edited_data` and `max_updated_at`

### 2. server side

1. (if get method) -> 
    - `is_conflicted` = false
3. (if post method) ->
    - `is_conflicted` = `max_updated_at` < `updated_at`
5. (if `is_conflicted` == true)
    - take the `edited_data`
5. return [item ∈ `max_updated_at` < `updated_at`]
6. or return `error`

### 3. client side

1. (`is_conflicted` == true)
    - jump to 4
3. (`is_conflicted` == fale)
	1. (`sync_state` == `SYNCED`)
    	- renew `data`
    	- renew `update_at`
    	- `sync_state` = `SYNCED`
    	- `edited_data` = nil
	1. (`sync_state` != `SYNCED`)
		1. (server-`updated_at` > client-`updated_at` )
			- jump to 4
		2. (server-`updated_at` == client-`updated_at` )
			- jump to 1.5
4. (if `error` exists)
	1. retry
		- jump to 1
	2. resign
    	- `sync_state` = `SYNCED`
    	- `edited_data` = nil

### 4. conflict tactics

1. take the server side data
    - jump to 3.2
- take the client side data
    - renew `update_at`
    - jump to 1.4
- inform to user
    - jump to 4.1
    - jump to 4.2
- auto merge
    - renew `update_at`
    - renew `data` by `data` from server
    - modified by `edited_data`
    - jump to 1.5