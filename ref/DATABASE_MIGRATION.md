# Database Consolidation Instructions

## Overview
The application has been updated to use a single database instead of two separate databases. The warehouse functionality now uses the main database.

## New Database Configuration
- **Database Name**: `teamcorperation_main`
- **User**: `teamcorperation_db_user`
- **Password**: `Thoumas138!`

## Migration Steps

### 1. Use the improved SQL file
A complete migration SQL file has been created: `db_will_be_migrated_improved.sql`

This file includes:
- CREATE TABLE statement for dc_warehouse
- De-duplicated INSERT statements
- Proper handling of NULL ID values with AUTO_INCREMENT
- ON DUPLICATE KEY UPDATE to handle existing data

### 2. Run the migration
Connect to your MySQL server and run:

```bash
mysql -u teamcorperation_db_user -p'Thoumas138!' teamcorperation_main < db_will_be_migrated_improved.sql
```

### 3. Migrate other tables from the old database
You'll need to export and import other tables:

```bash
# Export schema and data from old database (excluding dc_warehouse since we already have it)
mysqldump -u [old_user] -p --ignore-table=yoon_teamcorperation_discovery_1.dc_warehouse yoon_teamcorperation_discovery_1 > other_tables.sql

# Import into new database
mysql -u teamcorperation_db_user -p'Thoumas138!' teamcorperation_main < other_tables.sql
```

### 4. Verify the migration
```sql
-- Connect to the new database
mysql -u teamcorperation_db_user -p'Thoumas138!' teamcorperation_main

-- Check all tables
SHOW TABLES;

-- Verify dc_warehouse data
SELECT COUNT(*) FROM dc_warehouse;
SELECT * FROM dc_warehouse ORDER BY id DESC LIMIT 5;
```

## Code Changes Made

1. **src/index.js**: Updated WHQuery to use the main database pool
2. **src/database.js**: Removed warehouse database connection, now exports the main pool for both

## Testing
After migrating the database:
1. Access the warehouse admin page at `/warehouse`
2. Test adding, editing, and removing warehouse entries
3. Verify all functionality works as expected

## Note
The migration script `src/migrate-warehouse.js` can be deleted after successful migration.