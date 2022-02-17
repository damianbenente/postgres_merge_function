# postgres_merge_function
Function for merging parent record and update child's foreign key to parent

Test it before use, use it at your own risk!!!!
Barely tested in yugabyte 2.11 (postgres 11)


merge_all(var_table_name, var_id1, var_id2) without delete
merge_all(var_table_name, var_id1, var_id2, var_delete) with delete



var_table_name is the table name with the parent records the function find the tables with foreign  keys pointing to this table with var_id2 and move to var_id1

var_id1 ID from var_table_name to keep

var_id2 id from var_table_name to move relationships to var_id1 (if the function merge all is set with 4 arguments, var_delete set to 'delete' will delete the record with var_id2 in var_table_name)

var_delete must be set to 'delete' to delete the var_id2 from var_table_name.





It would be nice to have to a check before delete to test if the record have columns with data other than ID to prevent delete useful information

