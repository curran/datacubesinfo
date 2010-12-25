package org.curransoft.datacubesinfo

class DataTableEntry {
    static belongsTo = [column:DataTableColumn,row:DataTableRow]
    
    String value
    static constraints = {
    }
    String toString() { "value:${value}" }//, column:${column.name}, row:${row.id}
}
