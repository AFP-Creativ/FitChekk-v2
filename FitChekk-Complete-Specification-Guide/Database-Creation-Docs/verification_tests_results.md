Test 1
| column_name         | data_type                | is_nullable | column_default |
| ------------------- | ------------------------ | ----------- | -------------- |
| id                  | uuid                     | NO          | null           |
| email               | text                     | YES         | null           |
| display_name        | text                     | YES         | null           |
| subscription_tier   | text                     | NO          | 'free'::text   |
| subscription_status | text                     | YES         | null           |
| trial_ends_at       | timestamp with time zone | YES         | null           |
| created_at          | timestamp with time zone | NO          | now()          |
| updated_at          | timestamp with time zone | NO          | now()          |                                                               |

Test 2
| table_name       | column_count |
| ---------------- | ------------ |
| outfits          | 18           |
| planner_entries  | 13           |
| user_preferences | 14           |
| users            | 43           |
| wardrobe_items   | 26           |

Test 3
| schemaname | tablename        | policyname                       | permissive | roles    | cmd    |
| ---------- | ---------------- | -------------------------------- | ---------- | -------- | ------ |
| public     | outfits          | Users can manage own outfits     | PERMISSIVE | {public} | ALL    |
| public     | planner_entries  | Users can manage own planner     | PERMISSIVE | {public} | ALL    |
| public     | user_preferences | Users can manage own preferences | PERMISSIVE | {public} | ALL    |
| public     | users            | Users can update own profile     | PERMISSIVE | {public} | UPDATE |
| public     | users            | Users can view own profile       | PERMISSIVE | {public} | SELECT |
| public     | wardrobe_items   | Users can manage own wardrobe    | PERMISSIVE | {public} | ALL    |

Test 4
| table_name       | column_name | foreign_table_name | foreign_column_name | delete_rule |
| ---------------- | ----------- | ------------------ | ------------------- | ----------- |
| outfits          | user_id     | users              | id                  | CASCADE     |
| planner_entries  | outfit_id   | outfits            | id                  | SET NULL    |
| planner_entries  | user_id     | users              | id                  | CASCADE     |
| user_preferences | user_id     | users              | id                  | CASCADE     |
| wardrobe_items   | user_id     | users              | id                  | CASCADE     |

Test 5
| schemaname | tablename        | indexname                        | indexdef                                                                                                   |
| ---------- | ---------------- | -------------------------------- | ---------------------------------------------------------------------------------------------------------- |
| public     | outfits          | idx_outfits_user_id              | CREATE INDEX idx_outfits_user_id ON public.outfits USING btree (user_id)                                   |
| public     | outfits          | outfits_pkey                     | CREATE UNIQUE INDEX outfits_pkey ON public.outfits USING btree (id)                                        |
| public     | planner_entries  | idx_planner_entries_user_date    | CREATE INDEX idx_planner_entries_user_date ON public.planner_entries USING btree (user_id, date)           |
| public     | planner_entries  | planner_entries_pkey             | CREATE UNIQUE INDEX planner_entries_pkey ON public.planner_entries USING btree (id)                        |
| public     | planner_entries  | planner_entries_user_id_date_key | CREATE UNIQUE INDEX planner_entries_user_id_date_key ON public.planner_entries USING btree (user_id, date) |
| public     | user_preferences | user_preferences_pkey            | CREATE UNIQUE INDEX user_preferences_pkey ON public.user_preferences USING btree (id)                      |
| public     | user_preferences | user_preferences_user_id_key     | CREATE UNIQUE INDEX user_preferences_user_id_key ON public.user_preferences USING btree (user_id)          |
| public     | users            | users_pkey                       | CREATE UNIQUE INDEX users_pkey ON public.users USING btree (id)                                            |
| public     | wardrobe_items   | idx_wardrobe_items_category      | CREATE INDEX idx_wardrobe_items_category ON public.wardrobe_items USING btree (category)                   |
| public     | wardrobe_items   | idx_wardrobe_items_is_archived   | CREATE INDEX idx_wardrobe_items_is_archived ON public.wardrobe_items USING btree (is_archived)             |
| public     | wardrobe_items   | idx_wardrobe_items_user_id       | CREATE INDEX idx_wardrobe_items_user_id ON public.wardrobe_items USING btree (user_id)                     |
| public     | wardrobe_items   | wardrobe_items_pkey              | CREATE UNIQUE INDEX wardrobe_items_pkey ON public.wardrobe_items USING btree (id)                          |

Test 6
| schema_name | function_name            | return_type | arguments |
| ----------- | ------------------------ | ----------- | --------- |
| public      | handle_new_user          | trigger     |           |
| public      | update_updated_at_column | trigger     |           |

