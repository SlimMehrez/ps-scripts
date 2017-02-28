#Check SQL DB index fragmentation
#https://gallery.technet.microsoft.com/scriptcenter/Check-SQL-Server-a-a5758043
#Corrective actions:
#https://msdn.microsoft.com/en-us/library/ms189858.aspx
# > 5% and < = 30% ->	ALTER INDEX REORGANIZE
# > 30%	           -> ALTER INDEX REBUILD WITH (ONLINE = ON)

SELECT OBJECT_NAME(ind.OBJECT_ID) AS TableName, 
ind.name AS IndexName, indexstats.index_type_desc AS IndexType, 
indexstats.avg_fragmentation_in_percent 
FROM sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) indexstats 
INNER JOIN sys.indexes ind  
ON ind.object_id = indexstats.object_id 
AND ind.index_id = indexstats.index_id 
WHERE indexstats.avg_fragmentation_in_percent > 30 
ORDER BY indexstats.avg_fragmentation_in_percent DESC