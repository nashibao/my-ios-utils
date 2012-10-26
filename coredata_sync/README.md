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
- `is_uploading` (transient, default=false): for row level lock while syncing.

# diagram

![diagram](https://dl.dropbox.com/u/151205/sync_diagram.jpg)

### 1. client side

1. start!
- `is_uploading` = true
- `max_updated_at` = MAX(`updated_at` in items)
- (if `sync_state` == `SYNCED`)
    - get
- (if `sync_state` != `SYNCED`)
    - post(put, delete)

### 2. server side

1. (if get method) -> 
    - `is_conflicted` = false
3. (if post method) ->
    - `is_conflicted` = `max_updated_at` < `updated_at`
5. (if `is_conflicted` == true)
    - 変更を適用
5. return [item ∈ `max_updated_at` < `updated_at`]

### 3. client side

1. (`is_conflicted` == true)
    - jump to 4
3. (`is_conflicted` == fale)
    - renew `data`
    - renew `update_at`
    - `sync_state` = `SYNCED`
    - `edited_data` = nil
    - `is_uploading` = false

### 4. conflict tactics

1. take the server side data
    - jump to 3.2
- take the client side data
    - renew `update_at`
    - jump to 1.5
- inform to user
    - jump to 4.1
    - jump to 4.2
- auto merge
    - renew `update_at`
    - renew `data` by `data` from server
    - modified by `edited_data`
    - jump to 1.5