package channels

import (
	"context"

	"github.com/jackc/pgx/v5/pgxpool"
)

const listChannelsQuery = `
SELECT id, code, name, initially_visible, display_order
FROM channels
ORDER BY display_order ASC`

type PostgresRepository struct {
	pool *pgxpool.Pool
}

func NewPostgresRepository(pool *pgxpool.Pool) *PostgresRepository {
	return &PostgresRepository{pool: pool}
}

func (r *PostgresRepository) List(ctx context.Context) ([]Channel, error) {
	rows, err := r.pool.Query(ctx, listChannelsQuery)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	items := make([]Channel, 0, len(expectedCatalog))
	for rows.Next() {
		var item Channel
		if err := rows.Scan(&item.ID, &item.Code, &item.Name, &item.InitiallyVisible, &item.DisplayOrder); err != nil {
			return nil, err
		}
		items = append(items, item)
	}
	if err := rows.Err(); err != nil {
		return nil, err
	}
	return items, nil
}
