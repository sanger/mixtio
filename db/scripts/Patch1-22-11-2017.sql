-- This patch script is the first for Mixtio, it created the "Patch" user as a
-- member of the DEV team
-- It then creates a batch with ID 2289, to become parent to the orphaned consumables
-- that belonged to that batch

-- "mixtio" should be changed to the actual database name

-- Get ID of dev team
SET @team_id := (SELECT id FROM kitchens WHERE name = "DEV");

-- Create patch user
INSERT INTO `mixtio_production`.users (username, team_id, created_at, updated_at)
	VALUES ('Patch', @team_id, NOW(), NOW());

SET @patch_user_id := (SELECT id FROM users WHERE username = "Patch");

-- Create batch with id 2289
INSERT INTO `mixtio_production`.ingredients (id, consumable_type_id, kitchen_id, created_at, updated_at, number, expiry_date, user_id, editable, type)
	VALUES (2289, 97, 86, NOW(), NOW(), "PATCH-2289", "2017-12-25", @patch_user_id, 0, "Batch");