Test 7
| table_name       | trigger_name                       | trigger_event | action_timing |
| ---------------- | ---------------------------------- | ------------- | ------------- |
| outfits          | update_outfits_updated_at          | UPDATE        | BEFORE        |
| planner_entries  | update_planner_entries_updated_at  | UPDATE        | BEFORE        |
| user_preferences | update_user_preferences_updated_at | UPDATE        | BEFORE        |
| users            | on_auth_user_created               | INSERT        | AFTER         |
| users            | update_users_updated_at            | UPDATE        | BEFORE        |
| wardrobe_items   | update_wardrobe_items_updated_at   | UPDATE        | BEFORE        |

Test 8
| schemaname | tablename        | rls_enabled |
| ---------- | ---------------- | ----------- |
| public     | outfits          | true        |
| public     | planner_entries  | true        |
| public     | user_preferences | true        |
| public     | users            | true        |
| public     | wardrobe_items   | true        |

Test 9
| table_name       | column_name       | data_type | udt_name |
| ---------------- | ----------------- | --------- | -------- |
| outfits          | item_ids          | ARRAY     | _uuid    |
| user_preferences | favorite_colors   | ARRAY     | _text    |
| user_preferences | occasions         | ARRAY     | _text    |
| user_preferences | style_preferences | ARRAY     | _text    |
| wardrobe_items   | colors            | ARRAY     | _text    |
| wardrobe_items   | seasons           | ARRAY     | _text    |
| wardrobe_items   | style_tags        | ARRAY     | _text    |

Test 10
| table_name       | constraint_name                 | check_clause                                                                                          |
| ---------------- | ------------------------------- | ----------------------------------------------------------------------------------------------------- |
| outfits          | 2200_17517_16_not_null          | item_ids IS NOT NULL                                                                                  |
| outfits          | 2200_17517_17_not_null          | created_at IS NOT NULL                                                                                |
| outfits          | 2200_17517_18_not_null          | updated_at IS NOT NULL                                                                                |
| outfits          | 2200_17517_1_not_null           | id IS NOT NULL                                                                                        |
| outfits          | 2200_17517_2_not_null           | user_id IS NOT NULL                                                                                   |
| outfits          | 2200_17517_3_not_null           | name IS NOT NULL                                                                                      |
| outfits          | outfits_user_rating_check       | ((user_rating >= 1) AND (user_rating <= 5))                                                           |
| planner_entries  | 2200_17536_12_not_null          | created_at IS NOT NULL                                                                                |
| planner_entries  | 2200_17536_13_not_null          | updated_at IS NOT NULL                                                                                |
| planner_entries  | 2200_17536_1_not_null           | id IS NOT NULL                                                                                        |
| planner_entries  | 2200_17536_2_not_null           | user_id IS NOT NULL                                                                                   |
| planner_entries  | 2200_17536_3_not_null           | date IS NOT NULL                                                                                      |
| user_preferences | 2200_17470_13_not_null          | created_at IS NOT NULL                                                                                |
| user_preferences | 2200_17470_14_not_null          | updated_at IS NOT NULL                                                                                |
| user_preferences | 2200_17470_1_not_null           | id IS NOT NULL                                                                                        |
| user_preferences | 2200_17470_2_not_null           | user_id IS NOT NULL                                                                                   |
| users            | 2200_17453_1_not_null           | id IS NOT NULL                                                                                        |
| users            | 2200_17453_4_not_null           | subscription_tier IS NOT NULL                                                                         |
| users            | 2200_17453_7_not_null           | created_at IS NOT NULL                                                                                |
| users            | 2200_17453_8_not_null           | updated_at IS NOT NULL                                                                                |
| users            | users_subscription_status_check | (subscription_status = ANY (ARRAY['active'::text, 'canceled'::text, 'expired'::text, 'trial'::text])) |
| users            | users_subscription_tier_check   | (subscription_tier = ANY (ARRAY['free'::text, 'premium'::text]))                                      |
| wardrobe_items   | 2200_17493_1_not_null           | id IS NOT NULL                                                                                        |
| wardrobe_items   | 2200_17493_25_not_null          | created_at IS NOT NULL                                                                                |
| wardrobe_items   | 2200_17493_26_not_null          | updated_at IS NOT NULL                                                                                |
| wardrobe_items   | 2200_17493_2_not_null           | user_id IS NOT NULL                                                                                   |
| wardrobe_items   | 2200_17493_4_not_null           | category IS NOT NULL                                                                                  |
| wardrobe_items   | 2200_17493_5_not_null           | sub_category IS NOT NULL                                                                              |
| wardrobe_items   | wardrobe_items_formality_check  | ((formality >= 1) AND (formality <= 5))                                                               |