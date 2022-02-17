CREATE OR REPLACE FUNCTION merge_all(var_table_name text, var_id1 text, var_id2 text, var_delete text) RETURNS void AS $$
DECLARE
   var_constraint_name text;
   var_foreing_key_names text[];
   var_rec2 record;
   var_temp record;
   var_to_delete record;
   var_delete_result record;
begin
	if var_delete != 'delete' then
		raise exception 'var_delete argument need to be ''delete'' ' ;
	else
	if var_id1 = var_id2 then
		raise exception 'id1 = id2' ;
	else 

    	select constraint_name into var_constraint_name from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where table_name = var_table_name  and constraint_type = 'PRIMARY KEY';
  		--raise info 'information message %', var_constraint_name ;
  
  		select array_agg(constraint_name) into var_foreing_key_names from INFORMATION_SCHEMA.REFERENTIAL_CONSTRAINTS where unique_constraint_name = var_constraint_name;
  		--raise info 'information message %',  var_foreing_key_names ;

     	for var_rec2 in select table_name, column_name from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where constraint_name = any (var_foreing_key_names)
 			loop 
  				EXECUTE 'UPDATE ' || quote_ident(var_rec2.table_name) || ' SET ' || quote_ident(var_rec2.column_name) || ' = ' || quote_literal(var_id1) || ' WHERE ' || quote_ident(var_rec2.column_name) || ' = ' || quote_literal(var_id2) || ' returning * ' 
    			INTO var_temp;
    			raise info 'information message %', array_agg(var_temp) ;
  			end loop;
	--delete part
  		
  		select table_name, column_name into var_to_delete from INFORMATION_SCHEMA.KEY_COLUMN_USAGE where constraint_name = (select constraint_name from INFORMATION_SCHEMA.TABLE_CONSTRAINTS where table_name = var_table_name and constraint_type = 'PRIMARY KEY');
  		EXECUTE 'DELETE FROM ' || quote_ident(var_to_delete.table_name) || ' WHERE ' || quote_ident(var_to_delete.column_name) || ' = ' || quote_literal(var_id2) || ' returning * ' INTO var_delete_result;
        	raise info 'information message delete result %', array_agg(var_delete_result) ;

  		
  	-- end delete part
  		
	END if;
END if;
END;
$$ LANGUAGE plpgsql;