### Create dataset

## variables
dataset_name='student'
tables_path='./tables/'

tables=$(ls $tables_path)
tables_array=($tables)
tables_count=${#tables_array[@]}
index=0
create_table_query=""

## drop dataset if exists
bq rm -r -f -d $dataset_name

## create dataset
bq --location=us-west2 mk -d $dataset_name

### create tables in loop

for fileName in $tables; do
  tableName=$(echo $fileName | sed 's/.json//g')
  index=$(expr $index + 1)
  create_table_query=$create_table_query" bq mk --table $dataset_name.$tableName $tables_path/$fileName"

  ## build table creation query
  if [ $index -ne $tables_count ]; then
    create_table_query=$create_table_query" |"
  fi
done

# execute all queries in parallel
eval $create_table_query
