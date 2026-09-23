-- name: ListChannels :many
SELECT id, code, name, initially_visible, display_order
FROM channels
ORDER BY display_order ASC;
